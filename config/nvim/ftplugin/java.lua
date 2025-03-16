local workspace_dir = vim.fn.stdpath("cache") .. "/java/workspace/" .. vim.uv.cwd():match("^.+/(.+)$")
local install_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls" -- this is require("mason-registry").get_package("jdtls"):get_install_path()
local platform = vim.fn.has("macunix") and "mac" or "linux"
local config = {
    cmd = { -- exec_args in ~/.local/share/nvim/mason/packages/jdtls/bin/jdtls.py + lombok.jar
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dosgi.checkConfiguration=true",
        "-Dosgi.sharedConfiguration.area=" .. install_path .. "/config_" .. platform,
        "-Dosgi.sharedConfiguration.area.readOnly=true",
        "-Dosgi.configuration.cascaded=true",
        "-javaagent:" .. install_path .. "/lombok.jar",
        "-Xms1G",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-data",
        workspace_dir,
    },
    settings = { java = { sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } } } },
}
require("jdtls").start_or_attach(config)

vim.keymap.set("n", "<leader>D", "<Cmd>lua require('jdtls').super_implementation()<CR>", { buffer = true })
vim.keymap.set("n", "<C-t>", function()
    local filename = vim.fn.expand("%:t:r")
    filename = string.sub(filename, -4) == "Test" and string.sub(filename, 1, -5) or filename .. "Test"
    require("snacks.picker").files({ on_show = function() vim.cmd.stopinsert() end, search = filename })
end, { buffer = true })
