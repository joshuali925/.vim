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

local function shell(command, pause)
    -- NOTE keep commands POSIX compliant, on ubuntu the shell is 'sh'. need to use bash to support `read` flags
    return ya.emit("shell", { command .. (pause and "; echo Press any key to continue; bash -ic 'read -n 1 -s _'" or ""), confirm = true, block = true })
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

return {
    entry = function(_, job)
        local command
        if type(job.args[1]) == "string" then
            command = job.args[1]
        else
            local cmd, event = ya.input({ title = "Command:", pos = { "top-center", y = 3, w = 60 } })
            if event ~= 1 then return end
            command = cmd
        end

        if command:match("^open$") then return shell(command .. " %h") end
        if command:match("^file$") then return shell(command .. " %h", true) end
        if command:match("^chmod ") then return shell(command .. " %s") end
        if command:match("^chmod%?$") then return chmod_stat() end
        if command:match("^chown$") then return shell('sudo chown -R "$USER:$USER" %h') end
        if command:match("^chown%?$") then return chown_stat() end
        if command:match("^sudorm$") then return shell("sudo rm -r %s") end
        if command:match("^size$") then return calculate_sizes(job.args) end
        if command:match("^audio$") then return shell([[ffmpeg -i %h 2>&1 | rg -o 'Stream \S+ Audio: (\w+)' -r '$1' | xargs -I@ ffmpeg -i %h -codec copy "${0%%.*}.@"]]) end
        if command:match("^convert ") then
            local ext = command:match("^convert (%S+)")
            return shell('ffmpeg -i %h -codec copy "${0%%.*}.' .. ext .. '" || ffmpeg -y -i %h "${0%%.*}.' .. ext .. '"')
        end
        if command:match("^sftp$") then return shell([[printf " echo \"get %h\" | sftp -r " | y]]) end
        if command:match("^tarcopy$") then return shell([[for file in %s; do set -- "$@" "$(realpath --relative-to=. "$file")"; shift; done; printf " printf $(XZ_OPT=-9e tar cJf - "$@" | base64 | tr -d '\r\n') | base64 -d | tar xvJ" | y]]) end

        local function compress_cmd(cmd, ext)
            return ('for file in "$@"; do set -- "$@" "$(realpath --relative-to="." "$file")"; shift; done; %s "${1}.%s" "$@"'):format(cmd, ext)
        end
        if command:match("^zip$") then return shell(compress_cmd("zip -r", "zip")) end
        if command:match("^7z$") then return shell(compress_cmd("7z a", "7z")) end
        if command:match("^7zfast$") then return shell(compress_cmd("7z a -t7z -mx=1", "7z")) end
        if command:match("^7zultra$") then return shell(compress_cmd("7z a -t7z -mx=9 -m0=lzma -mfb=64 -md=32m -ms=on", "7z")) end
        if command:match("^7zmax$") then return shell(compress_cmd("7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 -m0=LZMA2:27", "7z")) end
        if command:match("^x$") then
            return shell([[
                set -x
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
        end
        if command:match("^X$") then
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
        end

        -- copy file reference (mac only)
        if command:match("^copy$") then return shell('osascript -e "on run args" -e "set the clipboard to POSIX file (first item of args)" -e end %h') end

        return shell(command, true)
    end,
}
