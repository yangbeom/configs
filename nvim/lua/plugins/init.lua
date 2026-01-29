-- plugins/init.lua
-- Plugin configurations for native package manager
-- Plugins are installed in: ~/.local/share/nvim/site/pack/plugins/start/

local M = {}

-- Pack path for native package manager
M.pack_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start"

-- Plugin list with git URLs
M.plugins = {
    -- Theme
    { name = "dracula.nvim", url = "https://github.com/Mofiqul/dracula.nvim" },

    -- Git
    { name = "vim-gitgutter", url = "https://github.com/airblade/vim-gitgutter" },
    { name = "vim-fugitive", url = "https://github.com/tpope/vim-fugitive" },

    -- UI Components
    { name = "vim-rainbow", url = "https://github.com/frazrepo/vim-rainbow" },
    { name = "lualine.nvim", url = "https://github.com/nvim-lualine/lualine.nvim" },
    { name = "bufferline.nvim", url = "https://github.com/akinsho/bufferline.nvim" },
    { name = "nvim-web-devicons", url = "https://github.com/nvim-tree/nvim-web-devicons" },

    -- File Explorer
    { name = "nvim-tree.lua", url = "https://github.com/nvim-tree/nvim-tree.lua" },

    -- Treesitter
    { name = "nvim-treesitter", url = "https://github.com/nvim-treesitter/nvim-treesitter" },

    -- LSP & Completion
    { name = "mason.nvim", url = "https://github.com/williamboman/mason.nvim" },
    { name = "nvim-cmp", url = "https://github.com/hrsh7th/nvim-cmp" },
    { name = "cmp-nvim-lsp", url = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { name = "cmp-buffer", url = "https://github.com/hrsh7th/cmp-buffer" },
    { name = "cmp-path", url = "https://github.com/hrsh7th/cmp-path" },
    { name = "cmp-vsnip", url = "https://github.com/hrsh7th/cmp-vsnip" },
    { name = "vim-vsnip", url = "https://github.com/hrsh7th/vim-vsnip" },

    -- Telescope & Dependencies
    { name = "plenary.nvim", url = "https://github.com/nvim-lua/plenary.nvim" },
    { name = "telescope.nvim", url = "https://github.com/nvim-telescope/telescope.nvim" },

    -- Debugging
    { name = "nvim-dap", url = "https://github.com/mfussenegger/nvim-dap" },

    -- FZF
    { name = "fzf", url = "https://github.com/junegunn/fzf" },
    { name = "fzf.vim", url = "https://github.com/junegunn/fzf.vim" },
}

-- Check if plugin is installed
function M.is_installed(name)
    return vim.fn.isdirectory(M.pack_path .. "/" .. name) == 1
end

-- Install a single plugin
function M.install(plugin)
    if M.is_installed(plugin.name) then
        return false
    end
    vim.fn.mkdir(M.pack_path, "p")
    local cmd = string.format("git clone --depth 1 %s %s/%s", plugin.url, M.pack_path, plugin.name)
    print("Installing " .. plugin.name .. "...")
    vim.fn.system(cmd)
    return true
end

-- Install all plugins
function M.install_all()
    local installed = 0
    for _, plugin in ipairs(M.plugins) do
        if M.install(plugin) then
            installed = installed + 1
        end
    end
    if installed > 0 then
        print(string.format("Installed %d plugins. Please restart Neovim.", installed))
    else
        print("All plugins already installed.")
    end
end

-- Update all plugins
function M.update_all()
    for _, plugin in ipairs(M.plugins) do
        local path = M.pack_path .. "/" .. plugin.name
        if vim.fn.isdirectory(path) == 1 then
            print("Updating " .. plugin.name .. "...")
            vim.fn.system("git -C " .. path .. " pull")
        end
    end
    print("Update complete. Please restart Neovim.")
end

-- Clean removed plugins
function M.clean()
    local installed = vim.fn.glob(M.pack_path .. "/*", false, true)
    local plugin_names = {}
    for _, p in ipairs(M.plugins) do
        plugin_names[p.name] = true
    end
    for _, path in ipairs(installed) do
        local name = vim.fn.fnamemodify(path, ":t")
        if not plugin_names[name] then
            print("Removing " .. name .. "...")
            vim.fn.delete(path, "rf")
        end
    end
    print("Clean complete.")
end

-- Commands
vim.api.nvim_create_user_command("PlugInstall", function() M.install_all() end, {})
vim.api.nvim_create_user_command("PlugUpdate", function() M.update_all() end, {})
vim.api.nvim_create_user_command("PlugClean", function() M.clean() end, {})

-- Auto-install on first run
local missing = false
for _, plugin in ipairs(M.plugins) do
    if not M.is_installed(plugin.name) then
        missing = true
        break
    end
end
if missing then
    vim.defer_fn(function()
        M.install_all()
    end, 100)
end

return M
