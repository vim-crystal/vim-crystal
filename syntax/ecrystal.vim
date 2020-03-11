" Vim syntax file
" Language: eCrystal
" Original author: Tim Pope <vimNOSPAM@tpope.org>
" Maintainer: rhysd <https://rhysd.github.io>
"
" Based on eruby syntax highlight from vim-ruby
" which was made by Tim Pope and Doug Kearns

if &syntax !~# '\<ecrystal\>' || get(b:, 'current_syntax') =~# '\<ecrystal\>'
  finish
endif

if !exists('g:main_syntax')
  let g:main_syntax = 'ecrystal'
endif

if &filetype =~# '^ecrystal\.'
  let b:ecrystal_subtype = matchstr(&filetype,'^ecrystal\.\zs\w\+')
endif

if get(b:, 'ecrystal_subtype', '') !~# '^\%(ecrystal\)\=$' && &syntax =~# '^ecrystal\>'
  exe 'runtime! syntax/' . b:ecrystal_subtype . '.vim'
endif
unlet! b:current_syntax
syn include @crystalTop syntax/crystal.vim

syn cluster ecrystalRegions contains=ecrystalOneLiner,ecrystalBlock,ecrystalExpression,ecrystalComment

syn region  ecrystalOneLiner   matchgroup=ecrystalDelimiter start="^%%\@!"    end="$"             contains=@crystalTop containedin=ALLBUT,@ecrystalRegions keepend oneline
syn region  ecrystalBlock      matchgroup=ecrystalDelimiter start="<%%\@!-\=" end="[=-]\=%\@<!%>" contains=@crystalTop containedin=ALLBUT,@ecrystalRegions keepend
syn region  ecrystalExpression matchgroup=ecrystalDelimiter start="<%=\{1,4}" end="[=-]\=%\@<!%>" contains=@crystalTop containedin=ALLBUT,@ecrystalRegions keepend
syn region  ecrystalComment    matchgroup=ecrystalDelimiter start="<%-\=#"    end="[=-]\=%\@<!%>" contains=crystalTodo,@Spell containedin=ALLBUT,@ecrystalRegions keepend

" Define the default highlighting.

hi def link ecrystalDelimiter PreProc
hi def link ecrystalComment   Comment

let b:current_syntax = matchstr(&syntax, '^.*\<ecrystal\>')

if g:main_syntax ==# 'ecrystal'
  unlet g:main_syntax
endif

" vim: nowrap sw=2 sts=2 ts=8:
