
function! s:echo_error(msg, ...) abort
    echohl ErrorMsg
    if a:0 == 0
        echomsg a:msg
    else
        echomsg call('printf', [msg] + a:000)
    endif
    echohl None
endfunction

function! crystal_lang#spec#get_switched_path(absolute_path) abort
    let base = fnamemodify(a:absolute_path, ':t:r')
    let parent = fnamemodify(a:absolute_path, ':h')

    " TODO: Make cleverer
    if base =~# '_spec$'
        return substitute(parent, '/spec/', '/src/', '') . '/' . matchstr(base, '.\+\ze_spec$') . '.cr'
    else
        return substitute(parent, '/src/', '/spec/', '') . '/' . base . '_spec.cr'
    endif
endfunction

function! crystal_lang#spec#switch_current_file() abort
    let current_path = expand('%:p')
    if current_path !~# '.cr$'
        return s:echo_error('Not crystal source file: ' . current_path)
    endif

    execute 'edit!' crystal_lang#spec#get_switched_path(current_path)
endfunction
