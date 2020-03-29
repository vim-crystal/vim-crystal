" Vim syntax file
" Language: eCrystal
" Original author: Tim Pope <vimNOSPAM@tpope.org>
" Maintainer: rhysd <https://rhysd.github.io>
"
" Based on eruby syntax highlight from vim-ruby
" which was made by Tim Pope and Doug Kearns

if &syntax !~# '\<ecr\>' || get(b:, 'current_syntax') =~# '\<ecr\>'
  finish
endif

if !exists('g:main_syntax')
  let g:main_syntax = 'ecr'
endif

if &filetype =~# '^ecr\.'
  let b:ecr_subtype = matchstr(&filetype,'^ecr\.\zs\w\+')
endif

if get(b:, 'ecr_subtype', '') !~# '^\%(ecr\)\=$' && &syntax =~# '^ecr\>'
  exe 'runtime! syntax/' . b:ecr_subtype . '.vim'
endif
unlet! b:current_syntax
syn include @crystalTop syntax/crystal.vim

syn cluster ecrRegions contains=ecrOneLiner,ecrBlock,ecrExpression,ecrComment

syn region  ecrOneLiner   matchgroup=ecrDelimiter start="^%%\@!"    end="$"             contains=@crystalTop containedin=ALLBUT,@ecrRegions keepend oneline
syn region  ecrBlock      matchgroup=ecrDelimiter start="<%%\@!-\=" end="[=-]\=%\@<!%>" contains=@crystalTop containedin=ALLBUT,@ecrRegions keepend
syn region  ecrExpression matchgroup=ecrDelimiter start="<%=\{1,4}" end="[=-]\=%\@<!%>" contains=@crystalTop containedin=ALLBUT,@ecrRegions keepend
syn region  ecrComment    matchgroup=ecrDelimiter start="<%-\=#"    end="[=-]\=%\@<!%>" contains=crystalTodo,@Spell containedin=ALLBUT,@ecrRegions keepend

" Define the default highlighting.

hi def link ecrDelimiter PreProc
hi def link ecrComment   Comment

let b:current_syntax = matchstr(&syntax, '^.*\<ecr\>')

if g:main_syntax ==# 'ecr'
  unlet g:main_syntax
endif

" vim: nowrap sw=2 sts=2 ts=8:
