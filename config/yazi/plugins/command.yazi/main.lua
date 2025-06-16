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

return {
    entry = function(_, job)
        local command
        if type(job.args[1]) == "string" then
            command = job.args[1]
        else
            local cmd, event = ya.input({ title = "Command:", position = { "top-center", y = 3, w = 60 } })
            if event ~= 1 then return end
            command = cmd
        end

        if command:match("^open$") then return shell(command .. ' "$0"') end
        if command:match("^file$") then return shell(command .. ' "$0"', true) end
        if command:match("^chmod ") then return shell(command .. ' "$@"') end
        if command:match("^chmod%?$") then return chmod_stat() end
        if command:match("^chown$") then return shell('sudo chown -R "$USER:$USER" "$0"') end
        if command:match("^chown%?$") then return chown_stat() end
        if command:match("^sudorm$") then return shell('sudo rm -r "$@"') end
        if command:match("^size$") then return shell([[du -b --max-depth=1 | sort -nr | head -n 20 | awk 'function hr(bytes) { hum[1099511627776]="TiB"; hum[1073741824]="GiB"; hum[1048576]="MiB"; hum[1024]="kiB"; for (x = 1099511627776; x >= 1024; x /= 1024) { if (bytes >= x) { return sprintf("%8.3f %s", bytes/x, hum[x]); } } return sprintf("%4d     B", bytes); } { printf hr($1) "\t"; $1=""; print $0; }']], true) end
        if command:match("^audio$") then return shell([[ffmpeg -i "$0" 2>&1 | rg -o 'Stream \S+ Audio: (\w+)' -r '$1' | xargs -I@ ffmpeg -i "$0" -codec copy "${0%.*}.@"]]) end
        if command:match("^sftp$") then return shell([[printf " echo \"get '$0'\" | sftp -r " | y]]) end
        if command:match("^tarcopy$") then return shell([[printf " printf $(XZ_OPT=-9e tar cJf - "${@##*/}" | base64 | tr -d '\r\n') | base64 -d | tar xvJ" | y]]) end -- only works if the selected files are in the same directory

        local function compress_cmd(cmd, ext)
            return ('for file in "$@"; do set -- "$@" "$(realpath --relative-to="." "$file")"; shift; done; %s "${1}.%s" "$@"'):format(cmd, ext)
        end
        if command:match("^zip$") then return shell(compress_cmd("zip -r", "zip")) end
        if command:match("^7z$") then return shell(compress_cmd("7z a", "7z")) end
        if command:match("^7zfast$") then return shell(compress_cmd("7z -mx=1 a", "7z")) end
        if command:match("^7zultra$") then return shell(compress_cmd("7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on", "7z")) end
        if command:match("^7zmax$") then return shell(compress_cmd("7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 -m0=LZMA2:27", "7z")) end
        if command:match("^x$") then
            return shell(([[
                set -f
                if [ "$#" -gt 1 ]; then
                    %s
                else
                    selected="$(basename "$0")"
                    if [ -f "$0" ]; then
                        xtract "$selected"
                    else
                        tar czvf "$selected.tar.gz" "$selected"
                    fi
                fi
            ]]):format(compress_cmd("tar czvf", "tar.gz")))
        end
        if command:match("^X$") then
            return shell([[
                set -f
                selected="$(basename "$0")"
                if [ -f "$selected" ]; then
                    dir="${selected%.*}"
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
        if command:match("^copy$") then return shell('osascript -e "on run args" -e "set the clipboard to POSIX file (first item of args)" -e end "$0"') end

        return shell(command, true)
    end,
}
