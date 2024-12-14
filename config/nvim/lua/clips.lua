local M = {}

M.clips = {}
M.limit = 100
local data_file = vim.fn.stdpath("data") .. "/clips.msgpack"
local modified = false

local function dump_disk()
    if not modified then return end
    local file = io.open(data_file, "w")
    if not file then return end
    file:write(vim.mpack.encode(M.clips))
    file:close()
end

local function load_disk()
    local fd = vim.uv.fs_open(data_file, "r", 438)
    if not fd then return end
    M.clips = vim.mpack.decode(assert(vim.uv.fs_read(fd, vim.uv.fs_fstat(fd).size)))
end

function M.setup()
    vim.api.nvim_create_augroup("Clips", {})
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = "Clips",
        callback = function()
            local reg_content = vim.fn.getreg(vim.v.event.regname)
            if type(reg_content) == "string" and #reg_content > 0 and #reg_content < 100000 and (#M.clips == 0 or reg_content ~= M.clips[1][1]) then
                table.insert(M.clips, 1, { reg_content, vim.fn.getregtype(vim.v.event.regname), vim.o.filetype })
                if #M.clips > M.limit then table.remove(M.clips) end
                modified = true
            end
        end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", { group = "Clips", callback = dump_disk })
    if vim.v.vim_did_enter == 1 then
        load_disk()
    else
        vim.api.nvim_create_autocmd("VimEnter", { group = "Clips", pattern = "*", once = true, callback = load_disk })
    end
end

return M
