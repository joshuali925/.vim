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

local function parent(offset)
    local parent = cx.active.parent
    if not parent then return end

    local start = parent.cursor + 1 + offset
    local end_ = offset < 0 and 1 or #parent.files
    local step = offset < 0 and -1 or 1
    for i = start, end_, step do
        local target = parent.files[i]
        if target and target.cha.is_dir then
            return ya.manager_emit("cd", { target.url })
        end
    end
end

local function git_root()
    local output, err = Command("git"):args({ "rev-parse", "--show-toplevel" }):output()
    local stdout = read_stdout(output, err)
    if stdout ~= nil then ya.manager_emit("cd", { stdout }) end
end

local function follow()
    local output, err = Command("readlink"):args({ "-f", get_hovered_file() }):output()
    local stdout = read_stdout(output, err)
    if stdout ~= nil then ya.manager_emit("reveal", { stdout }) end
end

local function fzf(type, arg) -- https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/plugins/fzf.lua
    ya.hide()
    local output, err = Command("fzf")
        :env("FZF_DEFAULT_COMMAND", os.getenv(("FZF_%s_COMMAND"):format(type)) .. " " .. (arg or ""))
        :env("FZF_DEFAULT_OPTS", os.getenv("FZF_DEFAULT_OPTS") .. " " .. os.getenv(("FZF_%s_OPTS"):format(type)))
        :stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):output()

    local stdout = read_stdout(output, err)
    if stdout ~= nil then ya.manager_emit(stdout:match("[/\\]$") and "cd" or "reveal", { stdout }) end
end

local function z()
    ya.hide()
    local output, err = Command("fzf")
        :env("FZF_DEFAULT_COMMAND", "sort -nr -k 3 -t '|' ~/.z | awk -F '|' '{print $1}'")
        :env("FZF_DEFAULT_OPTS", os.getenv("FZF_DEFAULT_OPTS") .. [[ --scheme=history --bind='tab:down,btab:up' --bind="\`:unbind(\`)+reload(sort -nr -k 3 -t '|' ~/.z | awk -F '|' -v cwd=\"$PWD\" '\$0~cwd {print \$1}')"]])
        :stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):output()

    local stdout = read_stdout(output, err)
    if stdout ~= nil then ya.manager_emit("cd", { stdout }) end
end

return {
    entry = function(_, args)
        if args[1] == "parent" then return parent(tonumber(args[2])) end
        if args[1] == "git_root" then return git_root() end
        if args[1] == "follow" then return follow() end
        if args[1] == "fzf" then return fzf(args[2], args[3]) end
        if args[1] == "z" then return z() end
    end,
}
