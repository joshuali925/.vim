local wezterm = require("wezterm")

local xfer = {}
local transfers = {}
local uploads = {}
local upload_prompts = {}
local bootstraps = {}
local bootstrap_serial = 0
local bootstrap_chunk_size, bootstrap_submit_delay, bootstrap_timeout = 1024, 0.1, 60
local upload_batch_size, upload_ack_timeout, upload_finalize_timeout = 1024, 30, 600
local upload_read_size = upload_batch_size // 4 * 3
local remote_upload_cleanup_timeout, remote_upload_watch_interval = 120, 5
local transfer_accept_timeout, transfer_idle_timeout = 120, 45
local upload_prepare_timeout, upload_prepare_poll_interval = 600, 0.2
local paste_submit_delay = 0.05
local download_directory = wezterm.home_dir .. "/Downloads"
local local_upload_directory = wezterm.home_dir .. "/.cache/wezterm/xfer"

local function pane_id(pane) return tostring(pane:pane_id()) end

local function one_line(text, limit)
    return (tostring(text):gsub("%c", " ")):sub(1, limit)
end

local function shell_quote(text)
    return "'" .. text:gsub("'", "'\\''") .. "'"
end

local function remote_assignment(variable, name) return variable .. "=" .. [["$PWD"/]] .. shell_quote(name) .. "\n" end
local function remote_home_bin_path(name) return [["$HOME"/.local/bin/]] .. shell_quote(name) end

local function trim(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function send_response(pane, kind, id, ...)
    local fields = { "#WTX1", kind, id }
    for index = 1, select("#", ...) do
        fields[#fields + 1] = tostring(select(index, ...))
    end
    fields[#fields + 1] = ""
    return pcall(pane.send_text, pane, "\x15 " .. table.concat(fields, "|") .. "\r")
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

local function send_commands(pane, commands, still_current, on_complete)
    local index = 1
    local finished = false
    local function finish(ok, error_message)
        if finished then return end
        finished = true
        on_complete(ok, error_message)
    end
    local function send_next()
        if not still_current() then return finish(false, "cancelled") end
        if index > #commands then return finish(true) end
        local ok, error_message = pcall(pane.send_paste, pane, " " .. commands[index])
        index = index + 1
        if not ok then return finish(false, error_message) end
        ok, error_message = pcall(wezterm.time.call_after, paste_submit_delay, function()
            if not still_current() then return finish(false, "cancelled") end
            local sent, send_error = pcall(pane.send_text, pane, "\r")
            if not sent then return finish(false, send_error) end
            local scheduled, schedule_error = pcall(wezterm.time.call_after, bootstrap_submit_delay, send_next)
            if not scheduled then finish(false, schedule_error) end
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

local function remove_files(...)
    for index = 1, select("#", ...) do
        local path = select(index, ...)
        if path then os.remove(path) end
    end
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

local function invalidate_timeout(state) state.timeout_token = (state.timeout_token or 0) + 1 end

local function arm_timeout(registry, state, seconds, callback)
    invalidate_timeout(state)
    local token = state.timeout_token
    wezterm.time.call_after(seconds, function()
        if registry[state.pane_id] == state and state.timeout_token == token then callback(state) end
    end)
end

local function dismiss_prompt(state)
    if not state.prompt_pending then return end
    state.prompt_pending = false
    pcall(state.window.perform_action, state.window, wezterm.action.SendKey({ key = "Escape" }), state.pane)
end

local function cleanup_transfer(state)
    transfers[state.pane_id] = nil
    invalidate_timeout(state)
    dismiss_prompt(state)
    local decoder, pid_path, commit_path, temp_path =
        state.decoder, state.decoder_pid_path, state.decoder_commit_path, state.temp_path
    state.decoder, state.decoder_pid_path, state.decoder_commit_path, state.temp_path = nil, nil, nil, nil
    remove_files(commit_path)
    terminate_stream(decoder, pid_path, function()
        remove_files(commit_path, temp_path)
    end)
end

local function cleanup_upload_prompt(state)
    if upload_prompts[state.pane_id] == state then upload_prompts[state.pane_id] = nil end
    invalidate_timeout(state)
    dismiss_prompt(state)
end

local function supersede_inbound(pane, id_for_pane)
    local prompt = upload_prompts[id_for_pane]
    if prompt then cleanup_upload_prompt(prompt) end
    local previous = transfers[id_for_pane]
    if not previous then return end
    send_response(pane, "C", previous.id, "superseded")
    cleanup_transfer(previous)
end

local function abort_transfer(state, reason, message)
    send_response(state.pane, "C", state.id, reason)
    cleanup_transfer(state)
    state.window:toast_notification("WezTerm transfer failed", message, nil, 6000)
end

local function arm_transfer_timeout(state)
    arm_timeout(transfers, state, transfer_idle_timeout, function(expired)
        abort_transfer(expired, "transfer_timeout", "Transfer stalled and was cleaned up")
    end)
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
    local commands = { { "shasum", "-a", "256", path }, { "sha256sum", path }, { "openssl", "dgst", "-sha256", path } }
    local last_error = "SHA-256 command failed"
    for _, command in ipairs(commands) do
        local ok, output, error_message = wezterm.run_child_process(command)
        if ok then
            for digest in (output or ""):gmatch("%x+") do
                if #digest == 64 then return digest:lower() end
            end
            last_error = "SHA-256 command returned an invalid digest"
        elseif error_message and error_message ~= "" then
            last_error = one_line(error_message, 160)
        end
    end
    return nil, last_error
end

local function begin_transfer(window, pane, id, name, size_text, expected_sha256, label)
    local id_for_pane = pane_id(pane)
    if #id > 80 or not id:match("^[%w%._%-]+$") then return send_response(pane, "C", id, "invalid_transfer_id") end
    local expected_size = tonumber(size_text)
    if not expected_size or expected_size < 0 or #expected_sha256 ~= 64 then return send_response(pane, "C", id, "invalid_metadata") end
    name = (name:match("([^/\\]+)$") or ""):gsub("[:%c]", "_"):gsub("[^%w%._%-]", "_")
    if name == "" or name == "." or name == ".." then name = "wezterm-transfer.tar.gz" end

    supersede_inbound(pane, id_for_pane)

    local state = {
        id = id,
        pane_id = id_for_pane,
        window = window,
        pane = pane,
        name = name:sub(1, 200),
        expected_size = expected_size,
        expected_sha256 = expected_sha256:lower(),
        sequence = 0,
        bytes = 0,
        prompt_pending = true,
    }
    transfers[id_for_pane] = state
    monitor(transfers, state, cleanup_transfer)
    arm_timeout(transfers, state, transfer_accept_timeout, function(expired)
        abort_transfer(expired, "accept_timeout", "Transfer request timed out")
    end)

    window:perform_action(
        wezterm.action.PromptInputLine({
            description = ("Receive %s (%d bytes) from %s?\nPress Enter to accept or Escape to reject.")
                :format(state.name, expected_size, one_line(label, 200)),
            action = wezterm.action_callback(function(_, _, line)
                state.prompt_pending = false
                if transfers[id_for_pane] ~= state then return end
                if line == nil then
                    send_response(pane, "C", id, "declined")
                    return cleanup_transfer(state)
                end

                local made_directory, _, directory_error =
                    wezterm.run_child_process({ "mkdir", "-p", download_directory })
                if not made_directory then
                    return abort_transfer(state, "download_directory_failed", "Cannot create download directory: " .. one_line(directory_error or "", 160))
                end
                state.temp_path = download_directory .. "/.wezterm-xfer-" .. id .. ".part"
                for _, active in pairs(transfers) do
                    if active ~= state and active.temp_path == state.temp_path then
                        return abort_transfer(state, "staging_file_busy", "Another transfer is using " .. state.temp_path)
                    end
                end
                if path_exists(state.temp_path) then
                    local removed, remove_error = os.remove(state.temp_path)
                    if not removed then
                        return abort_transfer(state, "staging_cleanup_failed", "Cannot remove stale staging file: " .. tostring(remove_error))
                    end
                end
                local decoder_pid_path = os.tmpname()
                local decoder_commit_path = decoder_pid_path .. ".commit"
                local decoder_script = [[
pid_path=$1 commit_path=$2 output_path=$3
printf '%s\n' "$$" > "$pid_path" || exit 1
decoder_pid=
cleanup() {
  rm -f "$pid_path"
  if [ ! -f "$commit_path" ]; then rm -f "$output_path"; fi
  rm -f "$commit_path"
}
interrupted() {
  trap - HUP INT TERM
  kill "$decoder_pid" 2>/dev/null
  wait "$decoder_pid" 2>/dev/null
  cleanup
  exit 143
}
trap interrupted HUP INT TERM
exec 4<&0 || { cleanup; exit 1; }
base64 -d <&4 > "$output_path" &
decoder_pid=$!
exec 4<&-
wait "$decoder_pid"
decoder_status=$?
trap - HUP INT TERM
cleanup
exit "$decoder_status"
]]
                local decoder, decoder_error = io.popen(
                    "exec sh -c " .. shell_quote(decoder_script) ..
                    " xfer-decoder " .. shell_quote(decoder_pid_path) ..
                    " " .. shell_quote(decoder_commit_path) ..
                    " " .. shell_quote(state.temp_path) .. " 2>/dev/null",
                    "w"
                )
                if not decoder then
                    remove_files(decoder_pid_path, decoder_commit_path)
                    return abort_transfer(state, "decoder_failed", "Cannot start base64 decoder: " .. tostring(decoder_error))
                end
                state.decoder, state.decoder_pid_path, state.decoder_commit_path =
                    decoder, decoder_pid_path, decoder_commit_path
                state.accepted = true
                local sent, send_error = send_response(pane, "A", id, 0, 0, "")
                if not sent then
                    return abort_transfer(state, "accept_response_failed", "Cannot acknowledge transfer: " .. tostring(send_error))
                end
                arm_transfer_timeout(state)
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

local function receive_chunk(pane, id, sequence_text, chunk)
    local state = active_transfer(pane, id)
    if not state then return end
    local sequence = tonumber(sequence_text)
    if sequence and sequence == state.sequence then
        arm_transfer_timeout(state)
        return send_response(pane, "A", id, sequence)
    end
    if not sequence or sequence ~= state.sequence + 1 then return abort_transfer(state, "invalid_sequence", "Received an out-of-order transfer chunk") end
    if chunk == "" or #chunk > 16384 or
        not chunk:match("^[A-Za-z0-9+/=]+$") then return abort_transfer(state, "invalid_chunk", "Received invalid transfer data") end
    local chunk_bytes = #chunk // 4 * 3 - (chunk:sub(-2) == "==" and 2 or chunk:sub(-1) == "=" and 1 or 0)
    if state.bytes + chunk_bytes > state.expected_size then return abort_transfer(state, "size_overflow", "Transfer exceeds the declared archive size") end
    for _, step in ipairs({ { state.decoder.write, "write", chunk }, { state.decoder.flush, "flush" } }) do
        local called, written, write_error = pcall(step[1], state.decoder, step[3])
        if not called or not written then
            return abort_transfer(state, "write_failed", "Cannot " .. step[2] .. " transfer data: " .. tostring(called and write_error or written))
        end
    end
    state.sequence = sequence
    state.bytes = state.bytes + chunk_bytes
    arm_transfer_timeout(state)
    send_response(pane, "A", id, sequence)
end

local function finish_transfer(pane, id, sequence_text)
    local state = active_transfer(pane, id)
    if not state then return end
    local sequence = tonumber(sequence_text)
    if not sequence or sequence ~= state.sequence then return abort_transfer(state, "invalid_sequence", "Transfer ended with an invalid chunk count") end
    local commit, commit_error = io.open(state.decoder_commit_path, "wb")
    if not commit then return abort_transfer(state, "commit_failed", "Cannot commit transfer staging: " .. tostring(commit_error)) end
    commit:close()
    local closed, close_error = close_stream(state, "decoder", "decoder_pid_path")
    if not closed then return abort_transfer(state, "decode_failed", "Cannot decode transfer: " .. tostring(close_error)) end

    local file, file_error = io.open(state.temp_path, "rb")
    if not file then return abort_transfer(state, "missing_file", "Cannot inspect transfer: " .. tostring(file_error)) end
    local size = file:seek("end")
    file:close()
    if size ~= state.expected_size then return abort_transfer(state, "size_mismatch",
        ("Downloaded %s bytes; expected %s"):format(tostring(size), tostring(state.expected_size))) end
    local digest, hash_error = sha256_file(state.temp_path)
    if not digest then return abort_transfer(state, "hash_failed", "Cannot verify transfer: " .. tostring(hash_error)) end
    if digest ~= state.expected_sha256 then return abort_transfer(state, "hash_mismatch", "Downloaded archive failed SHA-256 verification") end

    local final_path = available_final_path(state.name)
    if not final_path then return abort_transfer(state, "name_collision", "Cannot choose a final download path") end
    local moved, move_error = os.rename(state.temp_path, final_path)
    if not moved then return abort_transfer(state, "rename_failed", "Cannot finalize download: " .. tostring(move_error)) end
    state.temp_path = nil
    transfers[state.pane_id] = nil
    invalidate_timeout(state)
    send_response(pane, "A", id, "E")
    state.window:toast_notification("WezTerm transfer complete", ("Downloaded %s (%d bytes)"):format(final_path, size), "file://" .. final_path, 6000)
end

local host_encoder_script = [[
parent=$1 name=$2 pid_path=$3
status_base=$pid_path.status archive_path=$pid_path.archive
ready_path=$pid_path.ready ready_tmp=$pid_path.ready.tmp
printf '%s\n' "$$" > "$pid_path" || exit 1
cleanup_status() {
  rm -f "$status_base.1" "$status_base.2"
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
pipeline_status=$?
for status_path in "$status_base.1" "$status_base.2"; do
  status_value=
  IFS= read -r status_value < "$status_path" || status_value=
  [ "$status_value" = 0 ] || pipeline_status=1
done
cleanup_status
if [ "$pipeline_status" -eq 0 ]; then
  total_bytes=$(wc -c < "$archive_path") || total_bytes=
  total_bytes=$(printf '%s' "$total_bytes" | tr -d '[:space:]')
  case $total_bytes in
    ''|*[!0-9]*) pipeline_status=1 ;;
  esac
fi
if [ "$pipeline_status" -eq 0 ] && printf 'ok %s\n' "$total_bytes" > "$ready_tmp" &&
  mv -f "$ready_tmp" "$ready_path"; then
  exit 0
fi
rm -f "$archive_path"
printf '%s\n' error > "$ready_tmp" && mv -f "$ready_tmp" "$ready_path"
exit 1
]]

local function upload_ack_command(id, sequence, status, passthrough)
    local encoded = base64_encode(("%s|%s|%s"):format(id, sequence, status))
    local template = passthrough
        and [[printf '\033Ptmux;\033\033]1337;SetUserVar=wezterm_upload_ack=%s\007\033\134']]
        or [[printf '\033]1337;SetUserVar=wezterm_upload_ack=%s\007']]
    return template:format(encoded)
end

local function upload_acknowledgements(state, sequence)
    return upload_ack_command(state.id, sequence, "ok", state.passthrough),
        upload_ack_command(state.id, sequence, "error", state.passthrough)
end

local function upload_error(state, fallback)
    local file = state.error_path and io.open(state.error_path, "r")
    local message = file and file:read("*a") or ""
    if file then file:close() end
    message = one_line(message, 240)
    return message ~= "" and message or fallback
end

local function remove_upload_files(error_path, pid_path)
    remove_files(error_path)
    if not pid_path then return end
    remove_files(pid_path, pid_path .. ".status.1", pid_path .. ".status.2",
        pid_path .. ".archive", pid_path .. ".ready", pid_path .. ".ready.tmp")
end

local stale_local_cleanup_script = [[
upload_dir=$1
download_dir=$2
if [ -d "$upload_dir" ]; then
  for pid_path in "$upload_dir"/*.pid; do
    [ -f "$pid_path" ] || continue
    encoder_pid=
    IFS= read -r encoder_pid < "$pid_path" || encoder_pid=
    case $encoder_pid in
      ''|*[!0-9]*) continue ;;
    esac
    encoder_command=$(ps -p "$encoder_pid" -o command= 2>/dev/null) || encoder_command=
    case $encoder_command in
      *xfer-upload*"$pid_path"*) kill -TERM "$encoder_pid" 2>/dev/null ;;
    esac
  done
  rm -f "$upload_dir"/*
fi
if [ -d "$download_dir" ]; then
  rm -f "$download_dir"/.wezterm-xfer-*.part
fi
]]

local function deactivate_upload(state)
    if uploads[state.pane_id] == state then uploads[state.pane_id] = nil end
    state.waiting_for = nil
    invalidate_timeout(state)
    state.phase = "cleaned"
end

local function cancel_upload(state)
    deactivate_upload(state)
    close_stream(state, "archive")
    local encoder, error_path, pid_path = state.encoder, state.error_path, state.pid_path
    state.encoder, state.error_path, state.pid_path = nil, nil, nil
    terminate_stream(encoder, pid_path, function()
        remove_upload_files(error_path, pid_path)
    end)
end

local function remote_upload_assignments(state, destination)
    return remote_assignment("__xfer_stage", state.staging_name) ..
        remote_assignment("__xfer_extract", state.extract_name) ..
        (destination and remote_assignment("__xfer_destination", destination) or "") ..
        remote_assignment("__xfer_lease", state.lease_name) ..
        remote_assignment("__xfer_lease_tmp", state.lease_tmp_name)
end

local remote_upload_cleanup = [[rm -f "$__xfer_stage" "$__xfer_lease" "$__xfer_lease_tmp"
rm -rf "$__xfer_extract"
]]
local remote_upload_unset = [[unset __xfer_stage __xfer_extract __xfer_destination __xfer_lease __xfer_lease_tmp
]]
local remote_upload_reset = remote_upload_cleanup .. remote_upload_unset
local remote_upload_refresh_lease = [[__xfer_now=$(date +%s) &&
  __xfer_deadline=$((__xfer_now + ]] .. remote_upload_cleanup_timeout .. [[)) &&
  printf '%s\n' "$__xfer_deadline" > "$__xfer_lease_tmp" &&
  mv -f "$__xfer_lease_tmp" "$__xfer_lease"]]

local function remote_upload_response(ok_ack, error_ack)
    return remote_upload_unset .. "  unset __xfer_now __xfer_deadline\n  " .. ok_ack .. "\nelse\n" ..
        remote_upload_reset .. "  unset __xfer_now __xfer_deadline\n  " .. error_ack .. "\nfi\n"
end

local function remote_upload_final_response(ok_ack, error_ack)
    local cleanup = remote_upload_reset .. "  unset __xfer_now __xfer_deadline\n  unset __xfer_hash_output __xfer_digest\n  "
    return cleanup .. ok_ack .. "\nelse\n" .. cleanup .. error_ack .. "\nfi\n"
end

local function interrupt_and_send(pane, command)
    pcall(pane.send_text, pane, "\x03")
    wezterm.time.call_after(0.15, function()
        pcall(pane.send_text, pane, "\x15")
        if pcall(pane.send_paste, pane, " " .. command) then
            wezterm.time.call_after(paste_submit_delay, function() pcall(pane.send_text, pane, "\r") end)
        end
    end)
end

local function request_remote_upload_cleanup(state)
    if not state.remote_maybe_started or state.cleanup_requested then return end
    state.cleanup_requested = true
    interrupt_and_send(state.pane, trim(remote_upload_assignments(state) .. remote_upload_reset))
end

local function abandon_upload(state)
    request_remote_upload_cleanup(state)
    cancel_upload(state)
end

local fail_upload
local pump_upload
local poll_upload_preparation
local begin_remote_upload

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
        :format(format_bytes(state.bytes), format_bytes(total), percent // 10, percent % 10,
            format_bytes(speed), format_duration(elapsed), eta)
    state.window:toast_notification(complete and "WezTerm upload complete" or "WezTerm upload", complete and (message .. " | extracted into remote cwd") or message, nil, complete and 5000 or 1100)
end

local function send_upload_command(state, command, expected_ack, pending_bytes, timeout)
    state.waiting_for = tostring(expected_ack)
    state.pending_bytes = pending_bytes or 0
    invalidate_timeout(state)
    local token = state.timeout_token
    timeout = timeout or upload_ack_timeout
    local cleared, clear_error = pcall(state.pane.send_text, state.pane, "\x15")
    if not cleared then return fail_upload(state, "Cannot clear the remote command line: " .. tostring(clear_error)) end
    local pasted, paste_error = pcall(state.pane.send_paste, state.pane, " " .. command)
    if not pasted then return fail_upload(state, "Cannot paste upload command: " .. tostring(paste_error)) end
    local scheduled, schedule_error = pcall(wezterm.time.call_after, paste_submit_delay, function()
        if uploads[state.pane_id] ~= state or state.timeout_token ~= token or not state.waiting_for then return end
        local sent, send_error = pcall(state.pane.send_text, state.pane, "\r")
        if not sent then return fail_upload(state, "Cannot submit upload command: " .. tostring(send_error)) end
        wezterm.time.call_after(timeout, function()
            if uploads[state.pane_id] == state and state.timeout_token == token and state.waiting_for then
                fail_upload(state, "Remote upload acknowledgement timed out") end
        end)
    end)
    if not scheduled then return fail_upload(state, "Cannot schedule upload command: " .. tostring(schedule_error)) end
end

fail_upload = function(state, message)
    if uploads[state.pane_id] ~= state then return end
    request_remote_upload_cleanup(state)
    cancel_upload(state)
    state.window:toast_notification("WezTerm upload failed",
        message .. (state.remote_maybe_started and "\nRemote staging cleanup requested." or ""), nil, 6000)
end

begin_remote_upload = function(state)
    if uploads[state.pane_id] ~= state then return end
    state.phase = "waiting_start"
    state.remote_maybe_started = true
    local ok_ack, error_ack = upload_acknowledgements(state, 0)
    local command = trim(
        remote_upload_assignments(state) ..
        remote_upload_cleanup ..
        [[if : > "$__xfer_stage" &&
  ]] .. remote_upload_refresh_lease .. [[; then
  (
    (
      trap '' HUP
      __xfer_watch_cleanup() {
]] .. remote_upload_cleanup .. [[        exit 143
      }
      trap __xfer_watch_cleanup INT TERM
      while [ -r "$__xfer_lease" ]; do
        IFS= read -r __xfer_deadline < "$__xfer_lease" || break
        case $__xfer_deadline in ''|*[!0-9]*) break ;; esac
        __xfer_now=$(date +%s) || break
        [ "$__xfer_now" -lt "$__xfer_deadline" ] || break
        sleep ]] .. remote_upload_watch_interval .. [[ || break
      done
      trap - INT TERM
]] .. remote_upload_cleanup .. [[    ) </dev/null >/dev/null 2>&1 &
  )
]] .. remote_upload_response(ok_ack, error_ack)
    )
    send_upload_command(state, command, 0, 0)
end

poll_upload_preparation = function(state)
    if uploads[state.pane_id] ~= state or state.phase ~= "preparing" then return end
    local ready = io.open(state.ready_path, "r")
    if not ready then
        if os.time() >= state.prepare_deadline then return fail_upload(state, "Timed out while creating the host archive") end
        return wezterm.time.call_after(upload_prepare_poll_interval, function() poll_upload_preparation(state) end)
    end
    local metadata = ready:read("*l") or ""
    ready:close()
    local status, total_text = metadata:match("^(%a+)%s*(%d*)$")
    local closed, close_error = close_stream(state, "encoder")
    if status ~= "ok" then return fail_upload(state, upload_error(state, "Cannot create host archive")) end
    if not closed then return fail_upload(state, upload_error(state, "Cannot create host archive: " .. tostring(close_error))) end
    local total_bytes = tonumber(total_text)
    if not total_bytes or total_bytes <= 0 then return fail_upload(state, "Host archive reported an invalid size") end
    local archive, archive_error = io.open(state.archive_path, "rb")
    if not archive then return fail_upload(state, "Cannot open host archive: " .. tostring(archive_error)) end
    local actual_size = archive:seek("end")
    archive:seek("set", 0)
    if actual_size ~= total_bytes then
        archive:close()
        return fail_upload(state, "Host archive size changed while preparing the upload")
    end
    local expected_sha256, hash_error = sha256_file(state.archive_path)
    if not expected_sha256 then
        archive:close()
        return fail_upload(state, "Cannot verify host archive: " .. tostring(hash_error))
    end
    state.archive, state.total_bytes, state.expected_sha256 = archive, total_bytes, expected_sha256
    state.started_at, state.last_report = os.time(), 0
    begin_remote_upload(state)
end

pump_upload = function(state)
    if uploads[state.pane_id] ~= state or state.phase ~= "streaming" then return end
    local called, chunk = pcall(state.archive.read, state.archive, upload_read_size)
    if not called then return fail_upload(state, "Cannot read host archive: " .. tostring(chunk)) end
    if chunk and chunk ~= "" then
        local encoded_chunk = base64_encode(chunk)
        if #encoded_chunk > upload_batch_size or #encoded_chunk % 4 ~= 0 then return fail_upload(state, "Host encoder produced an invalid upload chunk") end
        state.sequence = state.sequence + 1
        local ok_ack, error_ack = upload_acknowledgements(state, state.sequence)
        local command = trim(
            remote_upload_assignments(state) ..
            [[if [ -f "$__xfer_stage" ] &&
  ]] .. remote_upload_refresh_lease .. [[ &&
  printf '%s' ']] .. encoded_chunk .. [[' | base64 -d >> "$__xfer_stage"; then
]] .. remote_upload_response(ok_ack, error_ack)
        )
        state.phase = "waiting_data"
        return send_upload_command(state, command, state.sequence, #chunk)
    end

    local closed, close_error = close_stream(state, "archive")
    if not closed then return fail_upload(state, "Cannot close host archive: " .. tostring(close_error)) end
    if state.sequence == 0 then return fail_upload(state, "Host archive was empty") end
    if state.bytes ~= state.total_bytes then return fail_upload(state, "Host archive size changed during the upload") end
    local ok_ack, error_ack = upload_acknowledgements(state, "E")
    local command = trim(
        remote_upload_assignments(state, state.remote_name) ..
        [=[if (
  trap 'rm -f "$__xfer_stage" "$__xfer_lease" "$__xfer_lease_tmp"; rm -rf "$__xfer_extract"; exit 130' HUP INT TERM
  __xfer_now=$(date +%s) || exit 1
  __xfer_deadline=$((__xfer_now + ]=] .. (upload_finalize_timeout + remote_upload_cleanup_timeout) .. [=[))
  printf '%s\n' "$__xfer_deadline" > "$__xfer_lease_tmp" || exit 1
  mv -f "$__xfer_lease_tmp" "$__xfer_lease" || exit 1
  if command -v sha256sum >/dev/null 2>&1; then
    __xfer_hash_output=$(sha256sum "$__xfer_stage") || exit 1
    __xfer_digest=${__xfer_hash_output%%[[:space:]]*}
  elif command -v shasum >/dev/null 2>&1; then
    __xfer_hash_output=$(shasum -a 256 "$__xfer_stage") || exit 1
    __xfer_digest=${__xfer_hash_output%%[[:space:]]*}
  elif command -v openssl >/dev/null 2>&1; then
    __xfer_hash_output=$(openssl dgst -sha256 "$__xfer_stage") || exit 1
    __xfer_digest=${__xfer_hash_output##*= }
    __xfer_digest=${__xfer_digest%%[[:space:]]*}
  else
    exit 127
  fi
  __xfer_digest=$(printf '%s' "$__xfer_digest" | tr 'A-F' 'a-f') || exit 1
  [ "$__xfer_digest" = ]=] .. shell_quote(state.expected_sha256) .. [=[ ] || exit 65
  [ ! -e "$__xfer_destination" ] && [ ! -L "$__xfer_destination" ] || exit 73
  rm -rf "$__xfer_extract" || exit 1
  mkdir "$__xfer_extract" || exit 1
  tar -xzf "$__xfer_stage" -C "$__xfer_extract" || exit 1
  [ -e "$__xfer_extract"/]=] .. shell_quote(state.remote_name) .. [=[ ] ||
    [ -L "$__xfer_extract"/]=] .. shell_quote(state.remote_name) .. [=[ ] ||
    exit 74
  mv "$__xfer_extract"/]=] .. shell_quote(state.remote_name) .. [=[ "$__xfer_destination" || exit 1
); then
]=] .. remote_upload_final_response(ok_ack, error_ack)
    )
    state.phase = "waiting_finish"
    send_upload_command(state, command, "E", 0, upload_finalize_timeout)
end

local function advance_upload(_, pane, value)
    local id, sequence, status = value:match("^([^|]+)|([^|]+)|([^|]+)$")
    if not id then return end
    local state = uploads[pane_id(pane)]
    if not state or state.id ~= id or state.waiting_for ~= sequence then return end
    state.waiting_for = nil
    if status ~= "ok" then return fail_upload(state, "Remote shell could not receive, verify, or extract the upload") end
    if sequence == "E" then
        report_upload_progress(state, true)
        deactivate_upload(state)
        close_stream(state, "archive")
        close_stream(state, "encoder")
        remove_upload_files(state.error_path, state.pid_path)
        return
    end
    if sequence ~= "0" then
        if tonumber(sequence) ~= state.sequence then return fail_upload(state, "Received an out-of-order upload acknowledgement") end
        state.bytes = state.bytes + state.pending_bytes
        state.pending_bytes = 0
    end
    report_upload_progress(state, false)
    state.phase = "streaming"
    wezterm.time.call_after(0.01, function() pump_upload(state) end)
end

local function start_host_upload(window, pane, id, path, passthrough)
    local id_for_pane = pane_id(pane)
    local previous = uploads[id_for_pane]
    if previous then abandon_upload(previous) end
    if path == "~" then path = wezterm.home_dir
    elseif path:sub(1, 2) == "~/" then path = wezterm.home_dir .. path:sub(2)
    elseif path:sub(1, 1) ~= "/" then path = wezterm.home_dir .. "/" .. path end
    while #path > 1 and path:sub(-1) == "/" do path = path:sub(1, -2) end
    if path == "/" then return window:toast_notification("WezTerm upload", "Uploading the filesystem root is not supported", nil, 4000) end
    local exists, _, exists_error = wezterm.run_child_process({ "test", "-e", path })
    if not exists then exists = select(1, wezterm.run_child_process({ "test", "-L", path })) end
    if not exists then return window:toast_notification("WezTerm upload", "Host path does not exist: " .. one_line(exists_error or path, 200), nil, 5000) end
    local parent, name = path:match("^(.*)/([^/]+)$")
    if not name then return window:toast_notification("WezTerm upload", "Cannot determine host path name", nil, 4000) end
    if name == "." or name == ".." or name:find("%c") then return window:toast_notification(
        "WezTerm upload", "The host path name is not safe to transfer", nil, 4000) end
    if parent == "" then parent = "/" end
    local made_directory, _, directory_error = wezterm.run_child_process({ "mkdir", "-p", local_upload_directory })
    if not made_directory then
        return window:toast_notification("WezTerm upload",
            "Cannot create local transfer cache: " .. one_line(directory_error or "", 160), nil, 5000)
    end
    local nonce_path = os.tmpname()
    local nonce = nonce_path and nonce_path:match("([^/]+)$")
    remove_files(nonce_path)
    if not nonce then return window:toast_notification("WezTerm upload", "Cannot create a local transfer identifier", nil, 5000) end
    local local_key = (id .. "-" .. id_for_pane .. "-" .. nonce):gsub("[^%w%._%-]", "_"):sub(1, 240)
    local pid_path = local_upload_directory .. "/" .. local_key .. ".pid"
    local error_path = local_upload_directory .. "/" .. local_key .. ".error"
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

    local remote_prefix = ".wezterm-xfer-" .. id
    local state = {
        id = id,
        pane_id = id_for_pane,
        pane = pane,
        window = window,
        encoder = encoder,
        error_path = error_path,
        pid_path = pid_path,
        archive_path = pid_path .. ".archive",
        ready_path = pid_path .. ".ready",
        staging_name = remote_prefix .. ".tar.gz.part",
        extract_name = remote_prefix .. ".extract.part",
        lease_name = remote_prefix .. ".lease",
        lease_tmp_name = remote_prefix .. ".lease.tmp",
        remote_name = name,
        passthrough = passthrough,
        sequence = 0,
        bytes = 0,
        prepare_deadline = os.time() + upload_prepare_timeout,
        phase = "preparing",
    }
    uploads[id_for_pane] = state
    monitor(uploads, state, abandon_upload)
    wezterm.time.call_after(previous and 0.3 or 0.01, function() poll_upload_preparation(state) end)
end

local function prompt_host_upload(window, pane, id, label, passthrough)
    if #id > 80 or not id:match("^[%w%._%-]+$") then return end
    local id_for_pane = pane_id(pane)
    supersede_inbound(pane, id_for_pane)
    local state = {
        id = id,
        pane_id = id_for_pane,
        pane = pane,
        window = window,
        prompt_pending = true,
    }
    upload_prompts[id_for_pane] = state
    arm_timeout(upload_prompts, state, transfer_accept_timeout, function(expired)
        cleanup_upload_prompt(expired)
        expired.window:toast_notification("WezTerm upload", "Upload path prompt timed out", nil, 4000)
    end)
    window:perform_action(
        wezterm.action.PromptInputLine({
            description = ("Upload a host path into %s?\nEnter an absolute path, ~/path, or a path relative to home.")
                :format(one_line(label, 200)),
            action = wezterm.action_callback(function(prompt_window, _, line)
                state.prompt_pending = false
                if upload_prompts[id_for_pane] ~= state then return end
                upload_prompts[id_for_pane] = nil
                invalidate_timeout(state)
                if line == nil then return end
                if line == "" then return prompt_window:toast_notification("WezTerm upload", "Host path cannot be empty", nil, 4000) end
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
        if sequence then receive_chunk(pane, id, sequence, chunk) end
    elseif kind == "E" then
        finish_transfer(pane, id, rest)
    elseif kind == "X" then
        local state = transfers[pane_id(pane)]
        if state and state.id == id then
            cleanup_transfer(state)
            window:toast_notification("WezTerm transfer cancelled",
                one_line(rest, 160) .. "; local staging cleaned", nil, 4000)
        end
    end
end

local function request_bootstrap_cleanup(state)
    if state.cleanup_requested then return end
    state.cleanup_requested = true
    interrupt_and_send(state.pane,
        "rm -f " .. remote_home_bin_path(state.b64_name) .. " " .. remote_home_bin_path(state.tmp_name))
end

local function fail_bootstrap(state, message, clean_remote)
    if bootstraps[state.pane_id] ~= state then return end
    if clean_remote then request_bootstrap_cleanup(state) end
    bootstraps[state.pane_id] = nil
    invalidate_timeout(state)
    state.window:toast_notification("WezTerm transfer", message, nil, 6000)
end

local function finish_bootstrap(_, pane, value)
    local id, status, detail = value:match("^([^|]+)|([^|]+)|(.*)$")
    if not id then return end
    local state = bootstraps[pane_id(pane)]
    if not state or state.id ~= id then return end
    if status ~= "ok" then
        detail = one_line(detail, 160)
        return fail_bootstrap(state, "xfer installation failed" .. (detail ~= "" and ": " .. detail or ""))
    end
    bootstraps[state.pane_id] = nil
    invalidate_timeout(state)
    local sent, send_error = pcall(pane.send_paste, pane,
        detail == "tmux" and "~/.local/bin/xfer --tmux " or "~/.local/bin/xfer ")
    if not sent then
        state.window:toast_notification("WezTerm transfer",
            "xfer installed, but its command could not be pasted: " .. one_line(send_error or "", 160), nil, 6000)
    end
end

function xfer.setup()
    pcall(wezterm.run_child_process, {
        "sh",
        "-c",
        stale_local_cleanup_script,
        "xfer-cleanup",
        local_upload_directory,
        download_directory,
    })
    wezterm.on("user-var-changed", function(window, pane, name, value)
        if name == "wezterm_transfer" then
            handle_frame(window, pane, value)
        elseif name == "wezterm_upload_ack" then
            advance_upload(window, pane, value)
        elseif name == "wezterm_xfer_bootstrap" then
            finish_bootstrap(window, pane, value)
        end
    end)
end

function xfer.inject_sender_action()
    return wezterm.action_callback(function(window, pane)
        local id_for_pane = pane_id(pane)
        if bootstraps[id_for_pane] then
            invalidate_timeout(bootstraps[id_for_pane])
            bootstraps[id_for_pane] = nil
            pcall(pane.send_text, pane, "\x03\x15")
        end

        local source_path = wezterm.home_dir .. "/.vim/bin/xfer"
        local checksum_ok, checksum_output, checksum_error =
            wezterm.run_child_process({ "cksum", source_path })
        local expected_crc, expected_size = (checksum_output or ""):match("^%s*(%d+)%s+(%d+)")
        if not checksum_ok or not expected_crc or expected_size == "0" then
            return window:toast_notification("WezTerm transfer",
                "Cannot checksum xfer: " .. one_line(checksum_error or checksum_output or "", 160), nil, 6000)
        end
        local packed, encoded_source, pack_error = wezterm.run_child_process({
            "sh",
            "-c",
            [[gzip -n -c < "$1" | base64 | tr -d '\r\n']],
            "xfer-bootstrap",
            source_path,
        })
        if not packed or not encoded_source or encoded_source == "" or
            not encoded_source:match("^[A-Za-z0-9+/=]+$")
        then
            return window:toast_notification("WezTerm transfer",
                "Cannot compress xfer: " .. one_line(pack_error or "", 160), nil, 6000)
        end

        bootstrap_serial = bootstrap_serial + 1
        local bootstrap_id = ("%s-%d-%d-%s"):format(id_for_pane, os.time(), bootstrap_serial, expected_crc)
            :gsub("[^%w%._%-]", "_")
        local bootstrap_file_key = id_for_pane:gsub("[^%w%._%-]", "_"):sub(1, 80)
        local state = {
            id = bootstrap_id,
            pane_id = id_for_pane,
            pane = pane,
            window = window,
            b64_name = ".xfer-bootstrap-" .. bootstrap_file_key .. ".b64",
            tmp_name = ".xfer-bootstrap-" .. bootstrap_file_key .. ".tmp",
        }
        bootstraps[id_for_pane] = state
        arm_timeout(bootstraps, state, bootstrap_timeout, function(expired)
            fail_bootstrap(expired, "xfer installation response timed out; retry the action", true)
        end)

        local cleared, clear_error = pcall(pane.send_text, pane, "\x15")
        if not cleared then
            return fail_bootstrap(state, "Cannot clear the remote command line: " .. one_line(clear_error or "", 160))
        end

        local ok_ack = base64_encode(bootstrap_id .. "|ok|")
        local ok_tmux_ack = base64_encode(bootstrap_id .. "|ok|tmux")
        local error_ack = base64_encode(bootstrap_id .. "|error|integrity_check_failed")
        local commands = {
            "__xfer_b64=" .. remote_home_bin_path(state.b64_name) ..
                "; __xfer_tmp=" .. remote_home_bin_path(state.tmp_name) ..
                "; __xfer_ack='" .. error_ack ..
                "'; __xfer_tmux_ack='" .. error_ack ..
                "'; __xfer_cksum=; command rm -f \"$__xfer_tmp\"; " ..
                "command mkdir -p \"$HOME/.local/bin\" && : > \"$__xfer_b64\" || __xfer_b64=",
        }
        for offset = 1, #encoded_source, bootstrap_chunk_size do
            commands[#commands + 1] =
                ("[ -z \"$__xfer_b64\" ] || command printf '%%s' '%s' >> \"$__xfer_b64\"")
                    :format(encoded_source:sub(offset, offset + bootstrap_chunk_size - 1))
        end
        commands[#commands + 1] = table.concat({
            [[command rm -f "$__xfer_tmp"; if [ -n "$__xfer_b64" ] && command base64 -d < "$__xfer_b64" | command gzip -d > "$__xfer_tmp"; then __xfer_cksum=$(command cksum "$__xfer_tmp" | command awk '{print $1 ":" $2}'); fi]],
            "if [ \"$__xfer_cksum\" = " .. shell_quote(expected_crc .. ":" .. expected_size) ..
                " ] && command chmod 700 \"$__xfer_tmp\" && command mv -f \"$__xfer_tmp\" " ..
                "\"$HOME\"/.local/bin/xfer; then __xfer_ack='" .. ok_ack ..
                "'; __xfer_tmux_ack='" .. ok_tmux_ack ..
                "'; else command rm -f \"$__xfer_tmp\"; command printf '%s\\n' " ..
                "'xfer install failed checksum verification; previous executable left unchanged' >&2; fi",
            [[command rm -f "$__xfer_b64" "$__xfer_tmp"; if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then command tmux set-option -g allow-passthrough all >/dev/null 2>&1 || :; fi]],
            [[[ -n "${TMUX:-}" ] || command printf '\033Ptmux;\033\033]1337;SetUserVar=wezterm_xfer_bootstrap=%s\007\033\134' "$__xfer_tmux_ack"; if [ -n "${TMUX:-}" ]; then command printf '\033Ptmux;\033\033]1337;SetUserVar=wezterm_xfer_bootstrap=%s\007\033\134' "$__xfer_tmux_ack"; else command printf '\033]1337;SetUserVar=wezterm_xfer_bootstrap=%s\007' "$__xfer_ack"; fi; unset __xfer_b64 __xfer_tmp __xfer_cksum __xfer_ack __xfer_tmux_ack]],
        }, "; ")
        send_commands(pane, commands, function()
            return bootstraps[id_for_pane] == state
        end, function(sent, send_error)
            if not sent then fail_bootstrap(state, "Cannot install xfer: " .. one_line(send_error or "", 160), true) end
        end)
    end)
end

return xfer
