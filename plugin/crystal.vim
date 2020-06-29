" plugin/crystal.vim for Crystal Programming Language
" Vim syntastic plugin helper by Vitalii Elenhaupt<velenhaupt@gmail.com>

if exists('g:loaded_syntastic_crystal_filetype')
  finish
endif

let g:loaded_syntastic_crystal_filetype = 1

" This is to let Syntastic know about the Crystal filetype.
" It enables tab completion for the 'SyntasticInfo' command.
" (This does not actually register the syntax checker.)
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external
if exists('g:syntastic_extra_filetypes')
  call add(g:syntastic_extra_filetypes, 'crystal')
else
  let g:syntastic_extra_filetypes = ['crystal']
end

" Indent configuration variables:

if !exists('g:crystal_indent_assignment_style')
  " Possible values: 'variable', 'hanging'
  let g:crystal_indent_assignment_style = 'hanging'
endif

if !exists('g:crystal_indent_block_style')
  " Possible values: 'expression', 'do'
  let g:crystal_indent_block_style = 'expression'
endif

" vim: sw=2 sts=2 et:
