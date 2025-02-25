"Plugin 설정
call plug#begin()
Plug 'navarasu/onedark.nvim' " onedark theme
Plug 'Mofiqul/dracula.nvim' "dracula theme
Plug 'airblade/vim-gitgutter' " git changeed label
Plug 'tpope/vim-fugitive'

Plug 'majutsushi/tagbar'
Plug 'frazrepo/vim-rainbow'

Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua' " like nerdtree

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/vim-vsnip'

Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Debugging
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mfussenegger/nvim-dap'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'github/copilot.vim'

call plug#end()

"-----------------------------------------------------------------------------
lua << EOF
vim.api.nvim_create_autocmd('BufWritePre', {
	  pattern = '',
  command = ":%s/\\s\\+$//e"
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = "*.rs",
	command = "lua vim.lsp.buf.formatting_sync(nil, 200)"
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = "*.rs",
	command = ":setlocal tags=./rusty-tags.vi;/$RUST_SRC_PATH/rusty-tags.vi"
})
vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = "*.rs",
	command = ':silent! exec "!rusty-tags vi --quiet --start-dir=" . expand(\'%:p:h\') . "&" | redraw!'
})

vim.o.syntax = "on"
vim.o.number = ture
vim.o.relativenumber = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.autoread = true
vim.o.title = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.fileencoding = "utf-8"
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.wo.signcolumn = "yes"
vim.o.textwidth = 119
vim.o.colorcolumn = "120"
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.ruler = true
vim.o.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·"
vim.o.list = true

require("nvim-tree-conf")
require("nvim-treesitter-conf")
require("nvim-lspconfig-conf")
require("nvim-cmp-conf")
require("nvim-lualine-conf")
require("nvim-bufferline-conf")
require("mason-conf")
EOF


"-----------------------------Key mapping-------------------------------------
" Nomal Mode Key map
nmap <C-s> :w<CR>
nmap <C-n> :NvimTreeToggle<Enter>
nmap <F8> :TagbarToggle<Enter>
" Insert Mode Key map
imap <C-s> <Esc><C-s>
imap <C-n> <Esc><C-n>
imap <F8> <Esc><F8>

"color onedark
color dracula

let g:rainbow_active = 1

" vsnip config
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menu,menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c


" Quick-fix
" nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

"Telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

set rtp+=/opt/homebrew/opt/fzf

