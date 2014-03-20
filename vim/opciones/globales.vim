"Opciones Globales
set pdev=pdf
set history=1000 "aumenta el historial
set ignorecase " estas dos opciones sirven para
set smartcase  " buscar mejor, ignora mayusculas y las revisa solo si especificado
set title "para darle a la ventana el nombre del archivo
set ruler "en vez de ponerte el numero de linea, en cada linea, lo muestra al fondo
set wrap "una linea de texto por pantalla
set tags=./tags,./../tags,./*/tags
set ai "Auto indent"
set si "smart indent"

set showcmd  "shows last entered command
set lazyredraw "redraw screen only when needed

" Intuitive backspacing in insert mode
set backspace=indent,eol,start
syntax on
filetype on
filetype plugin on
filetype indent on
set incsearch " ...dynamically as they are typed
"set term=ansi
set hlsearch "highlighted search
"hell bells
set t_vb=
set novisualbell "esto sirve para que VIM no suene xD
set noerrorbells  "esto para que no ladille cuando hay errores
autocmd! GUIEnter * set vb t_vb=


"otras para probar
"Bash-like filename completion
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*.~
set mouse=a
set directory=/tmp " directory to place swap files in
set noswapfile "no quiero mas swaps
set fileformats=mac,unix,dos " support all three, in this order
set showmatch " show matching brackets

set modelines=0         " CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible        " Use Vim defaults instead of 100% vi compatibility
set backspace=2
set ofu=syntaxcomplete "esto prende el auto completion

"esto es para que no me deje escribir mas de 80 caracteres por linea
"match ErrorMsg /\%>80v.\+/
"lo que sigue es para mejorar el statusline
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [POS=%04l,%04v]\ [%p%%]
set statusline+=%{fugitive#statusline()}
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]
set laststatus=2

"set statusline+=%#waningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

set encoding=utf-8 "unicode
" highlight de la linea en la que se escribe ( columna opcional )
"set cursorcolumn
set cursorline
" auto-change directory to current buffer
autocmd BufEnter * :cd %:p:h
"diccionario para autocomplete
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

"opciones de omnifunction generales
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

"maximo de caracteres por linea
"set textwidth=80

set splitright                  " Make vertical splits work sanely
set splitbelow                  " Make horizontal splits work sanely
set nobackup                    " Don't want any backup magic
set smartindent
set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
"set number   not needed when using the cool status line
set linebreak
set display+=lastline

"code folding
set foldmethod=indent
set foldmethod=syntax
set foldlevel=20
set foldcolumn=4

"automatically reload vimrc when its saved!
au BufWritePost .vimrc so ~/.vimrc

"set errorfile list
"set errorfile = error.list
