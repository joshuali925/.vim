local M = {}

do
    local util = require("snacks.picker.util")
    local orig = util.globber
    util.globber = function(globs)
        local set, patterns, has_pattern = {}, {}, false
        for _, g in ipairs(globs) do
            if g:find("[%*%?%[%]]") then patterns[#patterns + 1], has_pattern = g, true else set[g] = true end
        end
        if not has_pattern then return function(file) return set[file] == true end end
        if not next(set) then return orig(globs) end
        local match = orig(patterns)
        return function(file) return set[file] == true or match(file) end
    end
end

local modes = {
    { mode = "default", title = "Explore" },
    { mode = "buffers", title = "Buffers" },
    { mode = "git", title = "Git" },
}

local function make_include(cwd)
    local parents = require("snacks.picker.util").parents
    local include, seen = {}, {}
    local function push(p)
        if not seen[p] then
            seen[p] = true
            include[#include + 1] = p
        end
    end
    return include, function(abs)
        push(abs)
        for parent in parents(abs, cwd) do push(parent) end
    end
end

local function refresh(picker, opts)
    picker.opts.include, picker.opts.exclude = opts.include, opts.exclude
    picker.list:set_target()
    picker:find()
    picker:update_titles()
end

local function set_include(picker, cwd, include, status)
    local Tree = require("snacks.explorer.tree")
    Tree:refresh(cwd)
    for _, p in ipairs(include) do Tree:open(p) end
    if status then require("snacks.explorer.git")._update(cwd, status) end
    refresh(picker, { include = include, exclude = { "**" } })
end

local function apply_mode(picker)
    local cwd = picker:cwd()
    local idx = picker.opts.explorer_mode_idx or 1
    local entry = modes[idx]
    picker.title = entry.title
    picker.opts.git_status = true

    if entry.mode == "default" then
        return refresh(picker, {})
    end
    if entry.mode == "buffers" then
        local Tree = require("snacks.explorer.tree")
        local include, add = make_include(cwd)
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
                local name = vim.api.nvim_buf_get_name(buf)
                local abs = name ~= "" and vim.fs.normalize(name)
                if abs and Tree:in_cwd(cwd, abs) then add(abs) end
            end
        end
        return set_include(picker, cwd, include)
    end
    local ok, gsconfig = pcall(require, "gitsigns.config")
    local base = (ok and gsconfig.config.base) or "HEAD"
    picker.opts.git_status = base == "HEAD"
    local include, add = make_include(cwd)
    local status = {}
    local sources = {
        { { "git", "-C", cwd, "diff", "--name-status", "--no-renames", base }, function(line)
            local xy, rel = line:match("^(%a)%s+(.+)$")
            if rel and xy ~= "D" then return rel, " " .. xy end
        end },
        { { "git", "-C", cwd, "ls-files", "--others", "--exclude-standard" }, function(line) return line, "??" end },
    }
    local remaining = #sources
    for _, src in ipairs(sources) do
        vim.system(src[1], { text = true }, vim.schedule_wrap(function(out)
            if picker.closed or picker.opts.explorer_mode_idx ~= idx then return end
            for line in (out.stdout or ""):gmatch("[^\r\n]+") do
                local rel, xy = src[2](line)
                if rel then
                    local abs = cwd .. "/" .. rel
                    add(abs)
                    status[#status + 1] = { status = xy, file = abs }
                end
            end
            remaining = remaining - 1
            if remaining == 0 then set_include(picker, cwd, include, base ~= "HEAD" and status or nil) end
        end))
    end
end

local function watch_buffers(picker)
    if picker.opts.explorer_watching then return end
    picker.opts.explorer_watching = true
    local on_change = require("snacks.util").debounce(function()
        if not picker.closed and modes[picker.opts.explorer_mode_idx or 1].mode == "buffers" then
            apply_mode(picker)
        end
    end, { ms = 250 })
    picker.list.win:on({ "BufAdd", "BufDelete", "BufFilePost" }, on_change)
end

function M.cycle_mode(picker, step)
    picker.opts.explorer_mode_idx = ((picker.opts.explorer_mode_idx or 1) - 1 + step) % #modes + 1
    watch_buffers(picker)
    apply_mode(picker)
end

return M
