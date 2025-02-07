local M = {}

M.clips = {}
M.limit = 100
local data_file = vim.fn.stdpath("data") .. "/clips.msgpack"
local modified = false
local loaded = false

local function dump_disk()
    if not modified then return end
    local file = io.open(data_file, "w")
    if not file then return end
    file:write(vim.mpack.encode(M.clips))
    file:close()
end

local function load_disk()
    if loaded then return end
    loaded = true
    local fd = vim.uv.fs_open(data_file, "r", 438)
    if not fd then return end
    M.clips = vim.mpack.decode(assert(vim.uv.fs_read(fd, vim.uv.fs_fstat(fd).size)))
    vim.uv.fs_close(fd)
end

function M.setup()
    vim.api.nvim_create_augroup("Clips", {})
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = "Clips",
        callback = function()
            load_disk()
            local content = table.concat(vim.v.event.regcontents, "\n")
            if #content > 0 and #content < 100000 and (#M.clips == 0 or content ~= M.clips[1][1]) then
                table.insert(M.clips, 1, { content, vim.v.event.regtype, vim.o.filetype })
                while #M.clips > M.limit do table.remove(M.clips) end
                modified = true
            end
        end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", { group = "Clips", callback = dump_disk })
end

function M.pick(opts)
    opts = opts or {}
    load_disk()
    require("snacks.picker")(vim.tbl_extend("force", {
        title = "clips",
        layout = { preset = "dropdown", layout = { row = 2, width = 0.8, height = 0.9 } },
        format = "text",
        preview = "preview",
        finder = function()
            local items = {}
            for i, clip in ipairs(M.clips) do
                items[i] = { text = clip[1]:gsub("\n", "\\n"), regtype = clip[2], preview = { text = clip[1], ft = clip[3] } }
            end
            return items
        end,
        on_show = function() vim.cmd.stopinsert() end,
        confirm = function(picker, item)
            picker:close()
            if item then
                vim.fn.setreg('"', item.preview.text, item.regtype)
                vim.schedule(function() vim.api.nvim_put(vim.split(item.preview.text:gsub("\n$", ""), "\n"), item.regtype, true, false) end)
            end
        end,
    }, opts))
end

return M
