" ------ JAVA --------------
"
"  1. AUTO BRACKETING
autocmd Filetype java imap ( ()<left>
function! My_BracketComplete()
    let char = strpart(getline('.'), col('.')-1, 1)
    if (char == ")")
        return "\<Right>"
    else
        return ")"
    endif
endfunction
autocmd FileType java inoremap ) <C-R>=My_BracketComplete()<CR>
autocmd Filetype java imap { {}<left><cr><cr><up><tab>
function! My_BraceComplete()
    let char = strpart(getline('.'), col('.')-1, 1)
    if (char == ")")
        return "\<Right>"
    else
        return "}"
    endif
endfunction
autocmd FileType java inoremap } <C-R>=My_BraceComplete()<CR>

"Take care of indents for Java.
set autoindent
set si
set softtabstop=4 shiftwidth=4 expandtab
set smarttab
let java_mark_braces_in_parens_as_errors=1
let java_highlight_all=1
let java_highlight_debug=1
let java_ignore_javadoc=1
let java_highlight_java_lang_ids=1
let java_minlines = 150

autocmd BufNewFile *.java
 \ exe "normal 0class " . expand('%:t:r') . "\n{\<Esc>1G"

"esto prende el omnicompletion para java usando el script en autoload
autocmd Filetype java set omnifunc=javacomplete#Complete 

