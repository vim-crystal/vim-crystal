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
  let makeprg = self.makeprgBuild({ 'args': 'run --no-codegen --no-color' })

  let errorformat =
    \ '%ESyntax error in line %l: %m,'.
    \ '%ESyntax error in %f:%l: %m,'.
    \ '%EError in %f:%l: %m,'.
    \ '%C%p^,'.
    \ '%-C%.%#'

  return SyntasticMake({
    \ 'makeprg': makeprg,
    \ 'errorformat': errorformat })

endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
  \ 'filetype': 'crystal',
  \ 'name': 'crystal' })

let &cpo = s:save_cpo
unlet s:save_cpo
