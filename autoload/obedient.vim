" obedient - Automatically obey indentation style
" Version: 0.0.0
" Copyright (C) 2015 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! obedient#guess()  "{{{2
  let s = obedient#guess_style(getline(1, 100))
  if s is 0
    return
  endif
  let &l:expandtab = s.expandtab
  let &l:shiftwidth = s.shiftwidth
  let &l:softtabstop = s.softtabstop
endfunction








" Misc.  "{{{1
function! obedient#guess_style(lines)  "{{{2
  let spaces = copy(a:lines)
  call map(spaces, 'substitute(v:val, "^\\s*\\zs.*", "", "")')
  call filter(spaces, 'v:val != ""')
  if len(spaces) == 0
    return 0
  endif

  let tabs = len(filter(copy(spaces), 'v:val =~ "^\\t"'))
  let whites = map(filter(copy(spaces), 'v:val !~ "^\\t"'), 'len(v:val)')
  let ws2s = len(filter(copy(whites), 'v:val % 2 == 0 && v:val % 4 != 0 && v:val % 8 != 0'))
  let ws4s = len(filter(copy(whites), 'v:val % 4 == 0 && v:val % 8 != 0'))
  let ws8s = len(filter(copy(whites), 'v:val % 8 == 0'))

  if len(whites) <= tabs
    return {
    \   'expandtab': 0,
    \   'shiftwidth': 0,
    \   'softtabstop': 0,
    \ }
  endif

  if ws2s < ws8s && ws4s < ws8s
    let unit = 8
  elseif ws2s < ws4s && ws8s <= ws4s
    let unit = 4
  elseif ws4s <= ws2s && ws8s <= ws2s
    let unit = 2
  else
    echoerr printf('Failed to guess indentation style(%s/%s/%s/%s)',
    \              ws2s, ws4s, ws8s, tabs)
    return 0
  endif

  return {
  \   'expandtab': 1,
  \   'shiftwidth': unit,
  \   'softtabstop': unit,
  \ }
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
