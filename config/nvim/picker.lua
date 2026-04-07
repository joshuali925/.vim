vim.loader.enable()
vim.g.loaded_remote_plugins = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.o.cmdheight = 0
vim.o.laststatus = 0
vim.o.shortmess = vim.o.shortmess .. "I"
vim.o.loadplugins = false
vim.o.shadafile = "NONE"
vim.o.swapfile = false

local data = vim.fn.stdpath("data") .. "/site/pack/core/opt"
vim.opt.rtp:prepend(data .. "/snacks.nvim")
vim.opt.rtp:prepend(data .. "/mini.nvim")
vim.opt.rtp:prepend(data .. "/tokyonight.nvim")

require("tokyonight").setup({ style = vim.env.LIGHT_THEME == "1" and "day" or "storm", styles = { comments = { italic = false }, keywords = { italic = false } } })
vim.cmd.colorscheme("tokyonight")
require("mini.icons").setup()

require("snacks").setup({
    picker = {
        formatters = { file = { filename_first = true, truncate = 80 } },
        sources = { smart = { hidden = true, layout = { preset = "vscode" }, filter = { cwd = true } } },
        win = {
            input = {
                keys = {
                    ["jk"] = { function() vim.cmd.stopinsert() end, mode = { "i" } },
                    ["<Esc>"] = { "close", mode = { "i", "n" } },
                    ["`"] = { "toggle_ignored", mode = { "i", "n" } },
                },
            },
        },
    },
})

require("snacks.picker").smart({
    layout = { preview = false, layout = { width = 0, height = 0 } },
    on_close = function() vim.cmd.quitall({ bang = true }) end,
    confirm = function(picker)
        local joined_paths = table.concat(vim.tbl_map(function(s) return (vim.env.PICKER_PREFIX or "") .. vim.fn.fnamemodify(s.file, ":.") end, picker:selected({ fallback = true })), " ") .. " "
        if vim.env.PICKER_OUTFILE then
            local f = assert(io.open(vim.env.PICKER_OUTFILE, "w"))
            f:write(joined_paths)
            f:close()
        else
            vim.system({ "tmux", "send-keys", "-l", joined_paths }):wait()
        end
        picker:close()
    end,
})
