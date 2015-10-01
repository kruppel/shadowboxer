set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'bling/vim-airline'
Plugin 'fatih/vim-go'
Plugin 'gmarik/Vundle.vim'
Plugin 'junegunn/seoul256.vim'
Plugin 'Keithbsmiley/swift.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'L9'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/ruby-matchit'

call vundle#end()

filetype plugin indent on

syntax enable
set laststatus=2
set ruler
set encoding=utf-8

set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set list
set backspace=indent,eol,start

set listchars=
set listchars=tab:\ \
set listchars+=trail:.
set listchars+=extends:>
set listchars+=precedes:<

set hlsearch
set incsearch
set ignorecase
set smartcase

set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*

set backupdir^=~/.vim/_backup//
set directory^=~/.vim/_temp//

set pastetoggle=<F2>
set foldmethod=manual

let g:airline_powerline_fonts=1
let g:airline_theme='zenburn'

" Moving lines
"
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Stripping whitespace
"
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>

" ctrlp
"
" Caching
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

" vim-jsx
"
" Enable JSX syntax highlighting in .js files
let g:jsx_ext_required = 0

" Use ag (the_silver_searcher)
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" seoul256
let g:seoul256_background = 234
colo seoul256
