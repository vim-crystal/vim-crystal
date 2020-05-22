let s:cpo_save = &cpo
set cpo&vim

" Variables {{{1
" =========

" Syntax group names that are strings.
let g:crystal#indent#syng_string =
      \ '\<crystal\%(String\|Interpolation\|NoInterpolation\|StringEscape\)\>'
lockvar g:crystal#indent#syng_string

" Syntax group names that are strings/symbols/regexes or comments.
let g:crystal#indent#syng_strcom =
      \ g:crystal#indent#syng_string .
      \ '\|' .
      \ '\<crystal\%(CharLiteral\|Comment\|HeredocStart\|Regexp\|RegexpCharClass\|RegexpEscape\|Symbol\|ASCIICode\)\>'
lockvar g:crystal#indent#syng_strcom

" Syntax group names that are string/regex/symbol delimiters.
let g:crystal#indent#syng_delim =
      \ '\<crystal\%(StringDelimiter\|RegexpDelimiter\|SymbolDelimiter\|InterpolationDelim\)\>'
lockvar g:crystal#indent#syng_delim

" Syntax group that represents all of the above combined.
let g:crystal#indent#syng_strcomdelim =
      \ g:crystal#indent#syng_strcom .
      \ '\|' .
      \ g:crystal#indent#syng_delim
lockvar g:crystal#indent#syng_strcomdelim

" Regex for the start of a line
let g:crystal#indent#sol = '\%(\_^\|;\)\s*\zs'
lockvar g:crystal#indent#sol

" Regex for the end of a line
let g:crystal#indent#eol = '\ze\s*\%(#.*\)\=\%(\_$\|;\)'
lockvar g:crystal#indent#eol

" Regex that defines blocks.
let g:crystal#indent#block_regex =
      \ '\C\%(\<do\>\|%\@1<!{\@1<!{\)\s*\%(|[^|]*|\)\='.g:crystal#indent#eol
lockvar g:crystal#indent#block_regex

" Expression used to check whether we should skip a match with searchpair().
let g:crystal#indent#skip_expr =
      \ 'crystal#indent#IsInStringOrComment(line("."), col("."))'
lockvar g:crystal#indent#skip_expr

" Regex that defines a type declaration
let g:crystal#indent#type_declaration_regex =
      \ '\%(\<\%(private\|protected\)\s\+\)\=' .
      \ '\%(\<\%(getter\|setter\|property\)\>?\=\s\+\)\=' .
      \ '@\=\h\k*\s\+:\s\+\S.*'
lockvar g:crystal#indent#type_declaration_regex

" Regex for operator symbols:
" , : / + - = ~ < & ^ \
" * that is not part of a type declaration
" | that is not part of a block opening
" % that is not part of a macro delimiter
" ! that is not part of a method name
" ? that is not part of a type declaration or a method name
" > that is not part of a ->
"
" Additionally, all symbols must not be part of a global variable name,
" like $~.
let g:crystal#indent#operator_regex =
      \ '\$\@1<!' .
      \ '\%(' .
      \ '[.,:/+\-=~<&^\\]' .
      \ '\|' .
      \ '\%('.g:crystal#indent#type_declaration_regex.'\)\@<!\*' .
      \ '\|' .
      \ '\%(\%(\<do\>\|%\@1<!{\)\s*|[^|]*\)\@<!|' .
      \ '\|' .
      \ '{\@1<!%' .
      \ '\|' .
      \ '\%(\k\|]\)\@1<!\!' .
      \ '\|' .
      \ '\%('.g:crystal#indent#type_declaration_regex.'\)\@<!\%(\k\|]\)\@1<!?' .
      \ '\|' .
      \ '-\@1<!>' .
      \ '\)'
lockvar g:crystal#indent#operator_regex

" Regex that defines continuable keywords
let g:crystal#indent#continuable_regex =
      \ '\%(' .
      \ g:crystal#indent#sol .
      \ '\|' .
      \ g:crystal#indent#operator_regex.'\s*\zs' .
      \ '\)' .
      \ '\C\.\@1<!\<\%(if\||while\|until\|case\|unless\|begin\)\>'
lockvar g:crystal#indent#continuable_regex

" Regex that defines the start-match for the 'end' keyword.
let g:crystal#indent#end_start_regex =
      \ '\C' .
      \ '\%(' .
      \ g:crystal#indent#sol .
      \ '\%(' .
      \ '\%(\<\%(private\|protected\)\s\+\)\=' .
      \ '\%(\<\%(abstract\s\+\)\=\%(class\|struct\)\>\|\<\%(def\|module\|macro\|lib\|enum\)\>\)' .
      \ '\|' .
      \ '\<\%(if\|unless\|while\|until\|case\|begin\|union\)\>' .
      \ '\)' .
      \ '\|' .
      \ g:crystal#indent#continuable_regex .
      \ '\|' .
      \ g:crystal#indent#block_regex .
      \ '\)'
lockvar g:crystal#indent#end_start_regex

" Regex that defines the middle-match for the 'end' keyword.
let g:crystal#indent#end_middle_regex =
      \ g:crystal#indent#sol .
      \ '\C\<\%(else\|elsif\|when\|rescue\|ensure\)\>'
lockvar g:crystal#indent#end_middle_regex

" Regex that defines the end-match for the 'end' keyword.
let g:crystal#indent#end_end_regex =
      \ g:crystal#indent#sol.'\%(\C\<end\>\|%\@1<!}\@1<!}}\@!\)'
lockvar g:crystal#indent#end_end_regex

" Regex used for words that, at the start of a line, add a level of indent.
let g:crystal#indent#crystal_indent_keywords =
      \ g:crystal#indent#end_start_regex .
      \ '\|' .
      \ g:crystal#indent#end_middle_regex
lockvar g:crystal#indent#crystal_indent_keywords

" Regex used for words that, at the start of a line, remove a level of indent.
let g:crystal#indent#crystal_deindent_keywords =
      \ g:crystal#indent#end_middle_regex .
      \ '\|' .
      \ g:crystal#indent#end_end_regex
lockvar g:crystal#indent#crystal_deindent_keywords

" Regex that defines continuable keywords for macro control tags.
let g:crystal#indent#macro_continuable_regex =
      \ '\%(' .
      \ g:crystal#indent#sol .
      \ '\|' .
      \ g:crystal#indent#operator_regex.'\s*\zs' .
      \ '\)' .
      \ '\C\\\={%\s*\%(if\|unless\|for\|while\|until\|loop\|begin\)\>.*%}'
lockvar g:crystal#indent#macro_continuable_regex

" Regex that defines the start-match for the 'end' keyword in macro
" control tags.
let g:crystal#indent#macro_end_start_regex =
      \ '\C' .
      \ '\%(' .
      \ g:crystal#indent#sol .
      \ '\%(' .
      \ '\\\={%\s*\%(if\|unless\|for\|while\|until\|loop\|begin\)\>.*%}' .
      \ '\|' .
      \ '\\\={%.*\<do\s*%}' .
      \ '\)' .
      \ '\|' .
      \ g:crystal#indent#macro_continuable_regex .
      \ '\)'
lockvar g:crystal#indent#macro_end_start_regex

" Regex that defines the middle-match for the 'end' keyword in macro
" control tags.
let g:crystal#indent#macro_end_middle_regex =
      \ g:crystal#indent#sol.'\C\\\={%\s*\%(else\|elsif\)\>.*%}'
lockvar g:crystal#indent#macro_end_middle_regex

" Regex that defines the end-match for the 'end' keyword in macro
" control tags.
let g:crystal#indent#macro_end_end_regex =
      \ g:crystal#indent#sol.'\C\\\={%\s*end\s*%}'
lockvar g:crystal#indent#macro_end_end_regex

" Regex used for words that, at the start of a line, add a level of
" indent after macro control tags.
let g:crystal#indent#crystal_macro_indent_keywords =
      \ g:crystal#indent#macro_end_start_regex .
      \ '\|' .
      \ g:crystal#indent#macro_end_middle_regex
lockvar g:crystal#indent#crystal_macro_indent_keywords

" Regex used for words that, at the start of a line, remove a level of
" indent after macro control tags.
let g:crystal#indent#crystal_macro_deindent_keywords =
      \ g:crystal#indent#macro_end_middle_regex .
      \ '\|' .
      \ g:crystal#indent#macro_end_end_regex
lockvar g:crystal#indent#crystal_macro_deindent_keywords

" Regex that defines bracket continuations
let g:crystal#indent#bracket_continuation_regex =
      \ '%\@1<!\%([({[]\)'.g:crystal#indent#eol
lockvar g:crystal#indent#bracket_continuation_regex

" Regex that defines continuation lines, not including (, {, or [.
let g:crystal#indent#non_bracket_continuation_regex =
      \ '\%(' .
      \ g:crystal#indent#operator_regex .
      \ '\|' .
      \ '\<\%(if\|unless\)\>' .
      \ '\)' .
      \ g:crystal#indent#eol
lockvar g:crystal#indent#non_bracket_continuation_regex

" Regex that defines continuation lines.
let g:crystal#indent#continuation_regex =
      \ g:crystal#indent#bracket_continuation_regex .
      \ '\|' .
      \ g:crystal#indent#non_bracket_continuation_regex
lockvar g:crystal#indent#continuation_regex

" Regex that defines dot continuations
let g:crystal#indent#dot_continuation_regex = '\.'.g:crystal#indent#eol
lockvar g:crystal#indent#dot_continuation_regex

" Regex that defines end of bracket continuation followed by another continuation
let g:crystal#indent#bracket_switch_continuation_regex =
      \ '^\([^(]\+\zs).\+\)\+\%('.g:crystal#indent#continuation_regex.'\)'
lockvar g:crystal#indent#bracket_switch_continuation_regex

" Regex that defines the first part of a splat pattern
let g:crystal#indent#splat_regex = '[[,(]\s*\*'.g:crystal#indent#eol
lockvar g:crystal#indent#splat_regex

let g:crystal#indent#block_continuation_regex =
      \ '^\s*[^])}\t ].*'.g:crystal#indent#block_regex
lockvar g:crystal#indent#block_continuation_regex

" Regex that describes a leading operator (only a method call's dot for now)
let g:crystal#indent#leading_operator_regex = '^\s*\.'
lockvar g:crystal#indent#leading_operator_regex

" Indent callbacks for the current line
let g:crystal#indent#curr_line_callbacks = [
      \ 'crystal#indent#ClosingBracketOnEmptyLine',
      \ 'crystal#indent#DeindentingMacroTag',
      \ 'crystal#indent#DeindentingKeyword',
      \ 'crystal#indent#MultilineString',
      \ 'crystal#indent#ClosingHeredocDelimiter',
      \ 'crystal#indent#LeadingOperator'
      \ ]
lockvar g:crystal#indent#curr_line_callbacks

" Indent callbacks for the previous line
let g:crystal#indent#prev_line_callbacks = [
      \ 'crystal#indent#StartOfFile',
      \ 'crystal#indent#ContinuedLine',
      \ 'crystal#indent#AfterBlockOpening',
      \ 'crystal#indent#AfterHangingSplat',
      \ 'crystal#indent#AfterUnbalancedBracket',
      \ 'crystal#indent#AfterLeadingOperator',
      \ 'crystal#indent#AfterEndMacroTag',
      \ 'crystal#indent#AfterEndKeyword',
      \ 'crystal#indent#AfterIndentMacroTag',
      \ 'crystal#indent#AfterIndentKeyword'
      \ ]
lockvar g:crystal#indent#prev_line_callbacks

" Indent callbacks for the MSL
let g:crystal#indent#msl_callbacks = [
      \ 'crystal#indent#PreviousNotMSL',
      \ 'crystal#indent#IndentingKeywordInMSL',
      \ 'crystal#indent#ContinuedHangingOperator'
      \ ]
lockvar g:crystal#indent#msl_callbacks

" Indenting Logic Callbacks {{{1
" =========================

function! crystal#indent#ClosingBracketOnEmptyLine(cline_info) abort
  let info = a:cline_info

  " If we got a closing bracket on an empty line, find its match and indent
  " according to it.  For parentheses we indent to its column - 1, for the
  " others we indent to the containing line's MSL's level.  Return -1 if fail.
  let col = matchend(info.cline, '^\s*[]})]')

  if col > 0 && !crystal#indent#IsInStringOrComment(info.clnum, col)
    call cursor(0, col)
    let closing_bracket = info.cline[col - 1]
    let bracket_pair = strpart('(){}[]', stridx(')}]', closing_bracket) * 2, 2)

    if searchpair(
          \ escape(bracket_pair[0], '\['), '',
          \ bracket_pair[1], 'bW',
          \ g:crystal#indent#skip_expr)
      if closing_bracket == ')' && col('.') != col('$') - 1
        let ind = virtcol('.') - 1
      elseif g:crystal_indent_block_style ==# 'do'
        let ind = indent(line('.'))
      else " g:crystal_indent_block_style ==# 'expression'
        let ind = indent(crystal#indent#GetMSL(line('.')))
      endif
    endif

    return ind
  endif

  return -1
endfunction

function! crystal#indent#DeindentingKeyword(cline_info) abort
  let info = a:cline_info

  " If we have a deindenting keyword, find its match and indent to its level.
  let col = crystal#indent#Match(info.clnum, g:crystal#indent#crystal_deindent_keywords)

  if col
    call cursor(0, col)

    if searchpair(
          \ g:crystal#indent#end_start_regex,
          \ g:crystal#indent#end_middle_regex,
          \ g:crystal#indent#end_end_regex,
          \ 'bW',
          \ g:crystal#indent#skip_expr)
      let lnum = line('.')

      " If the nearest starting keyword is on the same line as this
      " keyword, do nothing.
      "
      " This is to handle cases like `class Error < Exception; end`.
      if lnum == info.clnum
        return indent(lnum)
      endif

      " Count the number of both opening and closing macro control tags
      " between this line and the starting line: if the number of
      " opening tags is greater than the number of closing tags, then we
      " must be inside of a macro block, so indent accordingly.
      let line_numbers = range(lnum + 1, info.clnum - 1)

      let openers = map(
            \ copy(line_numbers),
            \ 'crystal#indent#Match(v:val, g:crystal#indent#macro_end_start_regex) > 0'
            \ )

      let closers = map(
            \ copy(line_numbers),
            \ 'crystal#indent#Match(v:val, g:crystal#indent#macro_end_end_regex) > 0'
            \ )

      let diff = count(openers, 1) - count(closers, 1)

      if diff > 0
        return indent(lnum) + info.sw * (diff + 1)
      elseif diff < 0
        return indent(lnum) + info.sw * (diff - 1)
      endif

      " If none of the special cases apply, proceed normally.
      let msl  = crystal#indent#GetMSL(lnum)
      let line = getline(lnum)

      if crystal#indent#IsAssignment(line, col('.')) &&
            \ strpart(line, col('.') - 1, 2) !~# 'do'
        " assignment to case/begin/etc, on the same line
        if g:crystal_indent_assignment_style ==# 'hanging'
          " hanging indent
          let ind = virtcol('.') - 1
        else
          " align with variable
          let ind = indent(lnum)
        endif
      elseif g:crystal_indent_block_style ==# 'do'
        " align to line of the "do", not to the MSL
        let ind = indent(lnum)
      elseif getline(msl) =~ '='.g:crystal#indent#eol
        " in the case of assignment to the MSL, align to the starting line,
        " not to the MSL
        let ind = indent(lnum)
      else
        " align to the MSL
        let ind = indent(msl)
      endif
    endif

    return ind
  endif

  return -1
endfunction

function! crystal#indent#DeindentingMacroTag(cline_info) abort
  let info = a:cline_info

  " If we have a deindenting keyword, find its match and indent to its level.
  if crystal#indent#Match(info.clnum, g:crystal#indent#crystal_macro_deindent_keywords)
    call cursor(0, 1)

    if searchpair(
          \ g:crystal#indent#macro_end_start_regex,
          \ g:crystal#indent#macro_end_middle_regex,
          \ g:crystal#indent#macro_end_end_regex,
          \ 'bW',
          \ g:crystal#indent#skip_expr)
      if g:crystal_indent_assignment_style ==# 'hanging' &&
            \ crystal#indent#IsAssignment(getline('.'), col('.'))
        return virtcol('.') - 1
      else
        return indent(line('.'))
      endif
    endif
  endif

  return -1
endfunction

function! crystal#indent#MultilineString(cline_info) abort
  let info = a:cline_info

  " If we are in a multi-line string, don't do anything to it.
  if crystal#indent#IsInString(info.clnum, matchend(info.cline, '^\s*') + 1)
    return indent(info.clnum)
  endif

  return -1
endfunction

function! crystal#indent#ClosingHeredocDelimiter(cline_info) abort
  let info = a:cline_info

  " If we are at the closing delimiter of a "<<" heredoc-style string, set the
  " indent to 0.
  if info.cline =~ '^\k\+\s*$'
        \ && crystal#indent#IsInStringDelimiter(info.clnum, 1)
        \ && search('\V<<'.info.cline, 'nbW') > 0
    return 0
  endif

  return -1
endfunction

function! crystal#indent#LeadingOperator(cline_info) abort
  " If the current line starts with a leading operator, add a level of indent.
  if crystal#indent#Match(a:cline_info.clnum, g:crystal#indent#leading_operator_regex)
    return indent(crystal#indent#GetMSL(a:cline_info.clnum)) + a:cline_info.sw
  endif

  return -1
endfunction

function! crystal#indent#EmptyInsideString(pline_info) abort
  " If the line is empty and inside a string (the previous line is a string,
  " too), use the previous line's indent
  let info = a:pline_info

  let plnum = prevnonblank(info.clnum - 1)
  let pline = getline(plnum)

  if info.cline =~ '^\s*$'
        \ && crystal#indent#IsInStringOrComment(plnum, 1)
        \ && crystal#indent#IsInStringOrComment(plnum, strlen(pline))
    return indent(plnum)
  endif

  return -1
endfunction

function! crystal#indent#StartOfFile(pline_info) abort
  " At the start of the file use zero indent.
  if a:pline_info.plnum == 0
    return 0
  endif

  return -1
endfunction

" Example:
"
"   if foo || bar ||
"       baz || bing
"     puts "foo"
"   end
"
function! crystal#indent#ContinuedLine(pline_info) abort
  let info = a:pline_info

  let col = crystal#indent#Match(info.plnum, g:crystal#indent#crystal_indent_keywords)

  if crystal#indent#Match(info.plnum, g:crystal#indent#continuable_regex) &&
        \ crystal#indent#Match(info.plnum, g:crystal#indent#continuation_regex)
    if col && crystal#indent#IsAssignment(info.pline, col)
      if g:crystal_indent_assignment_style ==# 'hanging'
        " hanging indent
        let ind = col - 1
      else
        " align with variable
        let ind = indent(info.plnum)
      endif
    else
      let ind = indent(crystal#indent#GetMSL(info.plnum))
    endif

    return ind + info.sw * 2
  endif

  return -1
endfunction

function! crystal#indent#AfterBlockOpening(pline_info) abort
  let info = a:pline_info

  " If the previous line ended with a block opening, add a level of indent.
  if crystal#indent#Match(info.plnum, g:crystal#indent#block_regex)
    if g:crystal_indent_block_style ==# 'do'
      " don't align to the msl, align to the "do"
      let ind = indent(info.plnum) + info.sw
    else
      let plnum_msl = crystal#indent#GetMSL(info.plnum)

      if getline(plnum_msl) =~ '='.g:crystal#indent#eol
        " in the case of assignment to the msl, align to the starting line,
        " not to the msl
        let ind = indent(info.plnum) + info.sw
      else
        let ind = indent(plnum_msl) + info.sw
      endif
    endif

    return ind
  endif

  return -1
endfunction

function! crystal#indent#AfterLeadingOperator(pline_info) abort
  " If the previous line started with a leading operator, use its MSL's level
  " of indent
  if crystal#indent#Match(a:pline_info.plnum, g:crystal#indent#leading_operator_regex)
    return indent(crystal#indent#GetMSL(a:pline_info.plnum))
  endif

  return -1
endfunction

function! crystal#indent#AfterHangingSplat(pline_info) abort
  let info = a:pline_info

  " If the previous line ended with the "*" of a splat, add a level of indent
  if info.pline =~ g:crystal#indent#splat_regex
    return indent(info.plnum) + info.sw
  endif

  return -1
endfunction

function! crystal#indent#AfterUnbalancedBracket(pline_info) abort
  let info = a:pline_info

  " If the previous line contained unclosed opening brackets and we are still
  " in them, find the rightmost one and add indent depending on the bracket
  " type.
  "
  " If it contained hanging closing brackets, find the rightmost one, find its
  " match and indent according to that.
  "
  " NOTE: We are *not* checking for closing curly braces here, since
  " that would break indentation of code after brace-delimited blocks,
  " like this one:
  "
  " {1, 2, 3}.each { |i|
  "   puts i
  " }
  if info.pline =~ '[[({]' || info.pline =~ '[])]'.g:crystal#indent#eol
    let [opening, closing] = crystal#indent#ExtraBrackets(info.plnum)

    if opening.pos != -1
      if opening.type == '(' && searchpair('(', '', ')', 'bW', g:crystal#indent#skip_expr)
        if col('.') + 1 == col('$')
          return indent(info.plnum) + info.sw
        else
          return virtcol('.')
        endif
      else
        let nonspace = matchend(info.pline, '\S', opening.pos + 1) - 1
        return nonspace > 0 ? nonspace : indent(info.plnum) + info.sw
      endif
    elseif closing.pos != -1
      call cursor(info.plnum, closing.pos + 1)
      normal! %

      if crystal#indent#Match(line('.'), g:crystal#indent#crystal_indent_keywords)
        return indent('.') + info.sw
      else
        return indent(crystal#indent#GetMSL(line('.')))
      endif
    else
      call cursor(info.clnum, info.col)
    end
  endif

  return -1
endfunction

function! crystal#indent#AfterEndKeyword(pline_info) abort
  let info = a:pline_info

  " If the previous line ended with an "end", match that "end"s beginning's
  " indent.
  let col = crystal#indent#Match(info.plnum, g:crystal#indent#end_end_regex)

  if col
    call cursor(info.plnum, col)

    if g:crystal_indent_assignment_style ==# 'hanging'
      let lnum = searchpair(
            \ g:crystal#indent#end_start_regex,
            \ '',
            \ g:crystal#indent#end_end_regex,
            \ 'bW',
            \ g:crystal#indent#skip_expr)
    else
      let lnum = searchpair(
            \ g:crystal#indent#end_start_regex,
            \ g:crystal#indent#end_middle_regex,
            \ g:crystal#indent#end_end_regex,
            \ 'bW',
            \ g:crystal#indent#skip_expr)
    endif

    return indent(crystal#indent#GetMSL(lnum))
  end

  return -1
endfunction

function! crystal#indent#AfterEndMacroTag(pline_info) abort
  let info = a:pline_info

  " If the previous line ended with an "end" macro tag, match the indent
  " of that tag's corresponding opening tag.
  let col = crystal#indent#Match(info.plnum, g:crystal#indent#macro_end_end_regex)

  if col
    call cursor(info.plnum, col)

    if g:crystal_indent_assignment_style ==# 'hanging'
      let lnum = searchpair(
            \ g:crystal#indent#macro_end_start_regex,
            \ '',
            \ g:crystal#indent#macro_end_end_regex,
            \ 'bW',
            \ g:crystal#indent#skip_expr)
    else
      let lnum = searchpair(
            \ g:crystal#indent#macro_end_start_regex,
            \ g:crystal#indent#macro_end_middle_regex,
            \ g:crystal#indent#macro_end_end_regex,
            \ 'bW',
            \ g:crystal#indent#skip_expr)
    endif

    return indent(lnum)
  end

  return -1
endfunction

function! crystal#indent#AfterIndentKeyword(pline_info) abort
  let info = a:pline_info

  let col = crystal#indent#Match(info.plnum, g:crystal#indent#crystal_indent_keywords)

  if col
    call cursor(info.plnum, col)
    let ind = virtcol('.') - 1 + info.sw

    if crystal#indent#Match(info.plnum, g:crystal#indent#end_end_regex)
      let ind = indent('.')
    elseif crystal#indent#IsAssignment(info.pline, col)
      if g:crystal_indent_assignment_style ==# 'hanging'
        " hanging indent
        let ind = col + info.sw - 1
      else
        " align with variable
        let ind = indent(info.plnum) + info.sw
      endif
    endif

    return ind
  endif

  return -1
endfunction

function! crystal#indent#AfterIndentMacroTag(pline_info) abort
  let info = a:pline_info

  let col = crystal#indent#Match(info.plnum, g:crystal#indent#crystal_macro_indent_keywords)

  if col
    call cursor(info.plnum, col)
    let ind = virtcol('.') - 1 + info.sw

    if crystal#indent#Match(info.plnum, g:crystal#indent#macro_end_end_regex)
      let ind = indent('.')
    elseif crystal#indent#IsAssignment(info.pline, col)
      if g:crystal_indent_assignment_style ==# 'hanging'
        " hanging indent
        let ind = col + info.sw - 1
      else
        " align with variable
        let ind = indent(info.plnum) + info.sw
      endif
    endif

    return ind
  endif

  return -1
endfunction

function! crystal#indent#PreviousNotMSL(msl_info) abort
  let info = a:msl_info

  " If the previous line wasn't a MSL
  if info.plnum != info.plnum_msl
    " If previous line ends bracket and begins non-bracket continuation decrease indent by 1.
    if crystal#indent#Match(info.plnum, g:crystal#indent#bracket_switch_continuation_regex)
      return indent(info.plnum) - 1
      " If previous line is a continuation return its indent.
    elseif crystal#indent#Match(info.plnum, g:crystal#indent#non_bracket_continuation_regex) ||
          \ crystal#indent#IsInString(info.plnum, strlen(line))
      return indent(info.plnum)
    endif
  endif

  return -1
endfunction

function! crystal#indent#IndentingKeywordInMSL(msl_info) abort
  let info = a:msl_info

  " If the MSL line had an indenting keyword in it, add a level of indent.
  let col = crystal#indent#Match(info.plnum_msl, g:crystal#indent#crystal_indent_keywords)

  if col
    let ind = indent(info.plnum_msl) + info.sw

    if crystal#indent#Match(info.plnum_msl, g:crystal#indent#end_end_regex)
      let ind = ind - info.sw
    elseif crystal#indent#IsAssignment(getline(info.plnum_msl), col)
      if g:crystal_indent_assignment_style ==# 'hanging'
        " hanging indent
        let ind = col + info.sw - 1
      else
        " align with variable
        let ind = indent(info.plnum_msl) + info.sw
      endif
    endif

    return ind
  endif

  return -1
endfunction

function! crystal#indent#ContinuedHangingOperator(msl_info) abort
  let info = a:msl_info

  " If the previous line ended with an operator but wasn't a block
  " ending or a closing bracket, indent one extra level.
  if crystal#indent#Match(info.plnum_msl, g:crystal#indent#non_bracket_continuation_regex) &&
        \ !crystal#indent#Match(info.plnum_msl, g:crystal#indent#sol.'\%([\])}]\|\<end\>\)')
    if info.plnum_msl == info.plnum
      let ind = indent(info.plnum_msl) + info.sw
    else
      let ind = indent(info.plnum_msl)
    endif

    return ind
  endif

  return -1
endfunction

" Auxiliary Functions {{{1
" ===================

" Check if the character at lnum:col is inside a string.
function! crystal#indent#IsInString(lnum, col) abort
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# g:crystal#indent#syng_string
endfunction

" Check if the character at lnum:col is inside a string delimiter.
function! crystal#indent#IsInStringDelimiter(lnum, col) abort
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# g:crystal#indent#syng_delim
endfunction

" Check if the character at lnum:col is inside a string, comment, regexp, etc.
function! crystal#indent#IsInStringOrComment(lnum, col) abort
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# g:crystal#indent#syng_strcom
endfunction

" Check if the character lnum:col is inside a string, comment, regexp,
" delimiter, etc.
function! crystal#indent#IsInStringOrCommentOrDelimiter(lnum, col) abort
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# g:crystal#indent#syng_strcomdelim
endfunction

function! crystal#indent#IsAssignment(str, pos) abort
  return strpart(a:str, 0, a:pos - 1) =~ '=\s*$'
endfunction

" Find line above 'lnum' that isn't empty or in a string.
function! crystal#indent#PrevNonBlankNonString(lnum) abort
  let lnum = prevnonblank(a:lnum)

  while lnum > 0
    let line = getline(lnum)
    let start = match(line, '\S')

    if !crystal#indent#IsInString(lnum, start + 1)
      break
    endif

    let lnum = prevnonblank(lnum - 1)
  endwhile

  return lnum
endfunction

" Find line above 'lnum' that started the continuation 'lnum' may be part of.
function! crystal#indent#GetMSL(lnum) abort
  " Start on the line we're at and use its indent.
  let msl = a:lnum
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
    elseif crystal#indent#Match(lnum, g:crystal#indent#dot_continuation_regex) &&
          \ (
          \ crystal#indent#Match(msl, g:crystal#indent#bracket_continuation_regex) ||
          \ crystal#indent#Match(msl, g:crystal#indent#block_continuation_regex)
          \ )
      " If the current line is a bracket continuation or a block-starter, but
      " the previous is a dot, keep going to see if the previous line is the
      " start of another continuation.
      "
      " Example:
      "   parent.
      "     method_call {
      "     three
      "
      let msl = lnum
    elseif crystal#indent#Match(lnum, g:crystal#indent#non_bracket_continuation_regex) &&
          \ (
          \ crystal#indent#Match(msl, g:crystal#indent#bracket_continuation_regex) ||
          \ crystal#indent#Match(msl, g:crystal#indent#block_continuation_regex)
          \ )
      " If the current line is a bracket continuation or a block-starter, but
      " the previous is a non-bracket one, keep looking for an MSL.
      "
      " Example:
      "   method_call one,
      "     two {
      "     three
      "
      "   method_call one,
      "     two,
      "     three {
      "     four
      "
      let msl = lnum
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
      if crystal#indent#Match(lnum, g:crystal#indent#continuation_regex)
        let msl = lnum
      else
        break
      endif
    endif

    let lnum = crystal#indent#PrevNonBlankNonString(lnum - 1)
  endwhile

  return msl
endfunction

" Check if line 'lnum' has more opening brackets than closing ones.
function! crystal#indent#ExtraBrackets(lnum) abort
  let opening = {'parentheses': [], 'braces': [], 'brackets': []}
  let closing = {'parentheses': [], 'braces': [], 'brackets': []}

  let line = getline(a:lnum)
  let pos  = match(line, '[][(){}]', 0)

  " Save any encountered opening brackets, and remove them once a matching
  " closing one has been found. If a closing bracket shows up that doesn't
  " close anything, save it for later.
  while pos != -1
    if !crystal#indent#IsInStringOrComment(a:lnum, pos + 1)
      if line[pos] == '('
        call add(opening.parentheses, {'type': '(', 'pos': pos})
      elseif line[pos] == ')'
        if empty(opening.parentheses)
          call add(closing.parentheses, {'type': ')', 'pos': pos})
        else
          let opening.parentheses = opening.parentheses[0:-2]
        endif
      elseif line[pos] == '{'
        call add(opening.braces, {'type': '{', 'pos': pos})
      elseif line[pos] == '}'
        if empty(opening.braces)
          call add(closing.braces, {'type': '}', 'pos': pos})
        else
          let opening.braces = opening.braces[0:-2]
        endif
      elseif line[pos] == '['
        call add(opening.brackets, {'type': '[', 'pos': pos})
      elseif line[pos] == ']'
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

function! crystal#indent#Match(lnum, regex) abort
  let line   = getline(a:lnum)
  let offset = match(line, '\C'.a:regex)
  let col    = offset + 1

  while offset > -1 && crystal#indent#IsInStringOrCommentOrDelimiter(a:lnum, col)
    let offset = match(line, '\C'.a:regex, offset + 1)
    let col = offset + 1
  endwhile

  if offset > -1
    return col
  else
    return 0
  endif
endfunction

" }}}1

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:sw=2 sts=2 ts=8 fdm=marker et:
