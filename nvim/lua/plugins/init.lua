-- plugins/init.lua
-- Plugin declarations and user commands backed by vim.pack

local M = {}

local function gh(repo)
    return "https://github.com/" .. repo
end

M.legacy_pack_root = vim.fn.stdpath("data") .. "/site/pack/plugins"
M.pack_root = vim.fn.stdpath("data") .. "/site/pack/core/opt"
M.lockfile = vim.fs.joinpath(vim.fn.stdpath("config"), "nvim-pack-lock.json")

M.plugins = {
    -- Theme
    { name = "dracula.nvim", src = gh("Mofiqul/dracula.nvim") },

    -- Git
    { name = "vim-gitgutter", src = gh("airblade/vim-gitgutter") },
    { name = "vim-fugitive", src = gh("tpope/vim-fugitive") },

    -- UI Components
    { name = "vim-rainbow", src = gh("frazrepo/vim-rainbow") },
    { name = "lualine.nvim", src = gh("nvim-lualine/lualine.nvim") },
    { name = "bufferline.nvim", src = gh("akinsho/bufferline.nvim") },
    { name = "nvim-web-devicons", src = gh("nvim-tree/nvim-web-devicons") },

    -- File Explorer
    { name = "nvim-tree.lua", src = gh("nvim-tree/nvim-tree.lua") },

    -- LSP & Completion
    { name = "mason.nvim", src = gh("williamboman/mason.nvim") },
    { name = "nvim-cmp", src = gh("hrsh7th/nvim-cmp") },
    { name = "nvim-autopairs", src = gh("windwp/nvim-autopairs") },
    { name = "cmp-nvim-lsp", src = gh("hrsh7th/cmp-nvim-lsp") },
    { name = "cmp-buffer", src = gh("hrsh7th/cmp-buffer") },
    { name = "cmp-path", src = gh("hrsh7th/cmp-path") },
    { name = "cmp-vsnip", src = gh("hrsh7th/cmp-vsnip") },
    { name = "vim-vsnip", src = gh("hrsh7th/vim-vsnip") },

    -- Telescope & Dependencies
    { name = "plenary.nvim", src = gh("nvim-lua/plenary.nvim") },
    { name = "telescope.nvim", src = gh("nvim-telescope/telescope.nvim") },

    -- Debugging
    { name = "nvim-dap", src = gh("mfussenegger/nvim-dap") },

    -- FZF
    { name = "fzf", src = gh("junegunn/fzf") },
    { name = "fzf.vim", src = gh("junegunn/fzf.vim") },
}

local function deepcopy_specs(specs)
    return vim.tbl_map(function(spec)
        return vim.deepcopy(spec)
    end, specs)
end

local function configured_names()
    local names = {}
    for _, spec in ipairs(M.plugins) do
        table.insert(names, spec.name)
    end
    table.sort(names)
    return names
end

local function filtered_specs(names)
    if not names or vim.tbl_isempty(names) then
        return deepcopy_specs(M.plugins), {}
    end

    local wanted = {}
    local missing = {}
    local specs = {}

    for _, name in ipairs(names) do
        wanted[name] = true
    end

    for _, spec in ipairs(M.plugins) do
        if wanted[spec.name] then
            table.insert(specs, vim.deepcopy(spec))
            wanted[spec.name] = nil
        end
    end

    for name in pairs(wanted) do
        table.insert(missing, name)
    end

    table.sort(missing)

    return specs, missing
end

local function merged_plugin_names()
    local names = {}

    for _, name in ipairs(configured_names()) do
        names[name] = true
    end

    for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
        names[plugin.spec.name] = true
    end

    local all = {}
    for name in pairs(names) do
        table.insert(all, name)
    end
    table.sort(all)

    return all
end

local function complete_plugin_names(arg_lead)
    local matches = {}
    for _, name in ipairs(merged_plugin_names()) do
        if name:find("^" .. vim.pesc(arg_lead)) then
            table.insert(matches, name)
        end
    end
    return matches
end

local function normalize_names(names)
    if not names or vim.tbl_isempty(names) then
        return nil
    end
    return names
end

local function notify_missing(names)
    if not names or vim.tbl_isempty(names) then
        return
    end

    vim.notify(
        "Unknown plugin name(s): " .. table.concat(names, ", "),
        vim.log.levels.ERROR
    )
end

function M.add(names, opts)
    local specs, missing = filtered_specs(names)
    notify_missing(missing)
    if vim.tbl_isempty(specs) then
        return
    end

    local add_opts = vim.tbl_extend("force", {
        confirm = false,
    }, opts or {})

    vim.pack.add(specs, add_opts)
end

function M.update(names, opts)
    vim.pack.update(normalize_names(names), opts)
end

function M.status(names)
    vim.pack.update(normalize_names(names), { offline = true })
end

function M.clean()
    local inactive = {}

    for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
        if not plugin.active then
            table.insert(inactive, plugin.spec.name)
        end
    end

    if vim.tbl_isempty(inactive) then
        vim.notify("No inactive vim.pack plugins to remove.")
        return
    end

    table.sort(inactive)
    vim.pack.del(inactive)
    vim.notify("Removed inactive vim.pack plugins: " .. table.concat(inactive, ", "))
end

function M.clean_legacy()
    if vim.fn.isdirectory(M.legacy_pack_root) == 0 then
        vim.notify("Legacy package directory not found: " .. M.legacy_pack_root)
        return
    end

    vim.fn.delete(M.legacy_pack_root, "rf")
    vim.notify("Removed legacy package directory: " .. M.legacy_pack_root)
end

local function create_commands()
    vim.api.nvim_create_user_command("PackInstall", function(args)
        M.add(args.fargs)
    end, {
        nargs = "*",
        complete = complete_plugin_names,
    })

    vim.api.nvim_create_user_command("PackUpdate", function(args)
        M.update(args.fargs, { force = args.bang })
    end, {
        nargs = "*",
        bang = true,
        complete = complete_plugin_names,
    })

    vim.api.nvim_create_user_command("PackStatus", function(args)
        M.status(args.fargs)
    end, {
        nargs = "*",
        complete = complete_plugin_names,
    })

    vim.api.nvim_create_user_command("PackClean", function()
        M.clean()
    end, {})

    vim.api.nvim_create_user_command("PackCleanLegacy", function()
        M.clean_legacy()
    end, {})

    vim.api.nvim_create_user_command("PlugInstall", function(args)
        M.add(args.fargs)
    end, {
        nargs = "*",
        complete = complete_plugin_names,
    })

    vim.api.nvim_create_user_command("PlugUpdate", function(args)
        M.update(args.fargs, { force = args.bang })
    end, {
        nargs = "*",
        bang = true,
        complete = complete_plugin_names,
    })

    vim.api.nvim_create_user_command("PlugClean", function()
        M.clean()
    end, {})
end

create_commands()
M.add()

if vim.fn.isdirectory(M.legacy_pack_root) == 1 then
    vim.schedule(function()
        vim.notify(
            "Legacy plugins still exist at " .. M.legacy_pack_root .. ". Run :PackCleanLegacy after verifying vim.pack startup.",
            vim.log.levels.WARN
        )
    end)
end

return M
