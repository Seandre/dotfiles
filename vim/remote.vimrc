" Portable Vim config for remote Linux, WSL, and containers.
" Keep colors explicit so plain Vim stays legible inside tmux over VS Code SSH.
set nocompatible
set background=dark
set t_Co=256

if exists('&t_BE')
  let &t_BE = "\<Esc>[?2004h"
endif
if exists('&t_BD')
  let &t_BD = "\<Esc>[?2004l"
endif

if has('termguicolors')
  if exists('$TMUX')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

syntax enable
filetype plugin indent on

set number
set hidden
set mouse=a
set ttymouse=sgr
set laststatus=2
set wildmenu
set pastetoggle=<F2>

highlight clear Normal
highlight Normal ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight NormalNC ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight EndOfBuffer ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight NonText ctermfg=245 ctermbg=0 guifg=#928374 guibg=#000000
highlight LineNr ctermfg=243 ctermbg=0 guifg=#7c6f64 guibg=#000000
highlight CursorLineNr ctermfg=11 ctermbg=0 guifg=#fabd2f guibg=#000000
highlight SignColumn ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight VertSplit ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight StatusLine ctermfg=15 ctermbg=0 cterm=bold guifg=#ffffff guibg=#000000 gui=bold
highlight StatusLineNC ctermfg=245 ctermbg=0 guifg=#928374 guibg=#000000

highlight Visual ctermfg=15 ctermbg=24 guifg=#ffffff guibg=#458588
highlight Search ctermfg=0 ctermbg=11 guifg=#000000 guibg=#fabd2f
highlight IncSearch ctermfg=0 ctermbg=9 guifg=#000000 guibg=#fb4934
highlight MatchParen ctermfg=0 ctermbg=11 guifg=#000000 guibg=#fabd2f

highlight Comment ctermfg=245 ctermbg=0 guifg=#928374 guibg=#000000
highlight Constant ctermfg=13 ctermbg=0 guifg=#d3869b guibg=#000000
highlight String ctermfg=10 ctermbg=0 guifg=#b8bb26 guibg=#000000
highlight Character ctermfg=10 ctermbg=0 guifg=#b8bb26 guibg=#000000
highlight Number ctermfg=13 ctermbg=0 guifg=#d3869b guibg=#000000
highlight Boolean ctermfg=13 ctermbg=0 guifg=#d3869b guibg=#000000
highlight Identifier ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight Function ctermfg=11 ctermbg=0 guifg=#fabd2f guibg=#000000
highlight Statement ctermfg=9 ctermbg=0 guifg=#fb4934 guibg=#000000
highlight Keyword ctermfg=9 ctermbg=0 guifg=#fb4934 guibg=#000000
highlight Operator ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight PreProc ctermfg=14 ctermbg=0 guifg=#8ec07c guibg=#000000
highlight Type ctermfg=11 ctermbg=0 guifg=#fabd2f guibg=#000000
highlight Special ctermfg=208 ctermbg=0 guifg=#fe8019 guibg=#000000
highlight Underlined ctermfg=12 ctermbg=0 cterm=underline guifg=#83a598 guibg=#000000 gui=underline
highlight Error ctermfg=9 ctermbg=0 cterm=bold guifg=#fb4934 guibg=#000000 gui=bold
highlight Todo ctermfg=0 ctermbg=11 cterm=bold guifg=#000000 guibg=#fabd2f gui=bold

highlight DiffAdd ctermfg=10 ctermbg=0 guifg=#b8bb26 guibg=#000000
highlight DiffChange ctermfg=11 ctermbg=0 guifg=#fabd2f guibg=#000000
highlight DiffDelete ctermfg=9 ctermbg=0 guifg=#fb4934 guibg=#000000
highlight DiffText ctermfg=0 ctermbg=11 guifg=#000000 guibg=#fabd2f

highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
highlight PmenuSel ctermfg=15 ctermbg=24 guifg=#ffffff guibg=#458588
