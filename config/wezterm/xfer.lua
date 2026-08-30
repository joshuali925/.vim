local wezterm = require("wezterm")

local xfer = {}
local transfers = {}
local uploads = {}
local bootstraps = {}
local bootstrap_chunk_size = 1024
local upload_batch_size = 1024
local upload_read_size = upload_batch_size // 4 * 3
local upload_ack_timeout = 30
local paste_submit_delay = 0.05
local upload_prepare_poll_interval = 0.05
local download_directory = wezterm.home_dir .. "/Downloads"

local function pane_id(pane) return tostring(pane:pane_id()) end

local function one_line(text, limit)
    return (tostring(text):gsub("%c", " ")):sub(1, limit)
end

local function shell_quote(text)
    return "'" .. text:gsub("'", "'\\''") .. "'"
end

local function trim(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function safe_name(name)
    name = (name:match("([^/\\]+)$") or ""):gsub("[:%c]", "_"):gsub("[^%w%._%-]", "_")
    if name == "" or name == "." or name == ".." then return "wezterm-transfer.tar.gz" end
    return name:sub(1, 200)
end

local function send_response(pane, kind, id, ...)
    local fields = { "#WTX1", kind, id }
    for index = 1, select("#", ...) do
        fields[#fields + 1] = tostring(select(index, ...))
    end
    fields[#fields + 1] = ""
    return pcall(pane.send_text, pane, "\x15 " .. table.concat(fields, "|") .. "\r")
end

local function decoded_length(text)
    return #text // 4 * 3 - (text:sub(-2) == "==" and 2 or text:sub(-1) == "=" and 1 or 0)
end

local base64_alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function base64_encode(text)
    local encoded = {}
    for index = 1, #text, 3 do
        local first = text:byte(index)
        local second = text:byte(index + 1)
        local third = text:byte(index + 2)
        local value = first * 65536 + (second or 0) * 256 + (third or 0)
        encoded[#encoded + 1] = base64_alphabet:sub(value // 262144 % 64 + 1, value // 262144 % 64 + 1)
        encoded[#encoded + 1] = base64_alphabet:sub(value // 4096 % 64 + 1, value // 4096 % 64 + 1)
        encoded[#encoded + 1] = second and
            base64_alphabet:sub(value // 64 % 64 + 1, value // 64 % 64 + 1) or "="
        encoded[#encoded + 1] = third and
            base64_alphabet:sub(value % 64 + 1, value % 64 + 1) or "="
    end
    return table.concat(encoded)
end

local function format_bytes(bytes)
    local units, value, unit = { "B", "KiB", "MiB", "GiB", "TiB" }, bytes, 1
    while value >= 1024 and unit < #units do
        value, unit = value / 1024, unit + 1
    end
    if unit == 1 then return ("%d %s"):format(value, units[unit]) end
    return ("%.1f %s"):format(value, units[unit])
end

local function format_duration(seconds)
    return ("%02d:%02d:%02d"):format(seconds // 3600, seconds // 60 % 60, seconds % 60)
end

local function send_commands(pane, commands, trailing_text, on_complete)
    local index = 1
    local finished = false
    local function finish(ok, error_message)
        if finished then return end
        finished = true
        on_complete(ok, error_message)
    end
    local function send_next()
        if index > #commands then
            local ok, error_message = pcall(pane.send_paste, pane, trailing_text)
            return finish(ok, error_message)
        end
        local command = commands[index]
        index = index + 1
        local ok, error_message = pcall(pane.send_paste, pane, " " .. command)
        if not ok then return finish(false, error_message) end
        ok, error_message = pcall(wezterm.time.call_after, paste_submit_delay, function()
            local sent, send_error = pcall(pane.send_text, pane, "\r")
            if not sent then return finish(false, send_error) end
            send_next()
        end)
        if not ok then finish(false, error_message) end
    end
    send_next()
end

local function close_stream(state, stream_field, pid_field)
    local stream = state[stream_field]
    if not stream then return true end
    state[stream_field] = nil
    local called, closed, reason, status = pcall(stream.close, stream)
    if pid_field and state[pid_field] then
        os.remove(state[pid_field])
        state[pid_field] = nil
    end
    if called and closed then return true end
    if not called then return nil, tostring(closed) end
    return nil, status and ("%s %s"):format(tostring(reason), tostring(status)) or tostring(reason)
end

local function path_exists(path)
    local file = io.open(path, "rb")
    if not file then return false end
    file:close()
    return true
end

local function stop_transfer(state)
    close_stream(state, "decoder", "decoder_pid_path")
    transfers[state.pane_id] = nil
end

local function terminate_stream(stream, pid_path, cleanup)
    local attempts = 0
    local function finish()
        if stream then pcall(stream.close, stream) end
        if pid_path then os.remove(pid_path) end
        if cleanup then cleanup() end
    end
    if not stream then return finish() end

    local function signal()
        attempts = attempts + 1
        local file = pid_path and io.open(pid_path, "r")
        local pid = file and file:read("*l")
        if file then file:close() end
        pid = pid and pid:match("^%d+$") and tonumber(pid) > 1 and pid or nil
        if not pid and attempts < 200 then
            return wezterm.time.call_after(0.025, signal)
        end
        if not pid then return finish() end

        pcall(wezterm.run_child_process, { "kill", "-TERM", tostring(pid) })
        wezterm.time.call_after(0.1, function()
            pcall(wezterm.run_child_process, { "kill", "-KILL", tostring(pid) })
            wezterm.time.call_after(0.01, finish)
        end)
    end
    wezterm.time.call_after(0.01, signal)
end

local function cancel_transfer(state)
    transfers[state.pane_id] = nil
    local decoder, pid_path = state.decoder, state.decoder_pid_path
    state.decoder, state.decoder_pid_path = nil, nil
    terminate_stream(decoder, pid_path)
end

local function abort_transfer(window, pane, state, reason, message)
    stop_transfer(state)
    send_response(pane, "C", state.id, reason)
    if state.temp_path and path_exists(state.temp_path) then
        message = message .. "\nPartial download kept at " .. state.temp_path
    end
    window:toast_notification("WezTerm transfer failed", message, nil, 6000)
end

local function monitor(registry, state, cancel)
    wezterm.time.call_after(1, function()
        if registry[state.pane_id] ~= state then return end
        local ok, pane = pcall(wezterm.mux.get_pane, state.pane_id)
        if not ok or not pane then return cancel(state) end
        monitor(registry, state, cancel)
    end)
end

local function available_final_path(name)
    local path = download_directory .. "/" .. name
    if not path_exists(path) then return path end
    for index = 1, 999 do
        local candidate = path .. "." .. index
        if not path_exists(candidate) then return candidate end
    end
end

local function sha256_file(path)
    local commands = {
        { "shasum", "-a", "256", path },
        { "sha256sum", path },
    }
    local last_error = "SHA-256 command failed"
    for _, command in ipairs(commands) do
        local ok, output, error_message = wezterm.run_child_process(command)
        if ok then
            local digest = (output or ""):match("^%s*(%x+)")
            if digest and #digest == 64 then return digest:lower() end
            last_error = "SHA-256 command returned an invalid digest"
        elseif error_message and error_message ~= "" then
            last_error = one_line(error_message, 160)
        end
    end
    return nil, last_error
end

local function begin_transfer(window, pane, id, name, size_text, expected_sha256, label)
    local id_for_pane = pane_id(pane)
    if transfers[id_for_pane] then
        return send_response(pane, "C", id, "another_transfer_is_active")
    end
    if #id > 80 or not id:match("^[%w%._%-]+$") then
        return send_response(pane, "C", id, "invalid_transfer_id")
    end
    local expected_size = tonumber(size_text)
    if not expected_size or expected_size < 0 or #expected_sha256 ~= 64 then
        return send_response(pane, "C", id, "invalid_metadata")
    end

    local state = {
        id = id,
        pane_id = id_for_pane,
        name = safe_name(name),
        expected_size = expected_size,
        expected_sha256 = expected_sha256:lower(),
        sequence = 0,
        bytes = 0,
    }
    transfers[id_for_pane] = state
    monitor(transfers, state, cancel_transfer)

    window:perform_action(
        wezterm.action.PromptInputLine({
            description = ("Receive %s (%d bytes) from %s?\nPress Enter to accept or Escape to reject.")
                :format(state.name, expected_size, one_line(label, 200)),
            action = wezterm.action_callback(function(prompt_window, _, line)
                if transfers[id_for_pane] ~= state then return end
                if line == nil then
                    transfers[id_for_pane] = nil
                    return send_response(pane, "C", id, "declined")
                end

                local made_directory, _, directory_error =
                    wezterm.run_child_process({ "mkdir", "-p", download_directory })
                if not made_directory then
                    return abort_transfer(prompt_window, pane, state, "download_directory_failed", "Cannot create download directory: " .. one_line(directory_error or "", 160))
                end
                state.temp_path = download_directory .. "/" .. state.name .. ".part"
                for _, active in pairs(transfers) do
                    if active ~= state and active.temp_path == state.temp_path then
                        return abort_transfer(prompt_window, pane, state, "staging_file_busy", "Another transfer is using " .. state.temp_path)
                    end
                end
                local resume_sha256 = ""
                local existing = io.open(state.temp_path, "rb")
                if existing then
                    local size, size_error = existing:seek("end")
                    existing:close()
                    if not size then
                        return abort_transfer(prompt_window, pane, state, "staging_file_failed", "Cannot inspect staging file: " .. tostring(size_error))
                    end
                    state.bytes = size
                    if size > 0 then
                        local hash_error
                        resume_sha256, hash_error = sha256_file(state.temp_path)
                        if not resume_sha256 then
                            return abort_transfer(prompt_window, pane, state, "staging_hash_failed", "Cannot hash staging file: " .. tostring(hash_error))
                        end
                    end
                end
                local decoder_pid_path = os.tmpname()
                local decoder_script = [[
pid_path=$1
output_path=$2
printf '%s\n' "$$" > "$pid_path" || exit 1
exec base64 -d >> "$output_path"
]]
                local decoder, decoder_error = io.popen(
                    "exec sh -c " .. shell_quote(decoder_script) ..
                    " xfer-decoder " .. shell_quote(decoder_pid_path) ..
                    " " .. shell_quote(state.temp_path) .. " 2>/dev/null",
                    "w"
                )
                if not decoder then
                    os.remove(decoder_pid_path)
                    return abort_transfer(prompt_window, pane, state, "decoder_failed", "Cannot start base64 decoder: " .. tostring(decoder_error))
                end
                state.decoder = decoder
                state.decoder_pid_path = decoder_pid_path
                state.accepted = true
                send_response(pane, "A", id, 0, state.bytes, resume_sha256)
            end),
        }),
        pane
    )
end

local function active_transfer(pane, id)
    local state = transfers[pane_id(pane)]
    if state and state.id == id and state.accepted then return state end
    send_response(pane, "C", id, "no_active_transfer")
end

local function receive_chunk(window, pane, id, sequence_text, chunk)
    local state = active_transfer(pane, id)
    if not state then return end
    local sequence = tonumber(sequence_text)
    if not sequence or sequence ~= state.sequence + 1 then
        return abort_transfer(window, pane, state, "invalid_sequence", "Received an out-of-order transfer chunk")
    end
    if chunk == "" or #chunk > 65536 or not chunk:match("^[A-Za-z0-9+/=]+$") then
        return abort_transfer(window, pane, state, "invalid_chunk", "Received invalid transfer data")
    end
    local chunk_bytes = decoded_length(chunk)
    if state.bytes + chunk_bytes > state.expected_size then
        return abort_transfer(window, pane, state, "size_overflow", "Transfer exceeds the declared archive size")
    end
    for _, step in ipairs({ { state.decoder.write, "write", chunk }, { state.decoder.flush, "flush" } }) do
        local called, written, write_error = pcall(step[1], state.decoder, step[3])
        if not called or not written then
            return abort_transfer(window, pane, state, "write_failed", "Cannot " .. step[2] .. " transfer data: " .. tostring(called and write_error or written))
        end
    end
    state.sequence = sequence
    state.bytes = state.bytes + chunk_bytes
    send_response(pane, "A", id, sequence)
end

local function finish_transfer(window, pane, id, sequence_text)
    local state = active_transfer(pane, id)
    if not state then return end
    local sequence = tonumber(sequence_text)
    if not sequence or sequence ~= state.sequence then
        return abort_transfer(window, pane, state, "invalid_sequence", "Transfer ended with an invalid chunk count")
    end
    local closed, close_error = close_stream(state, "decoder", "decoder_pid_path")
    if not closed then
        return abort_transfer(window, pane, state, "decode_failed", "Cannot decode transfer: " .. tostring(close_error))
    end

    local file, file_error = io.open(state.temp_path, "rb")
    if not file then
        return abort_transfer(window, pane, state, "missing_file", "Cannot inspect transfer: " .. tostring(file_error))
    end
    local size = file:seek("end")
    file:close()
    if size ~= state.expected_size then
        return abort_transfer(window, pane, state, "size_mismatch", ("Downloaded %s bytes; expected %s"):format(tostring(size), tostring(state.expected_size)))
    end
    local digest, hash_error = sha256_file(state.temp_path)
    if not digest then
        return abort_transfer(window, pane, state, "hash_failed", "Cannot verify transfer: " .. tostring(hash_error))
    end
    if digest ~= state.expected_sha256 then
        return abort_transfer(window, pane, state, "hash_mismatch", "Downloaded archive failed SHA-256 verification")
    end

    local final_path = available_final_path(state.name)
    if not final_path then
        return abort_transfer(window, pane, state, "name_collision", "Cannot choose a final download path")
    end
    local moved, move_error = os.rename(state.temp_path, final_path)
    if not moved then
        return abort_transfer(window, pane, state, "rename_failed", "Cannot finalize download: " .. tostring(move_error))
    end
    state.temp_path = nil
    transfers[state.pane_id] = nil
    send_response(pane, "A", id, "E")
    window:toast_notification("WezTerm transfer complete", ("Downloaded %s (%d bytes)"):format(final_path, size), "file://" .. final_path, 6000)
end

local host_encoder_script = [[
parent=$1
name=$2
pid_path=$3
status_base=$pid_path.status
archive_path=$pid_path.archive
ready_path=$pid_path.ready
ready_tmp=$ready_path.tmp
printf '%s\n' "$$" > "$pid_path" || exit 1
cleanup_status() {
  rm -f "$status_base.1" "$status_base.2" "$status_base.3" "$status_base.4"
}
cleanup_output() {
  rm -f "$archive_path" "$ready_path" "$ready_tmp"
}
record_status() {
  status_path=$1
  shift
  "$@"
  stage_status=$?
  printf '%s\n' "$stage_status" > "$status_path"
}
cleanup_status
cleanup_output
record_status "$status_base.1" tar -C "$parent" -cf - -- "$name" |
  record_status "$status_base.2" gzip -n -c > "$archive_path" &
encoder_pid=$!
trap 'trap - HUP INT TERM; kill "$encoder_pid" 2>/dev/null; wait "$encoder_pid" 2>/dev/null; cleanup_status; cleanup_output; exit 143' HUP INT TERM
wait "$encoder_pid"
wait_status=$?
pipeline_status=0
status_index=1
while [ "$status_index" -le 2 ]; do
  status_value=
  status_path=$status_base.$status_index
  if ! IFS= read -r status_value < "$status_path"; then
    pipeline_status=1
  else
    case $status_value in
      ''|*[!0-9]*) pipeline_status=1 ;;
      *) [ "$status_value" -eq 0 ] || pipeline_status=1 ;;
    esac
  fi
  status_index=$((status_index + 1))
done
cleanup_status
if [ "$wait_status" -eq 0 ] && [ "$pipeline_status" -eq 0 ]; then
  total_bytes=$(wc -c < "$archive_path") || total_bytes=
  total_bytes=$(printf '%s' "$total_bytes" | tr -d '[:space:]')
  case $total_bytes in
    ''|*[!0-9]*) pipeline_status=1 ;;
  esac
fi
if [ "$wait_status" -eq 0 ] && [ "$pipeline_status" -eq 0 ] &&
  printf 'ok %s\n' "$total_bytes" > "$ready_tmp" &&
  mv -f "$ready_tmp" "$ready_path"; then
  exit 0
fi
rm -f "$archive_path"
printf '%s\n' error > "$ready_tmp" && mv -f "$ready_tmp" "$ready_path"
exit 1
]]

local function expand_host_path(path)
    if path == "~" then return wezterm.home_dir end
    if path:sub(1, 2) == "~/" then return wezterm.home_dir .. path:sub(2) end
    if path:sub(1, 1) ~= "/" then return wezterm.home_dir .. "/" .. path end
    return path
end

local function upload_ack_command(id, sequence, status, passthrough)
    local encoded = base64_encode(("%s|%s|%s"):format(id, sequence, status))
    if passthrough then
        return ([[printf '\033Ptmux;\033\033]1337;SetUserVar=wezterm_upload_ack=%s\007\033\134']])
            :format(encoded)
    end
    return ([[printf '\033]1337;SetUserVar=wezterm_upload_ack=%s\007']]):format(encoded)
end

local function upload_error(state, fallback)
    local file = state.error_path and io.open(state.error_path, "r")
    local message = file and file:read("*a") or ""
    if file then file:close() end
    message = one_line(message, 240)
    return message ~= "" and message or fallback
end

local function remove_upload_files(error_path, pid_path)
    if error_path then os.remove(error_path) end
    if not pid_path then return end
    os.remove(pid_path)
    for index = 1, 4 do os.remove(pid_path .. ".status." .. index) end
    os.remove(pid_path .. ".archive")
    os.remove(pid_path .. ".ready")
    os.remove(pid_path .. ".ready.tmp")
end

local function clear_upload(state)
    uploads[state.pane_id] = nil
    close_stream(state, "archive")
    close_stream(state, "encoder")
    remove_upload_files(state.error_path, state.pid_path)
end

local function cancel_upload(state)
    uploads[state.pane_id] = nil
    close_stream(state, "archive")
    local encoder, error_path, pid_path = state.encoder, state.error_path, state.pid_path
    state.encoder, state.error_path, state.pid_path = nil, nil, nil
    terminate_stream(encoder, pid_path, function()
        remove_upload_files(error_path, pid_path)
    end)
end

local fail_upload
local pump_upload
local poll_upload_preparation

local function report_upload_progress(state, complete)
    local now = os.time()
    if not complete and now <= state.last_report then return end
    state.last_report = now
    local elapsed = math.max(0, now - (state.started_at or now))
    local speed = elapsed > 0 and state.bytes // elapsed or 0
    local total = state.total_bytes or 0
    local remaining = math.max(0, total - state.bytes)
    local eta = remaining == 0 and format_duration(0) or
        speed > 0 and format_duration(math.ceil(remaining / speed)) or "--:--:--"
    local percent = total > 0 and math.min(1000, state.bytes * 1000 // total) or 0
    local message = ("%s / %s (%d.%d%%) | %s/s | elapsed %s | ETA %s")
        :format(
            format_bytes(state.bytes),
            format_bytes(total),
            percent // 10,
            percent % 10,
            format_bytes(speed),
            format_duration(elapsed),
            eta
        )
    state.window:toast_notification(complete and "WezTerm upload complete" or "WezTerm upload", complete and (message .. " | extracted into remote cwd") or message, nil, complete and 5000 or 1100)
end

local function send_upload_command(state, command, expected_ack, pending_bytes)
    state.waiting_for = tostring(expected_ack)
    state.pending_bytes = pending_bytes or 0
    state.wait_token = state.wait_token + 1
    local token = state.wait_token
    local cleared, clear_error = pcall(state.pane.send_text, state.pane, "\x15")
    if not cleared then
        return fail_upload(state, "Cannot clear the remote command line: " .. tostring(clear_error))
    end
    local pasted, paste_error = pcall(state.pane.send_paste, state.pane, " " .. command)
    if not pasted then
        return fail_upload(state, "Cannot paste upload command: " .. tostring(paste_error))
    end
    local scheduled, schedule_error = pcall(wezterm.time.call_after, paste_submit_delay, function()
        if uploads[state.pane_id] ~= state or state.wait_token ~= token or not state.waiting_for then
            return
        end
        local sent, send_error = pcall(state.pane.send_text, state.pane, "\r")
        if not sent then
            return fail_upload(state, "Cannot submit upload command: " .. tostring(send_error))
        end
        wezterm.time.call_after(upload_ack_timeout, function()
            if uploads[state.pane_id] == state and state.wait_token == token and state.waiting_for then
                fail_upload(state, "Remote upload acknowledgement timed out")
            end
        end)
    end)
    if not scheduled then
        return fail_upload(state, "Cannot schedule upload command: " .. tostring(schedule_error))
    end
end

fail_upload = function(state, message)
    cancel_upload(state)
    if state.remote_started then
        message = message .. "\nRemote partial kept as " .. state.staging_name
    end
    state.window:toast_notification("WezTerm upload failed", message, nil, 6000)
end

poll_upload_preparation = function(state)
    if uploads[state.pane_id] ~= state or state.phase ~= "preparing" then return end
    local ready = io.open(state.ready_path, "r")
    if not ready then
        return wezterm.time.call_after(upload_prepare_poll_interval, function()
            poll_upload_preparation(state)
        end)
    end
    local metadata = ready:read("*l") or ""
    ready:close()
    local status, total_text = metadata:match("^(%a+)%s*(%d*)$")
    local closed, close_error = close_stream(state, "encoder")
    if status ~= "ok" then
        return fail_upload(state, upload_error(state, "Cannot create host archive"))
    end
    if not closed then
        return fail_upload(state, upload_error(state, "Cannot create host archive: " .. tostring(close_error)))
    end
    local total_bytes = tonumber(total_text)
    if not total_bytes or total_bytes <= 0 then
        return fail_upload(state, "Host archive reported an invalid size")
    end
    local archive, archive_error = io.open(state.archive_path, "rb")
    if not archive then
        return fail_upload(state, "Cannot open host archive: " .. tostring(archive_error))
    end
    local actual_size = archive:seek("end")
    archive:seek("set", 0)
    if actual_size ~= total_bytes then
        archive:close()
        return fail_upload(state, "Host archive size changed while preparing the upload")
    end
    state.archive = archive
    state.total_bytes = total_bytes
    state.started_at = os.time()
    state.last_report = 0
    state.phase = "streaming"
    report_upload_progress(state, false)
    wezterm.time.call_after(0.01, function() pump_upload(state) end)
end

pump_upload = function(state)
    if uploads[state.pane_id] ~= state or state.phase ~= "streaming" then return end
    local called, chunk = pcall(state.archive.read, state.archive, upload_read_size)
    if not called then return fail_upload(state, "Cannot read host archive: " .. tostring(chunk)) end
    if chunk and chunk ~= "" then
        local encoded_chunk = base64_encode(chunk)
        if #encoded_chunk > upload_batch_size or #encoded_chunk % 4 ~= 0 then
            return fail_upload(state, "Host encoder produced an invalid upload chunk")
        end
        state.sequence = state.sequence + 1
        local ok_ack = upload_ack_command(state.id, state.sequence, "ok", state.passthrough)
        local error_ack = upload_ack_command(state.id, state.sequence, "error", state.passthrough)
        local command = trim(([[
if printf '%%s' '%s' | base64 -d >> "$PWD"/%s; then %s; else %s; fi
]]):format(encoded_chunk, shell_quote(state.staging_name), ok_ack, error_ack))
        state.phase = "waiting_data"
        return send_upload_command(state, command, state.sequence, #chunk)
    end

    local closed, close_error = close_stream(state, "archive")
    if not closed then
        return fail_upload(state, "Cannot close host archive: " .. tostring(close_error))
    end
    if state.sequence == 0 then return fail_upload(state, "Host archive was empty") end
    if state.bytes ~= state.total_bytes then
        return fail_upload(state, "Host archive size changed during the upload")
    end
    local ok_ack = upload_ack_command(state.id, "E", "ok", state.passthrough)
    local error_ack = upload_ack_command(state.id, "E", "error", state.passthrough)
    local command = trim(([[
if tar -xzf "$PWD"/%s; then rm -f "$PWD"/%s; %s; else %s; fi
]]):format(
        shell_quote(state.staging_name),
        shell_quote(state.staging_name),
        ok_ack,
        error_ack
    ))
    state.phase = "waiting_finish"
    send_upload_command(state, command, "E", 0)
end

local function advance_upload(_, pane, value)
    local id, sequence, status = value:match("^([^|]+)|([^|]+)|([^|]+)$")
    if not id then return end
    local state = uploads[pane_id(pane)]
    if not state or state.id ~= id or state.waiting_for ~= sequence then return end
    state.waiting_for = nil
    if status ~= "ok" then
        return fail_upload(state, "Remote shell could not receive or extract the upload")
    end
    if sequence == "0" then
        state.remote_started = true
        state.phase = "preparing"
        return poll_upload_preparation(state)
    end
    if sequence == "E" then
        report_upload_progress(state, true)
        return clear_upload(state)
    end
    if tonumber(sequence) ~= state.sequence then
        return fail_upload(state, "Received an out-of-order upload acknowledgement")
    end
    state.bytes = state.bytes + state.pending_bytes
    state.pending_bytes = 0
    report_upload_progress(state, false)
    state.phase = "streaming"
    wezterm.time.call_after(0.01, function() pump_upload(state) end)
end

local function start_host_upload(window, pane, id, path, passthrough)
    local id_for_pane = pane_id(pane)
    if uploads[id_for_pane] then
        return window:toast_notification("WezTerm upload", "Another upload is active in this pane", nil, 4000)
    end
    path = expand_host_path(path)
    while #path > 1 and path:sub(-1) == "/" do path = path:sub(1, -2) end
    if path == "/" then
        return window:toast_notification("WezTerm upload", "Uploading the filesystem root is not supported", nil, 4000)
    end
    local exists, _, exists_error = wezterm.run_child_process({ "test", "-e", path })
    if not exists then
        return window:toast_notification("WezTerm upload", "Host path does not exist: " .. one_line(exists_error or path, 200), nil, 5000)
    end
    local parent, name = path:match("^(.*)/([^/]+)$")
    if not name then
        return window:toast_notification("WezTerm upload", "Cannot determine host path name", nil, 4000)
    end
    if parent == "" then parent = "/" end
    local error_path, pid_path = os.tmpname(), os.tmpname()
    local archive_path = pid_path .. ".archive"
    local ready_path = pid_path .. ".ready"
    local encoder, encoder_error = io.popen(
        "exec sh -c " .. shell_quote(host_encoder_script) ..
        " xfer-upload " .. shell_quote(parent) .. " " .. shell_quote(name) ..
        " " .. shell_quote(pid_path) .. " 2>" .. shell_quote(error_path),
        "r"
    )
    if not encoder then
        remove_upload_files(error_path, pid_path)
        return window:toast_notification("WezTerm upload", "Cannot start host encoder: " .. tostring(encoder_error), nil, 6000)
    end

    local staging_name = safe_name(name):sub(1, 170) .. ".tar.gz.part"
    local state = {
        id = id,
        pane_id = id_for_pane,
        pane = pane,
        window = window,
        encoder = encoder,
        error_path = error_path,
        pid_path = pid_path,
        archive_path = archive_path,
        ready_path = ready_path,
        staging_name = staging_name,
        passthrough = passthrough,
        sequence = 0,
        bytes = 0,
        wait_token = 0,
        phase = "waiting_start",
    }
    uploads[id_for_pane] = state
    monitor(uploads, state, cancel_upload)

    local ok_ack = upload_ack_command(id, 0, "ok", passthrough)
    local error_ack = upload_ack_command(id, 0, "error", passthrough)
    local command = trim(([[
if : > "$PWD"/%s; then %s; else %s; fi
]]):format(shell_quote(staging_name), ok_ack, error_ack))
    send_upload_command(state, command, 0, 0)
end

local function prompt_host_upload(window, pane, id, label, passthrough)
    if #id > 80 or not id:match("^[%w%._%-]+$") then return end
    window:perform_action(
        wezterm.action.PromptInputLine({
            description = ("Upload a host path into %s?\nEnter an absolute path, ~/path, or a path relative to home.")
                :format(one_line(label, 200)),
            action = wezterm.action_callback(function(prompt_window, _, line)
                if line == nil then return end
                if line == "" then
                    return prompt_window:toast_notification("WezTerm upload", "Host path cannot be empty", nil, 4000)
                end
                start_host_upload(prompt_window, pane, id, line, passthrough)
            end),
        }),
        pane
    )
end

local function handle_frame(window, pane, value)
    local kind, id, rest = value:match("^([BDEUX])|([^|]+)|(.*)$")
    if not kind then return end
    if kind == "U" then
        local passthrough, label = rest:match("^([01])|(.*)$")
        if passthrough then prompt_host_upload(window, pane, id, label, passthrough == "1") end
    elseif kind == "B" then
        local name, size, sha256, label = rest:match("^([^|]+)|(%d+)|(%x+)|(.*)$")
        if name then begin_transfer(window, pane, id, name, size, sha256, label) end
    elseif kind == "D" then
        local sequence, chunk = rest:match("^(%d+)|(.*)$")
        if sequence then receive_chunk(window, pane, id, sequence, chunk) end
    elseif kind == "E" then
        finish_transfer(window, pane, id, rest)
    elseif kind == "X" then
        local state = transfers[pane_id(pane)]
        if state and state.id == id then
            stop_transfer(state)
            local message = one_line(rest, 160)
            if state.temp_path and path_exists(state.temp_path) then
                message = message .. "; partial kept at " .. state.temp_path
            end
            window:toast_notification("WezTerm transfer cancelled", message, nil, 4000)
        end
    end
end

function xfer.setup()
    wezterm.on("user-var-changed", function(window, pane, name, value)
        if name == "wezterm_transfer" then
            handle_frame(window, pane, value)
        elseif name == "wezterm_upload_ack" then
            advance_upload(window, pane, value)
        end
    end)
end

function xfer.inject_sender_action()
    return wezterm.action_callback(function(window, pane)
        local id_for_pane = pane_id(pane)
        if bootstraps[id_for_pane] then
            return window:toast_notification("WezTerm transfer", "xfer installation is already running in this pane", nil, 4000)
        end
        bootstraps[id_for_pane] = true
        local ok, encoded_source, error_message = wezterm.run_child_process({
            "sh",
            "-c",
            [[base64 < "$1" | tr -d '\r\n']],
            "xfer-bootstrap",
            wezterm.home_dir .. "/.vim/bin/xfer",
        })
        if not ok or not encoded_source or encoded_source == "" or
            not encoded_source:match("^[A-Za-z0-9+/=]+$")
        then
            bootstraps[id_for_pane] = nil
            local detail = one_line(error_message or "", 160)
            if detail == "" then detail = "invalid base64 output" end
            return window:toast_notification("WezTerm transfer", "Cannot load xfer: " .. detail, nil, 6000)
        end
        local commands = {
            [[mkdir -p ~/.local/bin && __xfer_b64=~/.local/bin/.xfer.$$.b64 && : > "$__xfer_b64"]],
        }
        for offset = 1, #encoded_source, bootstrap_chunk_size do
            commands[#commands + 1] = ("printf '%%s' '%s' >> \"$__xfer_b64\"")
                :format(encoded_source:sub(offset, offset + bootstrap_chunk_size - 1))
        end
        commands[#commands + 1] = trim([[
__xfer_tmp=~/.local/bin/.xfer.$$.tmp; if base64 -d < "$__xfer_b64" > "$__xfer_tmp" && chmod 700 "$__xfer_tmp" && mv -f "$__xfer_tmp" ~/.local/bin/xfer; then :; else rm -f "$__xfer_tmp"; fi; rm -f "$__xfer_b64"; unset __xfer_b64 __xfer_tmp
]])
        send_commands(pane, commands, "~/.local/bin/xfer --tmux ", function(sent, send_error)
            bootstraps[id_for_pane] = nil
            if not sent then
                window:toast_notification("WezTerm transfer", "Cannot install xfer: " .. one_line(send_error or "", 160), nil, 6000)
            end
        end)
    end)
end

return xfer
