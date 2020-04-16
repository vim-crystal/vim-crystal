" Vim syntastic plugin
" Language:     Crystal
" Author:       Vitalii Elenhaupt<velenhaupt@gmail.com>
"
" See for details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists('g:loaded_syntastic_crystal_crystal_checker')
  finish
endif

let g:loaded_syntastic_crystal_crystal_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_crystal_crystal_GetLocList() dict
  let file = expand('%:p')
  let entrypoint = crystal_lang#entrypoint_for(file)
  let makeprg = self.makeprgBuild({
        \   'args': 'run --no-codegen --no-color',
        \   'post_args': entrypoint ==# file ? '' : entrypoint
        \ })
  let errorformat =
        \ '%ESyntax error in line %l: %m,'.
        \ '%ESyntax error in %f:%l: %m,'.
        \ '%EError in %f:%l: %m,'.
        \ '%C%p^,'.
        \ '%-C%.%#'

  try
    let result = SyntasticMake({
          \   'makeprg': makeprg,
          \   'errorformat': errorformat
          \ })
    return result
  finally
    if file !=# entrypoint
      call delete(entrypoint)
    endif
  endtry
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \   'filetype': 'crystal',
      \   'name': 'crystal'
      \ })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: sw=2 sts=2 et:
