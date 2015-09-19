" Vim syntastic plugin helper
" Language:     Crystal
" Author:       Vitalii Elenhaupt<velenhaupt@gmail.com>

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

let g:crystal_compiler_command = get(g:, 'crystal_compiler_command', 'crystal')

command! -nargs=* CrystalImpl echo crystal_lang#impl(expand('%'), getpos('.'), <q-args>).output
command! -nargs=0 CrystalDef call crystal_lang#jump_to_definition(expand('%'), getpos('.'))
command! -nargs=* CrystalContext echo crystal_lang#context(expand('%'), getpos('.'), <q-args>).output
command! -nargs=* CrystalHierarchy echo crystal_lang#type_hierarchy(expand('%'), <q-args>)

nnoremap <Plug>(crystal-jump-to-definition) :<C-u>CrystalDef<CR>
nnoremap <Plug>(crystal-show-context) :<C-u>CrystalContext<CR>

if get(g:, 'crystal_define_mappings', 1)
    augroup plugin-ft-crystal
        autocmd!
        autocmd FileType crystal nmap <buffer>gd <Plug>(crystal-jump-to-definition)
        autocmd FileType crystal nmap <buffer>gc <Plug>(crystal-show-context)
    augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo
