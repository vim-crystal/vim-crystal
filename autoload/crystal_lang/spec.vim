
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

    " TODO: Make cleverer
    if base =~# '_spec$'
        let parent = fnamemodify(substitute(a:absolute_path, '/spec/', '/src/', ''), ':h')
        return parent . '/' . matchstr(base, '.\+\ze_spec$') . '.cr'
    else
        let parent = fnamemodify(substitute(a:absolute_path, '/src/', '/spec/', ''), ':h')
        return parent . '/' . base . '_spec.cr'
    endif
endfunction

function! crystal_lang#spec#switch_file(...) abort
    let path = a:0 == 0 ? expand('%:p') : fnamemodify(a:1, ':p')
    if path !~# '.cr$'
        return s:echo_error('Not crystal source file: ' . path)
    endif

    execute 'edit!' crystal_lang#spec#get_switched_path(path)
endfunction
