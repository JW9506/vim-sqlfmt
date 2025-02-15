function! s:get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! s:sqlfmt() abort
  call setqflist([])
  let cmd = get(g:, 'sqlfmt_program', 'sql-formatter ')
  let lines = system(cmd, iconv(s:get_visual_selection(), &encoding, 'utf-8'))
  if v:shell_error != 0
    echoerr substitute(lines, '[\r\n]', ' ', 'g')
    return
  endif
  let pos = getcurpos()[1]
  normal! gv"_d
  call append(pos-1, split(lines, "\n"))
  call setpos('.', pos)
endfunction

xnoremap <silent> <Plug>(sqlfmt) :<c-u>call <SID>sqlfmt()<cr>
