"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('w0rp/ale')
  call dein#add('kannokanno/previm')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/deol.nvim', { 'rev': '01203d4c9' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"w0rp/ale---------------------------------

if dein#tap('ale')
  let g:ale_lint_on_enter = 0

  " Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)

endif

"End w0rp/ale---------------------------------

"kannokanno/previm----------------------------

let g:previm_open_cmd = 'open /Applications/Google\ Chrome.app'

"End kannokanno/previm------------------------

"conf
set clipboard+=unnamed
set backspace=indent,eol,start
set list
set listchars=tab:»-,trail:.,nbsp:%,eol:↲
set number
set ruler
set expandtab
set tabstop=2


if has("autocmd")
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
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
endif
