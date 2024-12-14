local get_entries = function()
    local items = require("clips").clips
    local entries = {}
    for i, item in ipairs(items) do
        entries[i] = { index = i, text = item[1], item = item }
    end
    return entries
end

local function regtype_to_text(regtype)
    if "v" == regtype then return "charwise" end
    if "V" == regtype then return "linewise" end
    return "blockwise"
end

local function make_entry(opts)
    local displayer = require("telescope.pickers.entry_display").create({ separator = " │ ", items = { { width = #tostring(require("clips").limit) }, { remaining = true } } })
    local make_display = function(entry) return displayer({ { entry.index, "TelescopeResultsNumber" }, entry.text:gsub("\n", "\\n") }) end

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

local search = function(opts)
    require("telescope.pickers").new(opts, {
        prompt_title = "Search Clipboards",
        finder = require("telescope.finders").new_table({ results = get_entries(), entry_maker = make_entry(opts) }),
        sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr)
            require("telescope.actions.set").select:enhance({
                post = function()
                    local entry = require("telescope.actions.state").get_selected_entry()
                    require("telescope.actions").close(prompt_bufnr)
                    vim.api.nvim_put(vim.split(entry.item[1]:gsub("\n$", ""), "\n"), entry.item[2], true, false)
                end,
            })
            return true
        end,
        previewer = require("telescope.previewers").new_buffer_previewer({
            dyn_title = function(_, entry) return regtype_to_text(entry.item[2]) end,
            define_preview = function(self, entry)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.item[1], "\n"))
                if entry.item[3] ~= nil then vim.bo[self.state.bufnr].filetype = entry.item[3] end
            end,
        }),
    }):find()
end

return require("telescope").register_extension({ exports = { clips = search } })
