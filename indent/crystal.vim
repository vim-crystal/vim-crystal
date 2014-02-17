if exists("b:did_indent")
  finish
endif

" Read the Ruby indentation rule
runtime! indent/ruby.vim

" vim:set sw=2 sts=2 ts=8 et:
