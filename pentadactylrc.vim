"" Pentadactyl settings
"vim: set ft=vim: 
" @section Options {{{1
"
set noerrorbells 
" execute comands on new tab always
set newtab=all
set autocomplete=".*"

"Use characters for hints
 set hintkeys=asdflkj
 hi -a Hint font-size: 9pt !important;

"smooth scroll setting
set scrollsteps=1
set scrolltime=0
"1}}}

" @section Gui options {{{1

set guioptions=BCTs
set showtabline=multitab

"1}}}

" @section Searching {{{1

"find as you type
set incfind 

"highlight the terms
set hlfind 

"unless they contain upper-case letters
set findcase=smart 

"a toggle for search highlight
map <silent> coh :set hlfind!<CR> 

"Set up google as the default search engine
set defsearch=google 
"1}}}

" @section Completions {{{1

"show up to 35 items in the completion list
set maxitems=10

" completions s=search l=location bar h=history b=bookmarks
set complete=slb

" if one match, show it; if more list all matches until longest common
set wildmode=list:full
" }}}

" @section Mappings {{{1
"
"set the map leader since set mapleader="," doesn't work
map , <Leader>

map <Leader>t :tabopen <SPACE>
map <Leader>o :open <SPACE>
map <Leader>a :tabopen amazon-co-uk<SPACE>
map <Leader>w :tabopen wikipedia-en<SPACE>
map <Leader>g :tabopen www.gmail.com<CR>
 
" Disable some Pentadactyl default mappings
nmap d <Nop>
nmap a <Nop>
nmap w <Nop>

"close tab, I'm used to this from vimium
nmap x :tabclose<CR>

" jump to previous and next tabs - matches LH for history movement
map J :tabprevious<CR>
map 

" Disable some regular-Firefox old habits
nmap <M-F12> <Nop>
nmap <M-t> <Nop>
nmap <M-e> <Nop>
nmap <M-b> <Nop>
nmap <M-S-h> <Nop>
nmap <M-k> <Nop>
nmap <M-f> <Nop>
nmap <M-g> <Nop>
nmap <M-l> <Nop>
nmap <M-Q> <Nop>

" Faster scrolling
map -b j 8j
map -b k 8k
map -b h 8h
map -b l 8l

"1}}}

map <Leader>sp :source ~/.pentadactylrc

"@section Passkeys {{{
set passkeys=

" Gmail
set passkeys+="https://mail\.google\.com/":jkg

" Google Calendar
set passkeys+="https://www\.google\.com/calendar":jkg12345qrcnp

" Twitter
set passkeys+="https://twitter\.com/":jkg/?.nrm
" }}}
