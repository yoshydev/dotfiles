"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" dein settings {{{
" Auto install dein.vim
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" load cache and create cache
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dotfiles/vimrc/dein.toml'
let s:lazy_toml_file = fnamemodify(expand('<sfile>'), ':h').'/dotfiles/vimrc/dein_lazy.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:lazy_toml_file, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif
" plugin auto installing
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

" Required:
filetype plugin indent on
syntax enable

" Color scheme
" colorscheme nord
"colorscheme solarized


"End dein Scripts-------------------------

"conf
set encoding=utf-8
set clipboard+=unnamed
set backspace=indent,eol,start
set list
set listchars=tab:»-,trail:.,nbsp:%,eol:↲
set number
set ruler
set expandtab
set tabstop=2


if has("autocmd")
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtab
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType css         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scss        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sass        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType yaml        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType toml        setlocal sw=2 sts=2 ts=2 et
  autocmd Filetype gitconfig   setlocal sw=4 sts=4 ts=4 noexpandtab
endif
