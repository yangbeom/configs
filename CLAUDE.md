# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for macOS development environment: zsh, tmux, Neovim, and Hammerspoon.

## Architecture

```
configs/
├── .zshrc              # Zsh shell config (Oh My Zsh + Powerlevel10k)
├── tmux.conf           # Tmux config (prefix: Ctrl+A)
├── nvim/               # Neovim configuration (Lua-based)
│   ├── init.lua        # Entry point - loads core and plugins
│   ├── lua/
│   │   ├── core/
│   │   │   ├── options.lua   # Editor settings
│   │   │   └── keymaps.lua   # Key bindings
│   │   └── plugins.lua       # Plugin definitions
│   └── plugins/        # Individual plugin configurations
└── init.vim            # Legacy Vim config (deprecated, migrated to Lua)
```

## Neovim Plugin Manager

Uses Neovim's native plugin manager (`:h packages`).

## Key Configurations

**Neovim key mappings** (defined in `nvim/lua/core/keymaps.lua`):
- `Ctrl+S` - Save file
- `Ctrl+N` - Toggle file explorer (nvim-tree)
- `F8` - Toggle code outline (Tagbar)
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)

**Tmux prefix**: `Ctrl+A` (not default `Ctrl+B`)

## Deployment

Files should be symlinked to their standard locations:
- `.zshrc` → `~/.zshrc`
- `tmux.conf` → `~/.tmux.conf`
- `nvim/` → `~/.config/nvim/`
