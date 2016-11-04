"--------------------------------------------------------------------
"Plugin 설정 w
call plug#begin()
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
call plug#end()
call deoplete#enable()
"deoplete Tab으로 실행
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete() 

"--------------------------------------------------------------------
syntax on " 문법강조

set nu " 라인 넘버
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
colorscheme monokai
"-----------------------------Key mapping--------------------------------------
" Nomal Mode Key map
nmap <C-s> :w<CR>
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
" Insert Mode Key map
imap <C-s> <Esc><C-s>
imap <C-j> <Esc><C-j>
imap <C-k> <Esc><C-k>
imap <C-h> <Esc><C-h>
imap <C-l> <Esc><C-l>

let g:airline_theme='jellybeans'
