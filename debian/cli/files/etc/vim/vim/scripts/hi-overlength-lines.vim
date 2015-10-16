hi LineOverflow ctermfg=white ctermbg=magenta
let w:m1=matchadd('LineOverflow', '\%>80v.\+', -1)

":if exists('w:m1') | call matchdelete(w:m1) | endif

