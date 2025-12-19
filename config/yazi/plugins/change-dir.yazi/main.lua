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

local function read_child_output(child, child_err)
    if not child then
        return ya.notify({ title = "Command failed", content = ("Cannot read output, error code %s"):format(child_err), timeout = 5, level = "error" })
    end
    local output, err = child:wait_with_output()
    return read_stdout(output, err)
end

local function flags_from_args(args)
    local flags = {}
    for k, v in pairs(args) do
        if type(k) == "string" then
            k = k:gsub("_", "-")
            if v == true then
                flags[#flags + 1] = "--" .. k
            else
                flags[#flags + 1] = "--" .. k .. "=" .. tostring(v)
            end
        end
    end
    return table.concat(flags, " ")
end

local function git_root()
    local output, err = Command("git"):arg({ "rev-parse", "--show-toplevel" }):output()
    local stdout = read_stdout(output, err)
    if stdout ~= nil then ya.emit("cd", { stdout }) end
end

local function fzf(type, args) -- https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/plugins/fzf.lua
    ui.hide()
    local child, err = Command("fzf")
        :env("FZF_DEFAULT_COMMAND", os.getenv(("FZF_%s_COMMAND"):format(type)) .. " " .. (flags_from_args(args) or ""))
        :env("FZF_DEFAULT_OPTS", os.getenv("FZF_DEFAULT_OPTS") .. " " .. os.getenv(("FZF_%s_OPTS"):format(type)) .. " --height=100%")
        :stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

    local stdout = read_child_output(child, err)
    if stdout ~= nil then ya.emit(stdout:match("[/\\]$") and "cd" or "reveal", { stdout }) end
end

local function z()
    ui.hide()
    local child, err = Command("fzf")
        :env("FZF_DEFAULT_COMMAND", "sort -nrk 3 -t '|' ~/.z | awk -F '|' '{print $1}'")
        :env("FZF_DEFAULT_OPTS", os.getenv("FZF_DEFAULT_OPTS") .. [[ --scheme=history --bind='tab:down,btab:up' --bind="\`:unbind(\`)+reload(sort -nrk 3 -t '|' ~/.z | awk -F '|' -v cwd=\"^$PWD\" '\$0~cwd {print \$1}')" --height=100%]])
        :stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

    local stdout = read_child_output(child, err)
    if stdout ~= nil then ya.emit("cd", { stdout }) end
end

local initial_cwd = ya.sync(function(st) if st.initial_cwd then ya.emit("cd", { st.initial_cwd }) end end)

return {
    setup = function()
        ps.sub("cd", ya.sync(function(st)
            if not st.initial_cwd then
                st.initial_cwd = tostring(cx.active.current.cwd)
                ps.unsub("cd")
            end
        end))
    end,
    entry = function(_, job)
        if job.args[1] == "git_root" then return git_root() end
        if job.args[1] == "fzf" then return fzf(job.args[2], job.args) end
        if job.args[1] == "z" then return z() end
        if job.args[1] == "initial_cwd" then return initial_cwd() end
    end,
}
