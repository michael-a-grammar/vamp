let g:is_nvim   = has('nvim')
let g:is_win32  = has('win32')
let g:is_mac    = has('mac')
let g:is_macvim = has('gui_macvim')
let g:is_unix   = has('unix')

if !g:is_nvim
  set nocompatible
  set background=dark

  if !exists("g:syntax_on")
    syntax enable
  endif

  filetype on
  filetype plugin on
  filetype indent on
endif

set guioptions+=M

set clipboard+=unnamed

set spelllang=en_gb,en
syntax spell toplevel

setglobal fileencoding=utf-8

set nobomb

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set nolist

set hidden
set lazyredraw
set updatetime=750

set hlsearch
set incsearch
set wrapscan

set splitbelow

set ignorecase
set smartcase

set autochdir
set path+=**
set wildignore+=*/.meteor/*,*/node_modules/*

set autoindent
set breakindent

set nostartofline

set history=1000
set wildmenu
set laststatus=2
set cmdheight=1
set showcmd
set noshowmode

set number
set relativenumber

set cursorline
set wrap
set ruler
set colorcolumn+=80

set showmatch
set matchtime=2

set ttimeout
set ttimeoutlen=50
set notimeout

set directory=~/.vim/swap/
set writebackup

set backupdir=~/.vim/backup/
set backupcopy=yes

set undodir=~/.vim/undo/
set undoreload=1000
set undolevels=1000
set undofile

set conceallevel=1
set concealcursor=nvic

set visualbell
set t_vb=

runtime macros/matchit.vim

if has('gui_running')
  if g:is_macvim
    set macthinstrokes
    set macligatures
    set antialias
    set fullscreen
  endif

  set guifont=Hasklug\ Nerd\ Font\ Mono:h24

  set guioptions+=c

  set guioptions-=b
  set guioptions-=l
  set guioptions-=m
  set guioptions-=r
  set guioptions-=L
  set guioptions-=R
  set guioptions-=T

  set guicursor+=a:blinkon0
else
  set termguicolors
endif

let g:netrw_keepdir = 0

let g:mapleader = "<space>"

map <space> <leader>

inoremap jj <esc>

nnoremap <leader>/t :nohlsearch<cr>

nnoremap <leader>ze :edit $MYVIMRC<cr>
nnoremap <leader>zz :source $MYVIMRC<cr>

noremap 0 g0
noremap ^ g^
noremap $ g$

noremap H g^
noremap L g$

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

let g:use_arrow_keys_to_navigate_windows = 0

if g:use_arrow_keys_to_navigate_windows
  nnoremap <up>    <c-w>k
  nnoremap <down>  <c-w>j
  nnoremap <left>  <c-w>h
  nnoremap <right> <c-w>l
endif

function! GetCurrentWord() abort
  return expand("<cword>")
endfunction

function! LookupInHelp() abort
  let current_word = GetCurrentWord()
  execute 'help ' . current_word
endfunction

augroup vim_filetype_functions
  autocmd!
  autocmd FileType vim
    \ nnoremap <buffer> <leader>hh :call LookupInHelp()<cr>
augroup end

call plug#begin('~/.vim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'nanotech/jellybeans.vim'
Plug 'zeis/vim-kolor'

Plug 'mhinz/vim-startify'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'scrooloose/nerdcommenter'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'easymotion/vim-easymotion'

Plug 'sjl/gundo.vim'

Plug 'maxbrunsfeld/vim-yankstack'

Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'

Plug 'chaoren/vim-wordmotion'

Plug 'junegunn/vim-easy-align'
Plug 'FooSoft/vim-argwrap'

Plug 'sickill/vim-pasta'

Plug 'Wolfy87/vim-syntax-expand'

call plug#end()

colorscheme dracula

let g:airline_theme = 'dracula'

let g:airline#extensions#tabline#enabled = 0

let g:airline_powerline_fonts     = 1
let g:airline_skip_empty_sections = 1

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

