local M = {}

M.bookmarks = {}
local data_file = vim.fn.stdpath("data") .. "/.bookmarks"
local ns_id = vim.api.nvim_create_namespace("bookmarks")
local modified = false

local function min(a, b)
    return a < b and a or b
end

local function buf_set_extmark(opts)
    opts = opts or {}
    local extmark_opts = { sign_text = "", sign_hl_group = "DiagnosticOk" }
    if opts.annot ~= nil then
        extmark_opts.sign_text = ""
        extmark_opts.virt_text = { { " " .. opts.annot .. string.rep(" ", 3), "DiagnosticOk" } }
        extmark_opts.virt_text_pos = "right_align"
    end
    local buf = opts.buf or 0
    local row = min(opts.row, vim.api.nvim_buf_line_count(buf) - 1)
    local col = min(opts.col, #vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1])
    return vim.api.nvim_buf_set_extmark(buf, ns_id, row, col, extmark_opts)
end

-- limitation: bookmarks removed by deleting lines will be restored when reading from cache again
function M.dump_cache(buf, match)
    local file_name = match or vim.api.nvim_buf_get_name(buf)
    local bookmarks = M.bookmarks[file_name]
    if file_name == "" or bookmarks == nil then return end
    local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, {})
    local rows_index = {}
    for _, extmark in ipairs(extmarks) do
        local id, row, col = unpack(extmark)
        for i, bookmark in ipairs(bookmarks) do
            if bookmark.id == id then
                if rows_index[row] == nil then
                    rows_index[row] = i
                    if bookmark.row ~= row or bookmark.col ~= col then
                        bookmark.row = row
                        bookmark.col = col
                        modified = true
                    end
                elseif bookmark.annot ~= nil then -- there is already a bookmark in this row, only append to annotation
                    local bookmark_at_row = bookmarks[rows_index[row]]
                    bookmark_at_row.annot = bookmark_at_row.annot == nil and bookmark.annot or (bookmark_at_row.annot .. "  " .. bookmark.annot)
                    bookmark.row = row
                end
                break
            end
        end
    end
    for i = #bookmarks, 1, -1 do
        if rows_index[bookmarks[i].row] ~= i then -- remove duplicate bookmarks in the same row
            table.remove(bookmarks, i)
        end
    end
end

function M.load_cache(buf, match)
    local file_name = match or vim.api.nvim_buf_get_name(buf)
    local bookmarks = M.bookmarks[file_name]
    if not bookmarks then return end
    for _, bookmark in ipairs(bookmarks) do
        local extmarks = vim.api.nvim_buf_get_extmarks(0, ns_id, { bookmark.row, 0 }, { bookmark.row, -1 }, {})
        if #extmarks == 0 then
            bookmark.id = buf_set_extmark({ buf = buf, row = bookmark.row, col = bookmark.col, annot = bookmark.annot })
        end
    end
end

function M.create(annot)
    local file_name = vim.api.nvim_buf_get_name(0)
    if file_name == "" then return end
    if not M.bookmarks[file_name] then M.bookmarks[file_name] = {} end
    local row, col = vim.fn.line(".") - 1, vim.fn.col(".") - 1
    local id = buf_set_extmark({ annot = annot, row = row, col = col })
    table.insert(M.bookmarks[file_name], {
        id = id,
        row = row,
        col = col,
        annot = annot,
        text = vim.api.nvim_get_current_line():sub(0, 60):gsub("^%s*(.-)%s*$", "%1"),
        time = os.time(),
    })
    modified = true
end

function M.annote()
    local file_name = vim.api.nvim_buf_get_name(0)
    if file_name == "" then return end
    local prev_annot
    local row = vim.fn.line(".") - 1
    local extmarks = vim.api.nvim_buf_get_extmarks(0, ns_id, { row, 0 }, { row, -1 }, { details = true })
    for _, extmark in ipairs(extmarks) do
        local details = extmark[4]
        if details.virt_text ~= nil then
            prev_annot = details.virt_text[1][1]:sub(5, -4)
            break
        end
    end
    vim.ui.input({ prompt = "Comment", default = prev_annot }, function(annot)
        if annot == nil or #annot == 0 then return end
        M.delete()
        M.create(annot)
    end)
end

function M.delete_in_cache(file_name, id)
    for i, bookmark in ipairs(M.bookmarks[file_name]) do
        if bookmark.id == id then
            table.remove(M.bookmarks[file_name], i)
            modified = true
            break
        end
    end
end

function M.delete(opts)
    opts = opts or {}
    local buf = opts.buf or 0
    local row = opts.row or vim.fn.line(".") - 1
    local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, { row, 0 }, { row, -1 }, {})
    if #extmarks == 0 then
        return false
    end
    local file_name = vim.api.nvim_buf_get_name(buf)
    for _, extmark in ipairs(extmarks) do
        local id = extmark[1]
        local success = vim.api.nvim_buf_del_extmark(buf, ns_id, id)
        M.delete_in_cache(file_name, id)
        if not success then
            vim.notify("Failed to delete bookmark", vim.log.levels.ERROR, { annote = "Bookmarks" })
        end
    end
    return true
end

function M.toggle()
    if not M.delete() then M.create() end
end

function M.load_disk()
    local file = io.open(data_file, "r")
    if not file then return end

    local content = file:read("*a")
    file:close()
    if not content then return end
    M.bookmarks = vim.fn.json_decode(content)

    for _, buf in ipairs(vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf })
    end, vim.api.nvim_list_bufs())) do
        M.load_cache(buf)
    end
end

function M.dump_disk()
    if not modified then return end
    local filtered = {}
    for file, bookmarks in pairs(M.bookmarks) do
        if #bookmarks > 0 then
            for _, bookmark in ipairs(bookmarks) do
                bookmark.id = nil
            end
            filtered[file] = bookmarks
        end
    end
    vim.fn.writefile({ vim.fn.json_encode(filtered) }, data_file)
end

function M.setup()
    vim.keymap.set("n", "ma", M.annote)
    vim.keymap.set("n", "mm", M.toggle)
    vim.keymap.set("n", "ms", function()
        vim.notify(vim.inspect(M.bookmarks))
        vim.cmd.Notifications()
    end)
    vim.api.nvim_create_augroup("Bookmarks", {})
    vim.api.nvim_create_autocmd("VimLeavePre", { group = "Bookmarks", pattern = "*", callback = function() M.dump_disk() end })
    vim.api.nvim_create_autocmd("BufUnload", { group = "Bookmarks", pattern = "*", callback = function(e) M.dump_cache(e.buf, e.match) end })
    vim.api.nvim_create_autocmd("BufReadPost", { group = "Bookmarks", pattern = "*", callback = function(e) M.load_cache(e.buf, e.match) end })
    if vim.v.vim_did_enter == 1 then
        M.load_disk()
    else
        vim.api.nvim_create_autocmd("VimEnter", { group = "Bookmarks", pattern = "*", once = true, callback = function() M.load_disk() end })
    end
end

return M
