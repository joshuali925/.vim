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

local function fzf(type, args) -- https://raw.githubusercontent.com/sxyazi/yazi/HEAD/yazi-plugin/preset/plugins/fzf.lua
    ui.hide()
    local cmd = os.getenv(("FZF_%s_COMMAND"):format(type))
    local child, err = Command("fzf")
        :env("FZF_DEFAULT_COMMAND", cmd and (cmd .. " " .. flags_from_args(args)) or "")
        :env("FZF_DEFAULT_OPTS", (os.getenv("FZF_DEFAULT_OPTS") or "") .. " " .. (os.getenv(("FZF_%s_OPTS"):format(type)) or "") .. " --height=100%")
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

local navigate = ya.sync(function(st, direction)
    if not st.history or st.history_idx + direction < 1 or st.history_idx + direction > #st.history then return end
    st.history_idx = st.history_idx + direction
    ya.emit("cd", { st.history[st.history_idx] })
end)

return {
    setup = function()
        ps.sub("cd", ya.sync(function(st)
            local cwd = tostring(cx.active.current.cwd)
            if not st.history then
                st.history = { cwd }
                st.history_idx = 1
            elseif st.history[st.history_idx] ~= cwd then
                for i = #st.history, st.history_idx + 1, -1 do st.history[i] = nil end
                st.history[#st.history + 1] = cwd
                st.history_idx = #st.history
            end
        end))
    end,
    entry = function(_, job)
        if job.args[1] == "git_root" then return git_root() end
        if job.args[1] == "fzf" then return fzf(job.args[2], job.args) end
        if job.args[1] == "z" then return z() end
        if job.args[1] == "initial_cwd" then return ya.sync(function(st) if st.history then ya.emit("cd", { st.history[1] }) end end) end
        if job.args[1] == "navigate" then return navigate(job.args[2]) end
    end,
}
