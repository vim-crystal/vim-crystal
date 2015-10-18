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

let g:crystal_compiler_command = get(g:, 'crystal_compiler_command', 'crystal')
let g:crystal_auto_format = get(g:, 'crystal_auto_format', 0)

command! -nargs=* CrystalImpl echo crystal_lang#impl(expand('%'), getpos('.'), <q-args>).output
command! -nargs=0 CrystalDef call crystal_lang#jump_to_definition(expand('%'), getpos('.'))
command! -nargs=* CrystalContext echo crystal_lang#context(expand('%'), getpos('.'), <q-args>).output
command! -nargs=* CrystalHierarchy echo crystal_lang#type_hierarchy(expand('%'), <q-args>)
command! -nargs=? CrystalSpecSwitch call crystal_lang#switch_spec_file(<f-args>)
command! -nargs=? CrystalSpecRunAll call crystal_lang#run_all_spec(<f-args>)
command! -nargs=? CrystalSpecRunCurrent call crystal_lang#run_current_spec(<f-args>)
command! -nargs=* -bar CrystalFormat call crystal_lang#format(<q-args>)

nnoremap <Plug>(crystal-jump-to-definition) :<C-u>CrystalDef<CR>
nnoremap <Plug>(crystal-show-context) :<C-u>CrystalContext<CR>
nnoremap <Plug>(crystal-spec-switch) :<C-u>CrystalSpecSwitch<CR>
nnoremap <Plug>(crystal-spec-run-all) :<C-u>CrystalSpecRunAll<CR>
nnoremap <Plug>(crystal-spec-run-current) :<C-u>CrystalSpecRunCurrent<CR>
nnoremap <Plug>(crystal-format) :<C-u>CrystalFormat<CR>

augroup plugin-ft-crystal
    autocmd!
    autocmd BufWritePre * if &ft ==# 'crystal' && g:crystal_auto_format | CrystalFormat | endif
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
