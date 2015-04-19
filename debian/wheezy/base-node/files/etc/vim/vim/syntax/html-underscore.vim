if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'html'
endif

" Source the html syntax file
ru! syntax/html.vim
unlet b:current_syntax

syn include @javascriptTop syntax/javascript.vim

syn region  templateScript start=+<script type="text/x-underscore-template" [^>]*>+ keepend end=+</script>+ contains=underscoreVariable,htmlTag,htmlEndTag,templateScriptString,htmlTagN,htmlValue,htmlArg
syn region  templateScriptString start=+"+ end=+"+ contained contains=underscoreVariable
syn region  templateScriptString start=+'+ end=+'+ contained contains=underscoreVariable

syn keyword templateHtmlAttribute contained id class name value title abbr tabindex cellspacing cellpadding

"" Variables
syn region underscoreNested start="{{" end="}}" transparent display contained contains=underscoreNested,@javascriptTop
syn region underscoreVariable matchgroup=underscoreDelim start=#{{# end=#}}# contained contains=underscoreNested,@javascriptTop


" Default highlighting links
if version >= 508 || !exists("did_html_underscore_syn_inits")
  if version < 508
    let did_html_underscore_syn_inits = 1
    com -nargs=+ HiLink hi link <args>
  else
    com -nargs=+ HiLink hi def link <args>
  endif
  HiLink underscoreDelim Preproc
  HiLink templateScriptString String

  delc HiLink
endif


