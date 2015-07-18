if exists("b:did_indent")
  finish
endif

" Read the Ruby indentation rule
runtime! indent/ruby.vim

let s:ruby_indent_keywords =
      \ '^\s*\zs\<\%(module\|class\|if\|for\|macro' .
      \ '\|while\|until\|else\|elsif\|case\|when\|unless\|begin\|ensure\|rescue\|lib' .
      \ '\|\%(public\|protected\|private\)\=\s*def\):\@!\>' .
      \ '\|\%([=,*/%+-]\|<<\|>>\|:\s\)\s*\zs' .
      \ '\<\%(if\|for\|while\|until\|case\|unless\|begin\):\@!\>' .
      \ '\|{%\s*\<\%(if\|for\|while\|until\|lib\|case\|unless\|begin\|else\|elsif\|when\)'

let s:ruby_deindent_keywords =
      \ '^\s*\zs\<\%(ensure\|else\|rescue\|elsif\|when\|end\):\@!\>' .
      \ '\|{%\s*\<\%(ensure\|else\|rescue\|elsif\|when\|end\)\>'

let s:end_end_regex = '\%(^\|[^.:@$]\)\@<=\<end:\@!\>\|{%\s*\<\%(end\)\>'

let s:end_start_regex =
      \ '{%\s*\<\%(if\|for\|while\|until\|else\|unless\|begin\|lib\)\>\|' .
      \ '\C\%(^\s*\|[=,*/%+\-|;{]\|<<\|>>\|:\s\)\s*\zs' .
      \ '\<\%(module\|class\|macro\|if\|for\|while\|until\|case\|unless\|begin\|lib' .
      \ '\|\%(public\|protected\|private\)\=\s*def\):\@!\>' .
      \ '\|\%(^\|[^.:@$]\)\@<=\<do:\@!\>'

let s:end_middle_regex =
      \ '{%\s*\<\%(ensure\|else\|when\|elsif\)\>\s*%}\|' .
      \ '\<\%(ensure\|else\|\%(\%(^\|;\)\s*\)\@<=\<rescue:\@!\>\|when\|elsif\):\@!\>'

" vim:set sw=2 sts=2 ts=8 et:
