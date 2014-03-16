"==============================================================================
" File:        correctSpacing.vim
" Description: function that sets good spacing around operators
" Maintainer:  Alberto Sadde <albertosadde at gmail dot com>
" Last Change: 15 March 2014
" License:     
"==============================================================================
"
" Function: OpSpacing() function is used to change the spacing of the given operator {{{1
" Args: 
" line_num: the line number that we are currently parsing
" operator: the operator we are changing
"
"TODO: use a better regex
function! OpSpacing(line_num, operator)
    let text = getline(a:line_num)
    " this is the pattern I'm using/+\@<!++\@!
    let d_op = a:operator . a:operator
    let pattern = a:operator . '\@<!' . d_op . '\@!'
    let corr = ' ' . a:operator . ' '
    let result = substitute(text, pattern,  corr, 'g')
    call setline(a:line_num, result)
endfunction
"1}}}

" Function: CorrectSpacing() loops through the whole file and calls OpSpacing "{{{1
function! CorrectSpacing()
    let op_list = ['+', '-', '\*', '=']
    for line_num in range (0, line('$'))
        for op in op_list
            call OpSpacing(line_num, op)
        endfor
    endfor
endfunction
"1}}}
"
