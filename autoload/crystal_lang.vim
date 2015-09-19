let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('crystal')
let s:P = s:V.import('Process')
let s:J = s:V.import('Web.JSON')

function! s:echo_error(msg, ...) abort
    echohl ErrorMsg
    if a:0 == 0
        echomsg a:msg
    else
        echomsg call('printf', [msg] + a:000)
    endif
    echohl None
endfunction

function! crystal_lang#tool(name, file, pos, option_str) abort
    let cmd = printf(
                \   '%s tool %s --no-color %s --cursor %s:%d:%d %s',
                \   g:crystal_compiler_command,
                \   a:name,
                \   a:option_str,
                \   a:file,
                \   a:pos[1],
                \   a:pos[2],
                \   a:file
                \ )

    let output = s:P.system(cmd)
    return {"failed": s:P.get_last_status(), "output": output}
endfunction

" `pos` is assumed a returned value from getpos()
function! crystal_lang#impl(file, pos, option_str) abort
    return crystal_lang#tool('implementations', a:file, a:pos, a:option_str)
endfunction

function! s:jump_to_impl(impl) abort
    execute 'edit' a:impl.filename
    call cursor(a:impl.line, a:impl.column)
endfunction

function! crystal_lang#jump_to_definition(file, pos) abort
    echo 'analyzing definitions under cursor...'

    let cmd_result = crystal_lang#impl(a:file, a:pos, '--format json')
    if cmd_result.failed
        return s:echo_error(cmd_result.output)
    endif

    let impl = s:J.decode(cmd_result.output)
    if impl.status !=# 'ok'
        return s:echo_error(impl.message)
    endif

    if len(impl.implementations) == 1
        call s:jump_to_impl(impl.implementations[0])
        return
    endif

    let message = "Multiple definitions detected.  Choose a number\n\n"
    for idx in range(len(impl.implementations))
        let i = impl.implementations[idx]
        let message .= printf("[%d] %s:%d:%d\n", idx, i.filename, i.line, i.column)
    endfor
    let message .= "\n"
    let idx = str2nr(input(message, "\n> "))
    call s:jump_to_impl(impl.implementations[idx])
endfunction

function! crystal_lang#context(file, pos, option_str) abort
    return crystal_lang#tool('context', a:file, a:pos, a:option_str)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
