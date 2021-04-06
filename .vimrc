set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'arcticicestudio/nord-vim'
Plugin 'benmills/vimux'
Plugin 'bling/vim-airline'
Plugin 'derekwyatt/vim-scala'
Plugin 'docker/docker', {'rtp': '/contrib/syntax/vim'}
Plugin 'fatih/vim-go'
Plugin 'gmarik/Vundle.vim'
Plugin 'ianks/vim-tsx'
Plugin 'janko-m/vim-test'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/seoul256.vim'
Plugin 'Keithbsmiley/swift.vim'
Plugin 'L9'
Plugin 'leafgarland/typescript-vim'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'Quramy/tsuquyomi'
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/ruby-matchit'
Plugin 'w0rp/ale'

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

" fzf
"
" Fuzzy search finder
set rtp+=/usr/local/opt/fzf
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <C-f> :Rg<CR>

" vim-go
"
" Disable warnings for vim version
"let g:go_version_warning = 0
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

" vim-jsx
"
" Enable JSX syntax highlighting in .js files
let g:jsx_ext_required = 0

" vim-test
"
" Testing
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

let test#strategy = "vimux"

" ale
"
" Linting
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'typescript': ['eslint'],
\}
let g:ale_fixers = {
\  'javascript': ['prettier'],
\  'typescript': ['prettier'],
\  'ruby': ['rubocop'],
\}
let g:ale_enabled = 1
let g:ale_fix_on_save = 1

" seoul256
let g:seoul256_background = 234

" tsuquyomi
"
" Integrate with syntastic
let g:tsuquyomi_disable_quickfix = 1

au BufRead,BufNewFile *.avsc setfiletype javascript

" theme
" colo seoul256
colo nord
