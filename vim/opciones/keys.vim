" KEYS OPTIONS ---------------------------------- {{{

"1+2+3
"map Leader
let mapleader=","
let g:mapleader=","

"-------MISC--------------{{{
"fast saving 
nnoremap <Leader>w :w!<CR> 
nnoremap <Leader>q :wq<CR>

"funcion para prender y apagar el spelling
nmap <silent> <leader>s :set spell!<CR>

"fast vimrc editing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
"-----MISC--------
"}}}

"-----TEXT FORMATTING-----------------{{{
"toggle paste mode
nnoremap <Leader>ps :set nopaste<CR>
nnoremap <Leader>sp :set paste<CR>
inoremap <C-v> <esc>"*gP<CR>
vnoremap <C-c> "*y<CR>

"paste key, con buena indentacion
nnoremap <Leader>p p=`]
"indenta de manera correcta todo el archivo
nnoremap <Leader>= 1G=G

"append semicolon at end of line
"inoremap ; <esc>A;
"nnoremap ; mqA;<esc>`q"
"-----TEXT FORMATTING END----"
"}}}

"-----PLUGINS SHORTCUTS------------{{{
"opspacing
nnoremap <leader>os :CorrSpacing<CR>

"taglist
nnoremap <leader>lt :TlistToggle<CR>
"tasklist 
nmap <Leader>td <Plug>TaskList

"gundo
nnoremap <Leader>u :GundoToggle<CR>

"nerd tree
nnoremap <Leader>n :NERDTreeToggle<CR>

"Ack, like grep but better
nnoremap <leader>a <Esc>:Ack!

"syntastic manual check
nnoremap <leader>ch :SyntasticCheck<CR>
nnoremap <Leader>stm :SyntasticToggleMode<CR>

"Clear highlights from search
nnoremap <Leader>/ :nohls<CR>

"Tagbar
"abre la lista de tags
nnoremap <Leader>ts :TagbarToggle<CR> 
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
nnoremap <Leader>b :bn<CR>
"remove buffer
nnoremap <Leader>db :bd<CR>

nnoremap <Leader>m :execute "vimgrep /" . expand("<cword>") . "/jg ./**/*.cu *.cpp" <cr>:copen<cr>
"windows navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
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
