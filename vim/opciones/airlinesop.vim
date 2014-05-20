"symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
"fugitive
let g:airline#extensions#branch#enabled = 1

"syntastic
let g:airline#extensions#syntastic#enabled = 1

"tagbar
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 's'

"trailing whitespaces warning
let g:airline#extensions#whitespace#enabled = 1

"show line count of file
call airline#parts#define_raw('linec', '%L')
let g:airline_section_z = airline#section#create(['%3p%%', 'linenr', '/', 'linec', ':%3c '])
