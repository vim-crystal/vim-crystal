" Variables {{{1
" =========

" Regex of syntax group names that are strings or characters.
const crystal#indent#syng_string =
      \ '\<crystal\%(String\|Interpolation\|NoInterpolation\|StringEscape\|CharLiteral\|ASCIICode\)\>'

" Regex of syntax group names that are strings, characters, symbols,
" regexps, or comments.
const crystal#indent#syng_strcom =
      \ crystal#indent#syng_string.'\|' .
      \ '\<crystal\%(Regexp\|RegexpEscape\|Symbol\|Comment\)\>'

" Expression used to check whether we should skip a match with searchpair().
const crystal#indent#skip_expr =
      \ 'synIDattr(synID(line("."), col("."), 1), "name") =~# "'.crystal#indent#syng_strcom.'"'

" Regex for the start of a line:
" start of line + whitespace + optional opening macro delimiter
const crystal#indent#sol = '^\s*\zs\%(\\\={%\s*\)\='

" Regex for the end of a line:
" whitespace + optional closing macro delimiter + whitespace +
" optional comment + end of line
const crystal#indent#eol = '\s*\%(%}\)\=\ze\s*\%(#.*\)\=$'

" Regex that defines the start-match for the 'end' keyword.
" NOTE: This *should* properly match the 'do' only at the end of the
" line
const crystal#indent#end_start_regex =
      \ crystal#indent#sol .
      \ '\%(' .
      \ '\%(\<\%(private\|protected\)\s\+\)\=' .
      \ '\%(\<\%(abstract\s\+\)\=\%(class\|struct\)\>\|\<\%(def\|module\|macro\|lib\|enum\)\>\)' .
      \ '\|' .
      \ '\<\%(if\|unless\|while\|until\|case\|begin\|for\|union\)\>' .
      \ '\)' .
      \ '\|' .
      \ '.\{-}\zs\<do\s*\%(|.*|\)\='.crystal#indent#eol

" Regex that defines the middle-match for the 'end' keyword.
const crystal#indent#end_middle_regex =
      \ crystal#indent#sol .
      \ '\<\%(else\|elsif\|rescue\|ensure\|when\)\>'

" Regex that defines the end-match for the 'end' keyword.
const crystal#indent#end_end_regex =
      \ crystal#indent#sol .
      \ '\<end\>'

" Regex used for words that add a level of indent.
const crystal#indent#crystal_indent_keywords =
      \ crystal#indent#end_start_regex .
      \ '\|' .
      \ crystal#indent#end_middle_regex

" Regex used for words that remove a level of indent.
const crystal#indent#crystal_deindent_keywords =
      \ crystal#indent#end_middle_regex .
      \ '\|' .
      \ crystal#indent#end_end_regex

" Regex that defines continuation lines, not including (, {, or [.
const crystal#indent#non_bracket_continuation_regex = '\%([\\.,:*/%+]\|\<and\|\<or\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)\s*\%(#.*\)\=$'

" Regex that defines continuation lines.
const crystal#indent#continuation_regex =
      \ '\%(%\@<![({[\\.,:*/%+]\|\<and\|\<or\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)\s*\%(#.*\)\=$'

" Regex that defines continuable keywords
const crystal#indent#continuable_regex =
      \ '\%(^\s*\|[=,*/%+\-|;{]\|<<\|>>\|:\s\)\s*\zs' .
      \ '\<\%(if\|for\|while\|until\|unless\):\@!\>'

" Regex that defines bracket continuations
const crystal#indent#bracket_continuation_regex = '%\@<!\%([({[]\)\s*\%(#.*\)\=$'

" Regex that defines end of bracket continuation followed by another continuation
const crystal#indent#bracket_switch_continuation_regex = '^\([^(]\+\zs).\+\)\+'.crystal#indent#continuation_regex

" Regex that defines the first part of a splat pattern
const crystal#indent#splat_regex = '[[,(]\s*\*\s*\%(#.*\)\=$'

" Regex that defines blocks.
"
" Note that there's a slight problem with this regex and crystal#indent#continuation_regex.
" Code like this will be matched by both:
"
"   method_call do |(a, b)|
"
" The reason is that the pipe matches a hanging "|" operator.
"
const crystal#indent#block_regex =
      \ '\%(\<do:\@!\>\|%\@<!{\)\s*\%(|\s*(*\s*\%([*@&]\=\h\w*,\=\s*\)\%(,\s*(*\s*[*@&]\=\h\w*\s*)*\s*\)*|\)\=\s*\%(%}\)\=\s*\%(#.*\)\=$'

const crystal#indent#block_continuation_regex = '^\s*[^])}\t ].*'.crystal#indent#block_regex

" Regex that describes a leading operator (only a method call's dot for now)
const crystal#indent#leading_operator_regex = '^\s*[.]'

" Auxiliary Functions {{{1
" ===================

" Check if the character at lnum:col is inside a string, comment, or is ascii.
function crystal#indent#IsInStringOrComment(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# g:crystal#indent#syng_strcom
endfunction

" Check if the character at lnum:col is inside a string or character.
function crystal#indent#IsInString(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# g:crystal#indent#syng_string
endfunction

" Check if the character at lnum:col is inside a string delimiter
function crystal#indent#IsInStringDelimiter(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') ==# 'crystalStringDelimiter'
endfunction

" Find line above 'lnum' that isn't empty, in a comment, or in a string.
function crystal#indent#PrevNonBlankNonString(lnum)
  let lnum = prevnonblank(a:lnum)

  while lnum > 0
    let line = getline(lnum)
    let start = match(line, '\S')

    if !crystal#indent#IsInStringOrComment(lnum, start + 1)
      break
    endif

    let lnum = prevnonblank(lnum - 1)
  endwhile

  return lnum
endfunction

" Find line above 'lnum' that started the continuation 'lnum' may be part of.
function crystal#indent#GetMSL(lnum)
  " Start on the line we're at and use its indent.
  let msl = a:lnum
  let msl_body = getline(msl)
  let lnum = crystal#indent#PrevNonBlankNonString(a:lnum - 1)

  while lnum > 0
    " If we have a continuation line, or we're in a string, use line as MSL.
    " Otherwise, terminate search as we have found our MSL already.
    let line = getline(lnum)

    if crystal#indent#Match(msl, g:crystal#indent#leading_operator_regex)
      " If the current line starts with a leading operator, keep its indent
      " and keep looking for an MSL.
      let msl = lnum
    elseif crystal#indent#Match(lnum, g:crystal#indent#splat_regex)
      " If the above line looks like the "*" of a splat, use the current one's
      " indentation.
      "
      " Example:
      "   Hash[*
      "     method_call do
      "       something
      "
      return msl
    elseif crystal#indent#Match(lnum, g:crystal#indent#non_bracket_continuation_regex) &&
          \ crystal#indent#Match(msl, g:crystal#indent#non_bracket_continuation_regex)
      " If the current line is a non-bracket continuation and so is the
      " previous one, keep its indent and continue looking for an MSL.
      "
      " Example:
      "   method_call one,
      "     two,
      "     three
      "
      let msl = lnum
    elseif crystal#indent#Match(lnum, g:crystal#indent#non_bracket_continuation_regex) &&
          \ (
          \ crystal#indent#Match(msl, g:crystal#indent#bracket_continuation_regex) ||
          \ crystal#indent#Match(msl, g:crystal#indent#block_continuation_regex)
          \ )
      " If the current line is a bracket continuation or a block-starter, but
      " the previous is a non-bracket one, respect the previous' indentation,
      " and stop here.
      "
      " Example:
      "   method_call one,
      "     two {
      "     three
      "
      return lnum
    elseif crystal#indent#Match(lnum, g:crystal#indent#bracket_continuation_regex) &&
          \ (
          \ crystal#indent#Match(msl, g:crystal#indent#bracket_continuation_regex) ||
          \ crystal#indent#Match(msl, g:crystal#indent#block_continuation_regex)
          \ )
      " If both lines are bracket continuations (the current may also be a
      " block-starter), use the current one's and stop here
      "
      " Example:
      "   method_call(
      "     other_method_call(
      "       foo
      return msl
    elseif crystal#indent#Match(lnum, g:crystal#indent#block_regex) &&
          \ !crystal#indent#Match(msl, g:crystal#indent#continuation_regex) &&
          \ !crystal#indent#Match(msl, g:crystal#indent#block_continuation_regex)
      " If the previous line is a block-starter and the current one is
      " mostly ordinary, use the current one as the MSL.
      "
      " Example:
      "   method_call do
      "     something
      "     something_else
      return msl
    else
      let col = match(line, g:crystal#indent#continuation_regex) + 1

      if (col > 0 && !crystal#indent#IsInStringOrComment(lnum, col))
            \ || crystal#indent#IsInString(lnum, strlen(line))
        let msl = lnum
      else
        break
      endif
    endif

    let msl_body = getline(msl)
    let lnum = crystal#indent#PrevNonBlankNonString(lnum - 1)
  endwhile

  return msl
endfunction

" Check if line 'lnum' has more opening brackets than closing ones.
function crystal#indent#ExtraBrackets(lnum)
  let opening = {'parentheses': [], 'braces': [], 'brackets': []}
  let closing = {'parentheses': [], 'braces': [], 'brackets': []}

  let line = getline(a:lnum)
  let pos  = match(line, '[][(){}]', 0)

  " Save any encountered opening brackets, and remove them once a matching
  " closing one has been found. If a closing bracket shows up that doesn't
  " close anything, save it for later.
  while pos != -1
    if !crystal#indent#IsInStringOrComment(a:lnum, pos + 1)
      if line[pos] ==# '('
        call add(opening.parentheses, {'type': '(', 'pos': pos})
      elseif line[pos] ==# ')'
        if empty(opening.parentheses)
          call add(closing.parentheses, {'type': ')', 'pos': pos})
        else
          let opening.parentheses = opening.parentheses[0:-2]
        endif
      elseif line[pos] ==# '{'
        call add(opening.braces, {'type': '{', 'pos': pos})
      elseif line[pos] ==# '}'
        if empty(opening.braces)
          call add(closing.braces, {'type': '}', 'pos': pos})
        else
          let opening.braces = opening.braces[0:-2]
        endif
      elseif line[pos] ==# '['
        call add(opening.brackets, {'type': '[', 'pos': pos})
      elseif line[pos] ==# ']'
        if empty(opening.brackets)
          call add(closing.brackets, {'type': ']', 'pos': pos})
        else
          let opening.brackets = opening.brackets[0:-2]
        endif
      endif
    endif

    let pos = match(line, '[][(){}]', pos + 1)
  endwhile

  " Find the rightmost brackets, since they're the ones that are important in
  " both opening and closing cases
  let rightmost_opening = {'type': '(', 'pos': -1}
  let rightmost_closing = {'type': ')', 'pos': -1}

  for opening in opening.parentheses + opening.braces + opening.brackets
    if opening.pos > rightmost_opening.pos
      let rightmost_opening = opening
    endif
  endfor

  for closing in closing.parentheses + closing.braces + closing.brackets
    if closing.pos > rightmost_closing.pos
      let rightmost_closing = closing
    endif
  endfor

  return [rightmost_opening, rightmost_closing]
endfunction

function crystal#indent#Match(lnum, regex)
  let regex = '\C'.a:regex

  let line = getline(a:lnum)
  let col  = match(line, regex) + 1

  while col && crystal#indent#IsInStringOrComment(a:lnum, col)
    let col = match(line, regex, col) + 1
  endwhile

  return col
endfunction

" Locates the containing class/module/struct/enum/lib's definition line,
" ignoring nested classes along the way.
function crystal#indent#FindContainingClass()
  let saved_position = getcurpos()

  while searchpair(
        \ g:crystal#indent#end_start_regex,
        \ g:crystal#indent#end_middle_regex,
        \ g:crystal#indent#end_end_regex,
        \ 'bWz',
        \ g:crystal#indent#skip_expr) > 0
    if expand('<cword>') =~# '\<\%(class\|module\|struct\|enum\|lib\)\>'
      let found_lnum = line('.')
      call setpos('.', saved_position)
      return found_lnum
    endif
  endwhile

  call setpos('.', saved_position)
  return 0
endfunction
