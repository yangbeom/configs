-- plugins.lua
-- Load plugin manager and configure plugins

-- Load native package manager helper
require("plugins.init")

-- Plugin Configurations
-- =====================

-- Theme: Dracula
vim.cmd([[
    silent! colorscheme dracula
]])

-- Rainbow brackets
vim.g.rainbow_active = 1

-- Lualine (status line)
local ok_lualine, lualine = pcall(require, "lualine")
if ok_lualine then
    lualine.setup({
        options = {
            theme = 'dracula',
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'filename' },
            lualine_c = {},
            lualine_x = {
                {
                    'diagnostics',
                    sources = { 'nvim_lsp' },
                    symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                },
                'filetype',
                'encoding',
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
    })
end

-- Bufferline (tab line)
local ok_bufferline, bufferline = pcall(require, "bufferline")
if ok_bufferline then
    bufferline.setup({
        options = {
            mode = 'buffers',
            numbers = 'ordinal',
            diagnostics = 'nvim_lsp',
            diagnostics_indicator = function(count, level)
                local icon = level:match('error') and ' ' or ' '
                return ' ' .. icon .. count
            end,
            show_buffer_close_icons = false,
            show_close_icon = false,
            separator_style = 'thin',
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = 'File Explorer',
                    highlight = 'Directory',
                    separator = true,
                },
            },
        },
    })
end

-- Nvim-tree (file explorer)
local ok_nvimtree, nvimtree = pcall(require, "nvim-tree")
if ok_nvimtree then
    nvimtree.setup()
end

-- Treesitter
local ok_ts, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok_ts then
    ts_configs.setup({
        highlight = { enable = true },
        rainbow = { enable = true },
    })
end

-- Mason (LSP installer)
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
    mason.setup()
end

-- LSP config (Neovim 0.11+ native API)
-- LSP 키맵 설정
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

        -- Inlay hints 토글 키맵
        vim.keymap.set('n', '<leader>ih', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
        end, opts)

        -- Inlay hints 자동 활성화
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.supports_method('textDocument/inlayHint') then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

-- cmp-nvim-lsp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- 언어 서버 설정 (vim.lsp.start - Neovim 0.11+)
local servers = {
    rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json' },
    },
    lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', 'init.lua' },
    },
    pyright = {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt' },
    },
    ts_ls = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        root_markers = { 'package.json', 'tsconfig.json' },
    },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'rust', 'lua', 'python', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        for name, config in pairs(servers) do
            if vim.tbl_contains(config.filetypes, ft) then
                -- Check if command exists
                if vim.fn.executable(config.cmd[1]) == 1 then
                    vim.lsp.start({
                        name = name,
                        cmd = config.cmd,
                        root_dir = vim.fs.root(args.buf, config.root_markers),
                        capabilities = capabilities,
                    })
                end
                break
            end
        end
    end,
})

-- Nvim-cmp (completion)
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
    cmp.setup({
        sources = {
            { name = "nvim_lsp" },
            { name = "vsnip" },
            { name = "path" },
            { name = "buffer" },
        },
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
    })
end
