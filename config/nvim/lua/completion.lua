local map = require("utils").map

require("compe").setup {
    source = {
        path = {kind = "", true},
        buffer = {kind = "﬘", true},
        calc = {kind = "", true},
        vsnip = {kind = "﬌"},
        nvim_lsp = true,
        nvim_lua = true
    },
    documentation = {
        border = "rounded"
    }
}

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function check_back_space()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

function _G.tab_complete()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif vim.fn.call("vsnip#jumpable", {1}) == 1 then
        return t "<Plug>(vsnip-jump-next)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn["compe#complete"]()
    end
end

function _G.s_tab_complete()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

function _G.cr_confirm()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"]("<CR>")
        else
            return t "<CR>"
        end
    else
        return t "<C-g>u<CR><C-r>=AutoPairsReturn()<CR>"
    end
end

map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("i", "<CR>", "v:lua.cr_confirm()", {expr = true, noremap = true, silent = true})
map("i", "<C-Space>", "compe#complete()", {expr = true, noremap = true})
map("i", "<Down>", "pumvisible() ? '<C-n>' : '<C-o>gj'", {expr = true, noremap = true})
map("i", "<Up>", "pumvisible() ? '<C-p>' : '<C-o>gk'", {expr = true, noremap = true})
