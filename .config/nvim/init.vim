" Tobis vim.rc

set nocompatible              " be iMproved, required
filetype off                  " required
set wildmode=longest:full,list:full

" Color {{{
syntax enable
" }}}
" UI Layout {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu
"set lazyredraw
set showmatch           " higlight matching parenthesis
" }}}
" Searching {{{
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
" }}}
" Folding {{{

" for folding
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
set foldlevelstart=10    " start with fold level of 1
" }}}

" Recommendations {{{
" Keep longer and faster history
set hidden " keep abandoned buffers in memory
set history=100

" highlight seachre
set hlsearch

" Show matching parenthesis when under cursor
set showmatch

let mapleader = " "

" shortcut to source vim conig
map <leader>` :source ~/.config/nvim/init.vim<CR>

" Move between panes
" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" show list of errors and warnings on the current file
nmap <silent> <leader>e :Errors<CR>

" Indentation
set tabstop=2
set shiftwidth=2
set expandtab
" for html/rb files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab

" for js/coffee/jade files, 4 spaces
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab 

" vim:foldmethod=marker:foldlevel=0
