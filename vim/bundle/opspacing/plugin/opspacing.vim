"==============================================================================
" File:        correctSpacing.vim
" Description: function that sets good spacing around operators
" Maintainer:  Alberto Sadde <albertosadde at gmail dot com>
" Last Change: 15 March 2014
" Version: 0.01
" License:  This file is placed in the public domain
"==============================================================================
"
"1+2
"avoid loading the plugin more than onces
if exists("g:loaded_opspacing") || &cp
    finish
endif
let g:loaded_opspacing = 1

"saving state to avoid problems when on compatible mode
let s:save_cpo = &cpo
set cpo&vim

"Mappings {{{
if !hasmapto('<Plug>OpspacingCorr')
    map <unique> <leader>e <Plug>OpspacingCorr
endif

noremap <unique> <script> <Plug>OpspacingCorr <SID>CorrectSpacing
noremap <SID>CorrectSpacing :call <SID>CorrectSpacing()<CR>

"Register user command
if !exists(":CorrSpacing")
    command -nargs=0 CorrSpacing :call s:CorrectSpacing()
endif
"}}}

" Function: OpSpacing() function is used to change the spacing of the given operator {{{1
" Args: 
" line_num: the line number that we are currently parsing
" operator: the operator we are changing
function s:OpSpacing(line_num, operator)
    let text = getline(a:line_num)
    let replace_pattern = '\(\d\)\('.a:operator.'\)\(\d\)'
    let corr = '\1 \2 \3'
    let result = substitute(text, replace_pattern,  corr, 'g')
    call setline(a:line_num, result)
endfunction
"1}}}

" Function: CorrectSpacing() loops through the whole file and calls OpSpacing "{{{1
function s:CorrectSpacing()
    let op_list = ['+', '-', '\*', '=']
    if exists("g:custom_operator_map")
        call extend(op_list, g:custom_operator_map) "extends the list to contain user defined operators
    endif
    for line_num in range (0, line('$'))
        for op in op_list
            call s:OpSpacing(line_num, op)
            "FIXME parsing line two times to fix odd cases like 1+2+3
            " first pass fixes 1 + 2+3, second fixes all 1 + 2 +3
            call s:OpSpacing(line_num, op)
        endfor
    endfor
endfunction
"1}}}
"restore state
let &cpo = s:save_cpo
unlet s:save_cpo
