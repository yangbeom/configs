"-----------------------------------------------------------------------------
"Plugin 설정
call plug#begin()
Plug 'navarasu/onedark.nvim' " onedark theme
Plug 'Mofiqul/dracula.nvim' "dracula theme
Plug 'airblade/vim-gitgutter' " git changeed label
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'frazrepo/vim-rainbow'

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

" Debugging
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

autocmd BufWritePre * :%s/\s\+$//e
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!
set mouse=a
"-----------------------------------------------------------------------------
syntax on " 문법강조

set nu rnu " 라인 넘버
set smartindent " 스마트한 들여쓰기
set autoindent " 자동 들여쓰기
set cindent " C프로그래밍용 자동 들여쓰기
set ts=4 " tab stop
set et
set shiftwidth=4 " 자동 들여쓰기 4칸
set showmatch " 괄호 강조
set smartcase " 검색시 대소문자 구별
set fileencoding=utf-8 " 파일저장 인코딩
set ruler " 커서 위치
set autowrite " 다른파일로 넘어갈 때 자동 저장
set autoread " 작업중인 파일 외부에서 변경됬을 경우 자동으로 불러옴
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·
set list
set textwidth=79
set cc=80
set title
set bs=indent,eol,start
set backspace=2
set clipboard+=unnamedplus
set modifiable
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

let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = "unique_tail_improved"
let g:airline_powerline_fonts = 1


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
lua << EOF
require("nvim-tree-conf")
require("nvim-treesitter-conf")
require("nvim-lspconfig-conf")
require("nvim-cmp-conf")
EOF

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

" Quick-fix
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>


set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>



