local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local putils = require("telescope.previewers.utils")
local sorters = require("telescope.sorters")

local get_yanks = function()
    local items = vim.fn["miniyank#read"]()
    local yank_history = {}
    for i, item in pairs(items) do
        yank_history[i] = { text = table.concat(item[1], " "), item = item }
    end
    return yank_history
end

---@diagnostic disable-next-line: unused-local
local function make_entry(opts)
    local displayer = entry_display.create({ separator = " │ ", items = { { width = 120 }, { remaining = true } } })
    local make_display = function(entry)
        return displayer({ { entry.text } })
    end

    return function(entry)
        return {
            valid = true,
            ordinal = entry.text,
            display = make_display,
            item = entry.item,
            text = entry.text,
        }
    end
end

local search_yank = function(opts)
    pickers.new(opts, {
        prompt_title = "Search yank history",
        finder = finders.new_table({
            results = get_yanks(),
            entry_maker = make_entry(opts),
        }),
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr)
            action_set.select:enhance({
                post = function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    vim.call("miniyank#drop", selection.item, "p")
                end,
            })
            return true
        end,
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, status)
                putils.with_preview_window(status, nil, function()
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, entry.item[1])
                end)
            end,
        }),
    }):find()
end

return require("telescope").register_extension({ exports = { history = search_yank } })
