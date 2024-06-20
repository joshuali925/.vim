local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local utils = require("telescope.utils")

local get_results = function(opts)
    local items = {}
    for file, bookmarks in pairs(require("bookmarks").bookmarks) do
        local relative_path = vim.fn.fnamemodify(file, ":~:.")
        if opts.global or relative_path:match("^[/~]") == nil then
            for i = #bookmarks, 1, -1 do
                table.insert(items, { full_path = file, relative_path = relative_path, bookmark = bookmarks[i] })
            end
        end
    end
    return items
end

local entry_maker = function(item)
    local displayer = entry_display.create({ separator = " │ ", items = { { width = 10 }, { width = 50 }, { remaining = true } } })
    local display = function(entry)
        return displayer({
            { os.date("%m/%d/%Y", entry.time), "Comment" },
            entry.annot and { " " .. entry.annot, "DiagnosticOk" } or entry.text,
            utils.path_smart(entry.filename) .. ":" .. entry.lnum,
        })
    end
    return {
        valid = true,
        ordinal = (item.bookmark.annot or "") .. item.relative_path .. item.bookmark.text,
        display = display,
        filename = item.relative_path,
        item = item,
        lnum = item.bookmark.row + 1,
        col = item.bookmark.col + 1,
        annot = item.bookmark.annot,
        text = item.bookmark.text,
        time = item.bookmark.time,
    }
end

local bookmarks = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Bookmarks",
        finder = finders.new_table({ results = get_results(opts), entry_maker = entry_maker }),
        sorter = conf.generic_sorter(opts),
        previewer = conf.qflist_previewer(opts),
        attach_mappings = function(prompt_bufnr, map)
            local function delete()
                local entry = action_state.get_selected_entry()
                local buf = vim.fn.bufnr(entry.filename)
                if buf == -1 then
                    require("bookmarks").delete_in_cache(entry.item.full_path, entry.item.bookmark.id)
                else
                    require("bookmarks").delete({ buf = buf, row = entry.item.bookmark.row })
                end
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                current_picker:delete_selection(function() end)
            end
            map("n", "dd", delete)
            map("i", "<C-d>", delete)
            return true
        end,
    }):find()
end

return require("telescope").register_extension({ exports = { bookmarks = bookmarks } })
