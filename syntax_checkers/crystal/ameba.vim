" Vim syntastic plugin
" Language:     Crystal
" Author:       Vitalii Elenhaupt<velenhaupt@gmail.com>
"
" See for details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists('g:loaded_syntastic_crystal_ameba_checker')
  finish
endif

let g:loaded_syntastic_crystal_ameba_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_crystal_ameba_GetLocList() dict
  let makeprg = self.makeprgBuild({'args': '--format flycheck'})

  let errorformat = '%f:%l:%c: %t: %m'
  let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat})

  return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \   'filetype': 'crystal',
      \   'name': 'ameba'
      \ })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: sw=2 sts=2 et:
