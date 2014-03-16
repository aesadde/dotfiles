" KEYS OPTIONS ---------------------------------- {{{

"map Leader
let mapleader=","
let g:mapleader=","

"-------MISC--------------{{{
"fast saving 
noremap <Leader>w :w!<CR> 
noremap <Leader>q :wq<CR>

"funcion para prender y apagar el spelling
nmap <silent> <leader>s :set spell!<CR>

"fast vimrc editing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
"-----MISC--------
"}}}

"-----TEXT FORMATTING-----------------{{{
"toggle paste mode
noremap <Leader>ps :set nopaste<CR>
noremap <Leader>sp :set paste<CR>
inoremap <C-v> <esc>"+gP<CR>

"paste key, con buena indentacion
noremap <Leader>p p=`]
"indenta de manera correcta todo el archivo
noremap <Leader>= 1G=G

"append semicolon at end of line
"inoremap ; <esc>A;
"nnoremap ; mqA;<esc>`q"
"-----TEXT FORMATTING END----"
"}}}

"-----PLUGINS SHORTCUTS------------{{{

"taglist
noremap <leader>lt :TlistToggle<CR>
"tasklist 
nmap <Leader>td <Plug>TaskList

"gundo
noremap <Leader>g :GundoToggle<CR>

"nerd tree
noremap <Leader>n :NERDTreeToggle<CR>

"Ack, like grep but better
nnoremap <leader>a <Esc>:Ack!

"syntastic manual check
noremap <leader>ch :SyntasticCheck<CR>
noremap <Leader>stm :SyntasticToggleMode<CR>

"Clear highlights from search
noremap <Leader>/ :nohls<CR>

"Tagbar
"abre la lista de tags
noremap <Leader>ts :TagbarToggle<CR> 
"--------PLUGINS SHORTCUTS END ------"
"}}}

"--------------MOTION---------------------{{{
"one screen line at a time (instead of vim line)
nnoremap j gj
nnoremap k gk
"renoremap CTRL-F/B" to move page up or down
nnoremap J <c-F>
nnoremap K <c-B>

"cambio de buffer mas rapido
noremap <Leader>b :bn<CR>
"remove buffer
noremap <Leader>db :bd<CR>

noremap <Leader>m :execute "vimgrep /" . expand("<cword>") . "/jg ./**/*.cu *.cpp" <cr>:copen<cr>
"windows navigation
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l
noremap <c-h> <c-w>h

"this are to get used to NOT use arrow keys in insert mode (good practice is
"to exit to normal mode and move using normal keysnormal keys
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Move to next error after make
nnoremap  <leader>ne :cnext<cr>
nnoremap  <leader>pe :cprevious<cr>
"-------MOTION END----------------"
"}}}
" }}}
