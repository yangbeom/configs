require("mason").setup {
    ui = {
        icons = {
            package_installed = "✓"
        }
    }
}
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls" },
}
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup {}
lspconfig.rust_analyzer.setup {}
require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        lspconfig[server_name].setup {}
    end,
    -- Next, you can provide targeted overrides for specific servers.
    ["rust_analyzer"] = function ()
        require("rust-tools").setup {
        checkOnSave = {
            command = "clippy"
        },
        }
    end,
})
