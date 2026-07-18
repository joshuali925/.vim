local function read_stdout(output, err)
    if not output then
        return ya.notify({ title = "Command failed", content = ("Cannot read output, error code %s"):format(err), timeout = 5, level = "error" })
    end
    if not output.status.success then
        if output.status.code ~= 130 then
            local content = ""
            if output.stdout ~= "" then content = "stdout:\n" .. output.stdout end
            if output.stderr ~= "" then content = content .. (content ~= "" and "\n" or "") .. "stderr:\n" .. output.stderr end
            ya.notify({ title = "Command failed", content = content, timeout = 5, level = "error" })
        end
        return
    end
    local stdout = output.stdout:gsub("\n$", "")
    if stdout ~= "" then return stdout end
end

local get_hovered_file = ya.sync(function() return tostring(cx.active.current.hovered.url) end)

local get_yanked = ya.sync(function()
    local urls = {}
    for _, u in pairs(cx.yanked) do urls[#urls + 1] = ya.quote(tostring(u)) end
    return urls, cx.yanked.is_cut, ya.quote(tostring(cx.active.current.cwd))
end)

local function shell(command, pause)
    -- NOTE keep commands POSIX compliant, on ubuntu the shell is 'sh'. need to use bash to support `read` flags
    return ya.emit("shell", { command .. (pause and "; echo Press any key to continue; bash -ic 'read -n 1 -s _'" or ""), confirm = true, block = true })
end

local function cow_paste()
    local urls, is_cut, cwd = get_yanked()
    if is_cut or #urls == 0 then return end
    shell("cp -dRiv --reflink=auto --sparse=always " .. table.concat(urls, " ") .. " " .. cwd)
end

local function chmod_stat()
    local output, err = Command("stat"):arg({ "--printf", "%a %n\n", get_hovered_file() }):output()
    local stdout = read_stdout(output, err)
    if stdout ~= nil then ya.notify({ title = "File permission", content = stdout, timeout = 5 }) end
end

local function chown_stat()
    local output, err = Command("stat"):arg(get_hovered_file()):stdout(Command.PIPED):output()
    local stdout = read_stdout(output, err)
    if stdout ~= nil then
        local access = stdout:match("Access: [^\n]*")
        ya.notify({ title = "File owner", content = access, timeout = 5 })
    end
end

local function format_size(size)
    local units = { "B", "KiB", "MiB", "GiB", "TiB" }
    local unit_index = 1
    while size >= 1024 and unit_index < #units do
        size = size / 1024
        unit_index = unit_index + 1
    end
    return string.format(unit_index == 1 and "%d %s" or "%.6f %s", size, units[unit_index])
end

local get_items = ya.sync(function(_, hovered)
    local items = {}
    if #cx.active.selected > 0 then
        for _, url in pairs(cx.active.selected) do
            local path = tostring(url)
            table.insert(items, { url = path, name = path:match("([^/\\]+)[/\\]?$") or path })
        end
    elseif hovered then
        local file = cx.active.current.hovered
        if file then table.insert(items, { url = tostring(file.url), name = tostring(file.name) }) end
    else
        for i = 1, #cx.active.current.files do
            local file = cx.active.current.files[i]
            table.insert(items, { url = tostring(file.url), name = tostring(file.name) })
        end
    end
    return items
end)

local function get_dir_size(url)
    local files = fs.read_dir(url, { resolve = true })
    if not files then return 0 end
    local total = 0
    for _, file in ipairs(files) do
        total = total + (file.cha.is_dir and get_dir_size(file.url) or file.cha.len or 0)
    end
    return total
end

local function get_item_size(url_str)
    local url = Url(url_str)
    local cha = fs.cha(url, true)
    if not cha then return 0 end
    return cha.is_dir and get_dir_size(url) or cha.len or 0
end

local function calculate_sizes(args)
    local items = get_items(args and args.hovered)
    local sizes, total = {}, 0
    for _, item in ipairs(items) do
        local size = get_item_size(item.url)
        table.insert(sizes, { name = item.name, size = size })
        total = total + size
    end
    table.sort(sizes, function(a, b) return a.size > b.size end)
    local formatted_total = format_size(total)
    local max_width = #formatted_total
    for i = 1, math.min(20, #sizes) do
        sizes[i].formatted = format_size(sizes[i].size)
        if #sizes[i].formatted > max_width then max_width = #sizes[i].formatted end
    end
    local lines = {}
    for i = 1, math.min(20, #sizes) do
        table.insert(lines, string.format("%" .. max_width .. "s  %s", sizes[i].formatted, sizes[i].name))
    end
    if #sizes > 1 then table.insert(lines, string.format("%" .. max_width .. "s  total (%d items)", formatted_total, #sizes)) end
    ya.notify({ title = "Sizes", content = table.concat(lines, "\n"), timeout = 3 })
end

local function compress_cmd(cmd, ext)
    return ('for file in "$@"; do set -- "$@" "$(realpath --relative-to="." "$file")"; shift; done; %s "${1}.%s" "$@"'):format(cmd, ext)
end

local SEVEN_ZIP_MAX_OPTIONS = "-t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 -m0=LZMA2:27"

local function seven_zip_max(extra)
    local options = extra and extra .. " " .. SEVEN_ZIP_MAX_OPTIONS or SEVEN_ZIP_MAX_OPTIONS
    return shell(compress_cmd("7z a " .. options, "7z"))
end

local COMMANDS = {
    open = { run = function() return shell("open %h") end },
    file = { run = function() return shell("file %h", true) end },
    chmod = { exact = false, accepts_args = true, run = function(args) return shell("chmod " .. args .. " %s") end },
    ["chmod?"] = { run = chmod_stat },
    chown = { run = function() return shell('sudo chown -R "$USER:$USER" %h') end },
    ["chown?"] = { run = chown_stat },
    ["cow-paste"] = { run = cow_paste },
    sudorm = { run = function() return shell("sudo rm -r %s") end },
    size = { run = function(_, job) return calculate_sizes(job.args) end },
    audio = {
        run = function()
            local file = get_hovered_file()
            local output = Command("ffmpeg"):arg({ "-i", file }):stdout(Command.PIPED):stderr(Command.PIPED):output()
            local codec = output and output.stderr:match("Audio: (%w+)")
            if not codec then return ya.notify({ title = "Command failed", content = "No audio stream found", timeout = 5, level = "error" }) end
            return shell(('ffmpeg -i %%h -codec copy "%s.%s"'):format(file:match("(.+)%.[^/\\]+$") or file, codec))
        end,
    },
    convert = {
        exact = false,
        accepts_args = true,
        run = function(args)
            local ext = args:match("^(%S+)")
            return shell('ffmpeg -i %h -codec copy "${0%%.*}.' .. ext .. '" || ffmpeg -y -i %h "${0%%.*}.' .. ext .. '"')
        end,
    },
    sftp = {
        accepts_args = true,
        run = function(args)
            if args == "" then return shell([[printf " echo \"get %h\" | sftp -r " | y]]) end
            return shell(('echo "put %%h" | sftp -r %s'):format(args), true)
        end,
    },
    tarcopy = { run = function() return shell([[for file in %s; do set -- "$@" "$(realpath --relative-to=. "$file")"; shift; done; printf " printf $(XZ_OPT=-9e tar cJf - "$@" | base64 | tr -d '\r\n') | base64 -d | tar xvJ" | y]]) end },
    zip = { run = function() return shell(compress_cmd("zip -r", "zip")) end },
    ["7z"] = { run = function() return shell(compress_cmd("7z a", "7z")) end },
    ["7zfast"] = { run = function() return shell(compress_cmd("7z a -t7z -mx=1", "7z")) end },
    ["7zultra"] = { run = function() return shell(compress_cmd("7z a -t7z -mx=9 -m0=lzma -mfb=64 -md=32m -ms=on", "7z")) end },
    ["7zmax"] = { run = function() return seven_zip_max("-mtm=-") end },
    ["7zmaxts"] = { run = function() return seven_zip_max() end },
    ["7zmax4g"] = { run = function() return seven_zip_max("-v4g -mtm=-") end },
    x = {
        run = function()
            return shell([[
                set -f
                if [ "$#" -gt 1 ]; then
                    ]] .. compress_cmd("tar cvzf", "tar.gz") .. [[;
                else
                    selected="$(basename %h)"
                    if [ -d %h ]; then
                        tar czvf "$selected.tar.gz" "$selected"
                    elif file -Lb --mime-type -- "$selected" | grep -q "^video/"; then
                        ffmpeg -i "$selected" -vcodec libx264 -crf 28 "${selected%%.*}.small.mp4"
                    elif file -Lb --mime-type -- "$selected" | grep -q "^image/"; then
                        ffmpeg -i "$selected" -q:v 10 "${selected%%.*}.small.${selected##*.}"
                    else
                        xtract "$selected"
                    fi
                fi
            ]])
        end,
    },
    X = {
        run = function()
            return shell([[
                set -f
                selected="$(basename %h)"
                if [ -f "$selected" ]; then
                    dir="${selected%%.*}"
                    filename="$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)_$selected"
                    command mkdir -pv "$dir"
                    command mv -i "$selected" "$dir/$filename"
                    cd "$dir" > /dev/null
                    xtract "$filename"
                    cd .. > /dev/null
                    command mv -n "$dir/$filename" "$selected"
                else
                    tar czvf "$selected.tar.gz" -C "$selected" .
                fi
            ]])
        end,
    },
    copy = { run = function() return shell('osascript -e "on run args" -e "set the clipboard to POSIX file (first item of args)" -e end %h') end },
}

local COMMAND_COMPLETIONS = {}
for name in pairs(COMMANDS) do COMMAND_COMPLETIONS[#COMMAND_COMPLETIONS + 1] = name end
table.sort(COMMAND_COMPLETIONS)

local HISTORY_DIR = os.getenv("HOME") .. "/.local/state/yazi"
local HISTORY_FILE = HISTORY_DIR .. "/command-history"
local HISTORY_LIMIT = 100
local SUBMIT, CANCEL = 1, 2

local start_command_prompt = ya.sync(function(st, history) st.command_prompt = { history = history } end)

local request_prompt_action = ya.sync(function(st, field, direction)
    if not st.command_prompt then return false end
    st.command_prompt[field] = direction
    return true
end)

local function prefix_matches(items, prefix, exclude_exact)
    local matches = {}
    for _, item in ipairs(items) do
        if (not exclude_exact or item ~= prefix) and item:sub(1, #prefix) == prefix then
            matches[#matches + 1] = item
        end
    end
    return matches
end

local consume_prompt_request = ya.sync(function(st, value)
    local prompt = st.command_prompt
    if not prompt then return end

    if prompt.completion_direction then
        local direction = prompt.completion_direction
        prompt.completion_direction = nil

        if value ~= prompt.completion_value then
            prompt.completion_matches = prefix_matches(COMMAND_COMPLETIONS, value, true)
            prompt.completion_value = value
            prompt.completion_index = direction > 0 and 0 or #prompt.completion_matches + 1
        end

        if #prompt.completion_matches == 0 then return value end
        prompt.completion_index = (prompt.completion_index - 1 + direction) % #prompt.completion_matches + 1
        prompt.completion_value = prompt.completion_matches[prompt.completion_index]
        return prompt.completion_value
    end

    if not prompt.history_direction then return end
    local direction = prompt.history_direction
    prompt.history_direction = nil

    if value ~= prompt.value then
        prompt.prefix = value
        prompt.matches = prefix_matches(prompt.history, value)
        prompt.index = #prompt.matches + 1
    end

    prompt.index = math.max(1, math.min(#prompt.matches + 1, prompt.index + direction))
    prompt.value = prompt.matches[prompt.index] or prompt.prefix
    return prompt.value
end)

local finish_command_prompt = ya.sync(function(st, command)
    local prompt = st.command_prompt
    st.command_prompt = nil
    if not prompt or command == nil or command == "" then return end

    local history = prompt.history
    if history[#history] == command then return end
    history[#history + 1] = command
    if #history > HISTORY_LIMIT then table.remove(history, 1) end
    return history
end)

local function load_history()
    local fh = io.open(HISTORY_FILE, "r")
    if not fh then return {} end
    local data = fh:read("a")
    fh:close()

    local history = {}
    for command in data:gmatch("[^\r\n]+") do history[#history + 1] = command end
    if #history > HISTORY_LIMIT then
        history = table.move(history, #history - HISTORY_LIMIT + 1, #history, 1, {})
    end
    return history
end

local function save_history(history)
    local ok, err = fs.create("dir_all", Url(HISTORY_DIR))
    if ok then ok, err = fs.write(Url(HISTORY_FILE), table.concat(history, "\n") .. "\n") end
    if not ok then ya.notify({ title = "Command history", content = tostring(err), timeout = 5, level = "error" }) end
end

local function input_command()
    start_command_prompt(load_history())
    local value = ""

    while true do
        local command, event = ya.input({ title = "Command:", value = value, pos = { "top-center", y = 3, w = 60 } })
        if event == SUBMIT then
            local history = finish_command_prompt(command)
            if history then save_history(history) end
            return command
        end

        local match = event == CANCEL and consume_prompt_request(command) or nil
        if match == nil then
            finish_command_prompt()
            return
        end
        value = match
    end
end

return {
    entry = function(_, job)
        local action, direction = job.args[1], tonumber(job.args[2])
        if (action == "history" or action == "completion") and direction then
            if request_prompt_action(action .. "_direction", direction) then
                ya.emit("input:close", {})
            else
                ya.emit("input:insert", {})
            end
            return
        end

        local command
        if type(job.args[1]) == "string" then
            command = job.args[1]
        else
            command = input_command()
            if command == nil then return end
        end

        local name, args = command:match("^(%S+)%s*(.*)$")
        local available = name and COMMANDS[name]
        if available then
            local matches = args == "" and available.exact ~= false or args ~= "" and available.accepts_args
            if matches then return available.run(args, job) end
        end

        return shell(command, true)
    end,
}
