" variables for mac/windows settings  {{{
let s:windows = has('win32') || has('win64')
let s:mac_gui = has('gui_macvim')
" }}}
" pathogen initialisation  {{{
"pathogen is in a submodule so need this at the beginning of vimrc
source ~/dotfiles/vim/bundle/vim-pathogen/autoload/pathogen.vim
filetype off
"disable plugins that I don't want instead of removing them completely

if s:mac_gui
    let g:pathogen_disabled = []
else
    let g:pathogen_disabled = []
endif

call pathogen#infect()
call pathogen#incubate()
call pathogen#helptags()
" }}}

"Source stuff  {{{
source $HOME/dotfiles/vim/opciones/globales.vim "global options
source $HOME/dotfiles/vim/opciones/keys.vim "maps and keys
source $HOME/dotfiles/vim/opciones/opjava.vim
source $HOME/dotfiles/vim/opciones/opspell.vim
source $HOME/dotfiles/vim/opciones/LatexStuff.vim  "latex stuff
source $HOME/dotfiles/vim/opciones/colors.vim "colorschemes
source $HOME/dotfiles/vim/opciones/syntasticop.vim "syntastic options
source $HOME/dotfiles/vim/opciones/nerdop.vim "powerline options
source $HOME/dotfiles/vim/opciones/tasklistop.vim "task list options
source $HOME/dotfiles/vim/opciones/vim-latexop.vim "vim latex options
source $HOME/dotfiles/vim/opciones/bashop.vim "vim-bash options
source $HOME/dotfiles/vim/opciones/goldenview.vim "goldenview options
source $HOME/dotfiles/vim/opciones/customFunctions.vim "simple custom functions
source $HOME/dotfiles/vim/opciones/uniteop.vim "unite plugin options
source $HOME/dotfiles/vim/opciones/tagbarop.vim "tagbar plugin options
source $HOME/dotfiles/vim/opciones/airlinesop.vim "airline plugin options
"}}}

" Vim marker folding method for vimscripts {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType sh setlocal foldmethod=marker
augroup END
" }}}

" Autoload configuration when this file changes ($MYVIMRC) {{{
autocmd! BufWritePost vimrc source %
" }}}
