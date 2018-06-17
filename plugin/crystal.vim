" plugin/crystal.vim for Crystal Programming Language
" Vim syntastic plugin helper by Vitalii Elenhaupt<velenhaupt@gmail.com>

if exists('g:loaded_syntastic_crystal_filetype')
  finish
endif

let g:loaded_syntastic_crystal_filetype = 1
let s:save_cpo = &cpo
set cpo&vim

" This is to let Syntastic know about the Crystal filetype.
" It enables tab completion for the 'SyntasticInfo' command.
" (This does not actually register the syntax checker.)
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external
if exists('g:syntastic_extra_filetypes')
  call add(g:syntastic_extra_filetypes, 'crystal')
else
  let g:syntastic_extra_filetypes = ['crystal']
end

let &cpo = s:save_cpo
unlet s:save_cpo
