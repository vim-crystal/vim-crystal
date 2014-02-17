if exists("b:current_syntax")
  finish
endif

" Read the Ruby syntax
runtime! syntax/ruby.vim

let b:current_syntax = "crystal"
