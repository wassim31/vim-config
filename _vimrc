" vimrc for Austin Ziegler <halostatue@gmail.com>
"
" The options set in this file are known to work with Vim 7.3 or later.
" Earlier versions may need some changes.
"
" Cribbed in part from Steve Losh and other sources over the years.

" Use Vim settings, rather then Vi settings (much better!).  This must be
" first, because it changes other options as a side effect.
set nocompatible

setlocal verbose=0 " Turn off verbose mode for this file.

" Get the value of $PATH from a login shell if MacVim.app was started from the
" Finder.
if has("gui_macvim") && has("gui_running")
  " ps -xc: just the command, not the command-line; including non-terminal processes
  " grep -wsc: suppress errors; word boundary; count of matches.
  if system("ps -xc | grep -wsc Vim") > 0
    " If your shell is not on this list, it may be just because we have not
    " tested it.  Try adding it to the list and see if it works. If so, please
    " post a note to the vim-mac list!
    if $SHELL =~ '/\(sh\|csh\|bash\|tcsh\|zsh\)$'
      let s:path = system("echo echo VIMPATH'${PATH}' | $SHELL -l")
      let $PATH = matchstr(s:path, 'VIMPATH\zs.\{-}\ze\n')
    endif
  endif

  " MacVIM shift+arrow-keys behavior (required in .vimrc)
  " let g:macvim_hig_shift_movement=1
endif

" vimrc.defaults: default values for vim settings.
" ------------------------------------------------------------------------
" Force the encoding to UTF-8 by default.
set encoding=utf-8

" Backspace over everything in insert mode
set backspace=indent,eol,start

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

set ruler " Show the cursor position all the time
set showcmd " Display incomplete commands
set incsearch " Perform searches incrementally.
set ignorecase " Ignore case…
set smartcase " Unless there's a capital letter

set autoread " Automatically reload changed files.
set autowrite " Automatically write changed buffers to disk.
set modelines=5 " vim default

set norelativenumber

set lazyredraw
set matchtime=3
set showbreak=↪
" set splitbelow splitright

set history=500 " Keep 50 lines of command line history

set foldlevelstart=0

" Make a backup of a file while we're writing it, and then delete it. This
" prevents us from having unsighly ~ files.
set nobackup writebackup
" set backupdir=~/.vim/tmp/backup// " backups
set noundofile undoreload=10000
" set undodir=~/.vim/tmp/undo//     " undo files
" set directory=~/.vim/tmp/swap//   " swap files

set fillchars=diff:⣿

" set colorcolumn=+1

if has('title')
  set title
endif

" = Keyword completion options
" == ins-completion search order: current buffer; other window buffers;
" unloaded buffers; tags; current and included files; spell checking
" dictionary; files in 'dictionary'; files in 'thesaurus'
set complete=.,w,b,u,t,i,kspell,k,s showfulltag
if has("insert_expand")
  set completeopt-=preview
endif

set virtualedit+=block

set showmatch hidden noequalalways hlsearch nostartofline nojoinspaces
set shortmess=aIo scrolloff=0 sidescrolloff=0 scrolljump=2
set mouse=ar laststatus=2 keymodel=startsel,stopsel
set tabstop=2 shiftwidth=2 softtabstop=2 shiftround expandtab smarttab
set winminheight=0 winminwidth=0 helpheight=10
set list listchars=tab:▸\ ,eol:¬,extends:›,precedes:‹,trail:•
set whichwrap=b,s,h,l,<,>,~,[,] viminfo='100,<100,s10,h,!
set linebreak showmode visualbell

" Wildmenu matching rules
set wildcharm=<C-Z> wildmenu wildmode=list:longest,list:full
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.so,*.dylib                     " compiled object files
set wildignore+=*.class                          " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.rbc                            " Rubinius byte code

" Clojure/Leiningen
" set wildignore+=classes
" set wildignore+=lib

set cursorline

if has("win32")
  set viminfo+=rA:,rB:
endif

if has("balloon_eval")
  set ballooneval
endif

set sessionoptions=blank,buffers,curdir,folds,globals,help,options,resize,slash,unix,winpos,winsize

" Use Ack instead of Grep when available
if executable("ack-grep") " Debian
  set grepprg=ack-grep\ -H\ --nogroup\ --nocolor\ --ignore-dir=tmp\ --ignore-dir=coverage
elseif executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor\ --ignore-dir=tmp\ --ignore-dir=coverage
endif

" vimrc.maps: default key mappings
" ------------------------------------------------------------------------
" Make folding open/close with the tab.
nmap <Tab> za
vmap <Tab> za
omap <Tab> za

" Move between buffers. Different on Mac vs not-Mac because option inserts
" special characters on the Mac and the Command/Super key isn't available off
" the Mac.
if has("mac") || has("macunix")
  map <D-[> :N<CR>
  map <D-]> :n<CR>
else
  map <A-[> :N<CR>
  map <A-]> :N<CR>
endif

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" Shortcut for [] {{{
onoremap id i[
onoremap ad a[
vnoremap id i[
vnoremap ad a[

" }}}

" Next and Last {{{
" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.
onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())
  if c ==# "b"
    let c = "("
  elseif c ==# "B"
    let c = "{"
  elseif c ==# "d"
    let c = "["
  endif
  exe "normal! ".a:dir.c."v".a:motion.c
endfunction

" Ack motions ------------------------------------------------------------- {{{

" Motions to Ack for things.  Works with pretty much everything, including:
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
"
" Awesome.
" Note: If the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.
nnoremap <silent> \a :set opfunc=<SID>AckMotion<CR>g@
xnoremap <silent> \a :<C-U>call <SID>AckMotion(visualmode())<CR>
function! s:CopyMotionForType(type)
  if a:type ==# 'v'
    silent execute "normal! `<" . a:type . "`>y"
  elseif a:type ==# 'char'
    silent execute "normal! `[v`]y"
  endif
endfunction
function! s:AckMotion(type) abort
  let reg_save = @@

  call s:CopyMotionForType(a:type)

  execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

  let @@ = reg_save
endfunction

" Use ,z to "focus" the current fold.
nnoremap <Leader>z zMzvzz

" Make CTRL-^ rebound to the line and *column* in the previous file
noremap <C-^> <C-^>`"

" Make "gf" rebound to last cursor position (line *and* column)
noremap gf gf`"

" Error toggles ----------------------------------------------------------- {{{
command! ErrorsToggle call <SID>ErrorsToggle()
function! s:ErrorsToggle() " {{{
  if exists("w:is_error_window")
    unlet w:is_error_window
    exec "q"
  else
    exec "Errors"
    lopen
    let w:is_error_window = 1
  endif
endfunction " }}}

command! -bang -nargs=? QFixToggle call <SID>QFixToggle(<bang>0)
function! s:QFixToggle(forced) " {{{
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction " }}}

nmap <Silent> <Leader>et :ErrorsToggle<cr>
nmap <Silent> <Leader>qt :QFixToggle<cr>

" Show more information under <C-G>
noremap <C-G> 2<C-G>

noremap <M-Down>   <C-W>j
noremap <M-Up>     <C-W>k
noremap <M-Left>   <C-W>h
noremap <M-Right>  <C-W>l
noremap <Leader>v  <C-W>v

" Synstack {{{
" Show the stack of syntax hilighting classes affecting whatever is under the
" cursor.
function! s:SynStack() "{{{
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunction "}}}

nnoremap <M-S> :call <SID>SynStack()<CR>

" Visual Mode */# from Scrooloose
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

function! MyFoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 2
  return line . '…' . repeat(" ", fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()

vnoremap * :<C-U>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-U>call <SID>VSetSearch()<CR>??<CR><c-o>

" Destroy infuriating keys ------------------------------------------------
" Fuck you, help key.
" noremap  <F1> :set invfullscreen<CR>
" inoremap <F1> <ESC>:set invfullscreen<CR>a

" Fuck you too, manual key.
" nnoremap K <nop>

" Stop it, hash key.
" inoremap # X<BS>#

" Typical command line stuff... -- emacsen-style
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-E> <End>
cnoremap <C-D> <Del>

" Clear matches with this.
noremap <Leader><Space> :noh<CR>:call clearmatches()<CR>

" Keep search matches in the middle of the window and pulse the line when moving
" to them.
nnoremap n nzzzv:call <SID>PulseCursorLine()<CR>
nnoremap N Nzzzv:call <SID>PulseCursorLine()<CR>

" Don't move on *
nnoremap * *<c-o>

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Heresy
inoremap <C-A> <ESC>i
inoremap <C-E> <ESC>A

" Fix linewise visual selection of various text objects
" nnoremap VV V
" nnoremap Vit vitVkoj
" nnoremap Vat vatV
" nnoremap Vab vabV
" nnoremap VaB vaBV

" Error navigation {{{
"             Location List     QuickFix Window
"            (e.g. Syntastic)     (e.g. Ack)
"            ----------------------------------
" Next      |     M-k               M-Down     |
" Previous  |     M-l                M-Up      |
"            ----------------------------------
nnoremap <M-K> :lnext<CR>zvzz
nnoremap <M-L> :lprevious<CR>zvzz
inoremap <M-K> <ESC>:lnext<CR>zvzz
inoremap <M-L> <ESC>:lprevious<CR>zvzz
nnoremap <M-Down> :cnext<CR>zvzz
nnoremap <M-Up> :cprevious<CR>zvzz

" Directional Keys {{{
" It's 2011.
noremap j gj
noremap k gk

" Made D behave
nnoremap D d$

" Open a Quickfix window for the last search.
nnoremap <Silent> <Leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search.
nnoremap <Silent> <Leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>
map <Leader>a :Ack! 

function! s:PulseCursorLine()
  let current_window = winnr()

  windo set nocursorline
  execute current_window . 'wincmd w'

  setlocal cursorline

  redir => old_hi
  silent execute 'hi CursorLine'
  redir END
  let old_hi = split(old_hi, '\n')[0]
  let old_hi = substitute(old_hi, 'xxx', '', '')

  hi CursorLine guibg=#2a2a2a ctermbg=233
  redraw
  sleep 20m

  hi CursorLine guibg=#333333 ctermbg=235
  redraw
  sleep 20m

  hi CursorLine guibg=#3a3a3a ctermbg=237
  redraw
  sleep 20m

  hi CursorLine guibg=#444444 ctermbg=239
  redraw
  sleep 20m

  hi CursorLine guibg=#3a3a3a ctermbg=237
  redraw
  sleep 20m

  hi CursorLine guibg=#333333 ctermbg=235
  redraw
  sleep 20m

  hi CursorLine guibg=#2a2a2a ctermbg=233
  redraw
  sleep 20m

  execute 'hi ' . old_hi

  windo set cursorline
  execute current_window . 'wincmd w'
endfunction

function! s:setupTextWrapping()
  setlocal wrap
  setlocal wrapmargin=2
  setlocal textwidth=72
  " setlocal formatoptions=tqrn1
endfunction

function! s:setupMarkdown()
  call s:setupTextWrapping()
  " map <buffer> <Leader>p :Hammer<CR>
endfunction

function! s:setupMail()
  setfiletype mail
  call s:setupTextWrapping()
endfunction

function! s:TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call <SID>TabMessage(<q-args>)

" nmap <Leader>x <Plug>ToggleAutoCloseMappings

" Ctrl-P {{{
" https://github.com/kien/ctrlp.vim
" let g:ctrlp_map = '<leader>,'
" let g:ctrlp_working_path_mode = 0
" let g:ctrlp_match_window_reversed = 1
" let g:ctrlp_split_window = 0
" let g:ctrlp_prompt_mappings = {
" \ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
" \ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
" \ 'PrtHistory(-1)':       ['<c-n>'],
" \ 'PrtHistory(1)':        ['<c-p>'],
" \ 'ToggleFocus()':        ['<c-tab>'],
" \ }

" Easymotion {{{
" https://github.com/Lokaltog/vim-easymotion
" let g:EasyMotion_do_mapping = 0
" 
" nnoremap <silent> <Leader>f      :call EasyMotionF(0, 0)<CR>
" onoremap <silent> <Leader>f      :call EasyMotionF(0, 0)<CR>
" vnoremap <silent> <Leader>f :<C-U>call EasyMotionF(1, 0)<CR>
" 
" nnoremap <silent> <Leader>F      :call EasyMotionF(0, 1)<CR>
" onoremap <silent> <Leader>F      :call EasyMotionF(0, 1)<CR>
" vnoremap <silent> <Leader>F :<C-U>call EasyMotionF(1, 1)<CR>
" 
" onoremap <silent> <Leader>t      :call EasyMotionT(0, 0)<CR>
" onoremap <silent> <Leader>T      :call EasyMotionT(0, 1)<CR>

" For keyboards that have Insert and Del keys (not Macs), make them do the
" right thing.
function! s:NormalPaste()
  if @* != ""
    normal "*gP
  endif
endfunction

function! s:SelectPaste()
  if @* != ""
    if col(".") < col("'<")
      normal "*gp
    else
      normal "*gP
    endif
  endif
endfunction

map <S-Del> "*x
map <C-Insert> "*y
map <S-Insert> :set paste<CR>:call <SID>NormalPaste()<CR>:set nopaste<CR>
imap <S-Insert> x<ESC>:set paste<CR>:call <SID>NormalPaste()<CR>:set nopaste<CR>s
cmap <S-Insert> <C-R>*
vmap <S-Insert> "-x:set paste<CR>:call <SID>SelectPaste()<CR>:set nopaste<CR>

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cmap <C-Tab> <C-C><C-Tab>
noremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W
cmap <C-S-Tab> <C-C><C-S-Tab>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Don't use Ex mode, use Q for formatting
" Formatting, TextMate-style
nnoremap Q gqip

" Easier linewise reselection
nnoremap <Leader>V V`]

" Preview Files
" nnoremap <Leader>p :w<cr>:Hammer<cr>

" Align text
nnoremap <Leader>Al :left<cr>
nnoremap <Leader>Ac :center<cr>
nnoremap <Leader>Ar :right<cr>
vnoremap <Leader>Al :left<cr>
vnoremap <Leader>Ac :center<cr>
vnoremap <Leader>Ar :right<cr>

" Prepare to write email.
map <Leader>mail :call <SID>setupMail()<CR>

" Less chording
nnoremap ; :

" Faster ESC
" inoremap jk <ESC>

" Cmdheight switching
nnoremap <Leader>1 :set cmdheight=1<cr>
nnoremap <Leader>2 :set cmdheight=2<cr>

" Source
vnoremap <Leader>S y:execute @@<cr>
nnoremap <Leader>S ^vg_y:execute @@<cr>

function! s:WhenPUMVisible(ifVisible, ifNotVisible)
  if pumvisible()
    return a:ifVisible
  else
    return a:ifNotVisible
  endif
endfunction

" If a popupmenu is visible (pumvisible), change the behaviour of various
" keys to do something meaningful with the menu.
inoremap <expr> <ESC>      <SID>WhenPUMVisible("\<C-E>", "\<ESC>")
" inoremap <expr> <CR>       <SID>WhenPUMVisible("\<C-Y>", "\<CR>")
inoremap <expr> <Down>     <SID>WhenPUMVisible("\<C-N>", "\<Down>")
inoremap <expr> <Up>       <SID>WhenPUMVisible("\<C-P>", "\<Up>")
inoremap <expr> <PageDown> <SID>WhenPUMVisible("\<PageDown>\<C-P>\<C-N>", "\<PageDown>")
inoremap <expr> <PageUp>   <SID>WhenPUMVisible("\<PageUp>\<C-P>\<C-N>", "\<PageUp>")

" For the BufferList plug-in.
noremap <Silent> <F3> :call BufferList()<CR>
inoremap <Silent> <F3> <C-O>:call BufferList()<CR>

nnoremap <F5> :GundoToggle<CR>
let g:gundo_debug = 1
let g:gundo_preview_bottom = 1

" https://github.com/othree/html5.vim
" let g:event_handler_attributes_complete = 0
" let g:rdfa_attributes_complete = 0
" let g:microdata_attributes_complete = 0
" let g:atia_attributes_complete = 0

" Linediff {{{
" https://github.com/AndrewRadev/linediff.vim
" vnoremap <leader>l :Linediff<cr>
" nnoremap <leader>L :LinediffReset<cr>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vmap P p :call setreg('"', getreg('0')) <CR>

if has("mac") || has("macunix")
  command! -bar -nargs=1 OpenURL :call <SID>OpenURL(<q-args>)<CR>
  function! s:OpenURL(...)
    if a:0 == 0
      let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
    elseif a:0 == 1
      let s:uri = a:1
    else
      echo "Too many arguments."
      return
    endif
    echo s:uri
    if s:uri != ""
      execute "!open \"" . s:uri . "\""
    else
      echo "No URI found in line."
    endif
  endfunction
  map <Leader>w :call <SID>OpenURL()<CR>
endif

" Indent Guides {{{
let g:indentguides_state = 0
function! s:IndentGuides()
  if g:indentguides_state
    let g:indentguides_state = 0
    2match None
  else
    let g:indentguides_state = 1
    execute '2match IndentGuides /\%(\_^\s*\)\@<=\%(\%'.(0*&sw+1).'v\|\%'.(1*&sw+1).'v\|\%'.(2*&sw+1).'v\|\%'.(3*&sw+1).'v\|\%'.(4*&sw+1).'v\|\%'.(5*&sw+1).'v\|\%'.(6*&sw+1).'v\|\%'.(7*&sw+1).'v\)\s/'
  endif
endfunction
nnoremap <Leader>i :call <SID>IndentGuides()<CR>

" Insert Mode Completion {{{
inoremap <C-L> <C-X><C-L>
inoremap <C-F> <C-X><C-F>

" }}}
" Block Colors {{{

let g:blockcolor_state = 0
function! s:BlockColor() " {{{
  if g:blockcolor_state
    let g:blockcolor_state = 0
    call matchdelete(77880)
    call matchdelete(77881)
    call matchdelete(77882)
    call matchdelete(77883)
  else
    let g:blockcolor_state = 1
    call matchadd("BlockColor1", '^ \{4}.*', 1, 77880)
    call matchadd("BlockColor2", '^ \{8}.*', 2, 77881)
    call matchadd("BlockColor3", '^ \{12}.*', 3, 77882)
    call matchadd("BlockColor4", '^ \{16}.*', 4, 77883)
  endif
endfunction " }}}
nnoremap <Leader>B :call BlockColor()<CR>

" }}}

" Easy filetype switching {{{
nnoremap _md :set ft=markdown<CR>
nnoremap _hd :set ft=htmldjango<CR>
nnoremap _jt :set ft=htmljinja<CR>
nnoremap _cw :set ft=confluencewiki<CR>
nnoremap _pd :set ft=python.django<CR>
nnoremap _d  :set ft=diff<CR>
" }}}

" Split/Join {{{
"
" Basically this splits the current line into two new ones at the cursor position,
" then joins the second one with whatever comes next.
"
" Example:                      Cursor Here
"                                    |
"                                    V
" foo = ('hello', 'world', 'a', 'b', 'c',
"        'd', 'e')
"
"            becomes
"
" foo = ('hello', 'world', 'a', 'b',
"        'c', 'd', 'e')
"
" Especially useful for adding items in the middle of long lists/tuples in Python
" while maintaining a sane text width.
nnoremap <Leader>K h/[^ ]<cr>"zd$jyyP^v$h"zpJk:s/\v +$//<cr>:noh<cr>j^
" }}}

" function! SuperCleverTab()
"   " check if at beginning of line or after a space
"   if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$'
"     return "\<Tab>"
"   else " do we have omni completion available
"     if &omnifunc != ''
"       " use omni-completion 1. priority
"       return "\<C-X>\<C-O>"
"     elseif &dictionary != ''
"       " no omni completion, try dictionary completion
"       return "\<C-K>"
"     else
"       " use omni completion or dictionary completion
"       " use known-word completion
"       return "\<C-N>"
"     endif
"   endif
" endfunction

" " bind function to the tab key
" inoremap <Tab> <C-R>=SuperCleverTab()<CR>

" vimrc.abbrs: default values for vim settings.
" ------------------------------------------------------------------------
" Insertion abbreviations for measurement rules.
iab raz abcdefghijklmnopqrstuvwxyz
iab Raz ABCDEFGHIJKLMNOPQRSTUVWXYZ
iab r10 1234567890
iab r40 1234567890123456789012345678901234567890
iab r80 12345678901234567890123456789012345678901234567890123456789012345678901234567890
iab r72 123456789012345678901234567890123456789012345678901234567890123456789012
iab R10 ----------
iab R40 ----------------------------------------
iab R80 --------------------------------------------------------------------------------
iab R72 ------------------------------------------------------------------------

" General echo "editing abbreviations
" yyyymmdd
iab cdate <C-R>=strftime("%Y%m%d")<CR>
" yyyy.mm.dd
iab cfdate <C-R>=strftime("%Y.%m.%d")<CR>
" hh:mm
iab ctime <C-R>=strftime("%H:%M")<CR>
" yyyymmdd hh:mm
iab cdatetime <C-R>=strftime("%Y%m%d %H:%M")<CR>
" yyyy.mm.dd hh:mm
iab cfdatetime <C-R>=strftime("%Y.%m.%d %%H:%M")<CR>
" system long date
iab clongdate <C-R>=strftime("%a %b %#d %X %z %Y")<CR>
" formatted long date
iab cpdate <C-R>=strftime("%A, %#d %B %Y")<CR>

" Fugitive {{{
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gr :Gremove<cr>
nnoremap <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>

augroup ft_fugitive_vimrc
    autocmd!

    autocmd BufNewFile,BufRead .git/index setlocal nolist
augroup END

" vimrc.syntax: variables set for syntax management.
" ------------------------------------------------------------------------
" Default Syntax settings.
"
" These values have been determined more by trolling through the syntax files
" than reading the documentation. There's more features that exist than are
" documented.

" c.vim
let g:c_gnu=1
let g:c_comment_strings=1
let g:c_space_errors=1
let g:c_ansi_constants=1
let g:c_ansi_typedefs=1

" doxygen
let g:doxygen_enhanced_colour=1

" haskell.vim
let g:hs_allow_hash_operator=1
let g:hs_highlight_boolean=1
let g:hs_highlight_debug=1
let g:hs_highlight_delimiters=1
let g:hs_highlight_more_types=1
let g:hs_highlight_types=1

" html.vim
let g:html_extended_events=1

" java.vim
let g:java_comment_strings=1
let g:java_highlight_all=1
let g:java_highlight_debug=1
let g:java_highlight_functions="style"
let g:java_space_errors=1

" javascript.vim
let g:javaScript_fold=1

" lisp.vim
let g:lisp_instring=1
let g:lisp_rainbow=1

" perl.vim
let g:perl_include_pod=1
let g:perl_fold=1

" perl6.vim
let g:perl6_extended_all=1
let g:perl6_embedded_pir=1

" php.vim
let g:php_sql_query=1
let g:php_baselib=1
let g:php_htmlInStrings=1
let g:php_noShortTags=1
let g:php_parent_error_close=1
let g:php_parent_error_open=1
let g:php_folding=2

" python.vim
let g:python_highlight_all=1

" r.vim
let g:r_syntax_folding=1

" ruby.vim
let g:ruby_fold=1
let g:ruby_space_errors=1
let g:ruby_operators=1

" sh.vim
let g:sh_fold_enabled=1
let g:is_bash=1

" vim.vim
" g:vimsyn_embed defaults to lmpPr (lua, mzscheme, perl, Python, and Ruby)
let g:vimsyn_folding='alfmpPr'

" xml.vim
let g:xml_syntax_folding=1

" vimrc.plugins: plug-in settings/variables that should be set before they
" are loaded.
" ------------------------------------------------------------------------
" This file is used for plug-in settings.

" https://github.com/reinh/vim-makegreen
" nnoremap <Leader>| :call MakeGreen('')<CR>

" Threesome {{{

let g:threesome_leader = "-"

let g:threesome_initial_mode = "grid"

let g:threesome_initial_layout_grid = 1
let g:threesome_initial_layout_loupe = 0
let g:threesome_initial_layout_compare = 0
let g:threesome_initial_layout_path = 0

let g:threesome_initial_diff_grid = 1
let g:threesome_initial_diff_loupe = 0
let g:threesome_initial_diff_compare = 0
let g:threesome_initial_diff_path = 0

let g:threesome_initial_scrollbind_grid = 0
let g:threesome_initial_scrollbind_loupe = 0
let g:threesome_initial_scrollbind_compare = 0
let g:threesome_initial_scrollbind_path = 0

let g:threesome_wrap = "nowrap"

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" An earlier version of Lusty Juggler always spat out an ugly warning if you
" don't have Ruby support compiled in. Just in case:
if !has("ruby")
  let g:LustyJugglerSuppressRubyWarning = 1
endif

let g:syntastic_enable_signs = 1
let g:syntastic_disabled_filetypes = ['html']
let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'
let g:syntastic_jsl_conf = '$HOME/.vim/jsl.conf'

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" gist-vim defaults
if has("mac_unix")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" NERDTree configuration
let g:NERDTreeHighlightCursorline=1
let g:NERDTreeSortDirs=1
let g:NERDTreeSplitVertical=1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeIgnore=['\.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index', 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json', '.*\.o$', 'db.db', '\.rbc$']
noremap <Leader>n :NERDTreeToggle<CR>

augroup ft_nerdtree_vimrc
  autocmd!
  autocmd FileType nerdtree setlocal nolist
augroup END

" OrgMode {{{
" https://github.com/jceb/vim-orgmode
" let g:org_plugins = ['ShowHide', '|', 'Navigator', 'EditStructure', '|', 'Todo', 'Date', 'Misc']
" let g:org_todo_keywords = ['TODO', '|', 'DONE']
" let g:org_debug = 1

" Rainbox Parentheses {{{
" nnoremap <leader>R :RainbowParenthesesToggle<cr>
" let g:rbpt_colorpairs = [
"     \ ['brown',       'RoyalBlue3'],
"     \ ['Darkblue',    'SeaGreen3'],
"     \ ['darkgray',    'DarkOrchid3'],
"     \ ['darkgreen',   'firebrick3'],
"     \ ['darkcyan',    'RoyalBlue3'],
"     \ ['darkred',     'SeaGreen3'],
"     \ ['darkmagenta', 'DarkOrchid3'],
"     \ ['brown',       'firebrick3'],
"     \ ['gray',        'RoyalBlue3'],
"     \ ['black',       'SeaGreen3'],
"     \ ['darkmagenta', 'DarkOrchid3'],
"     \ ['Darkblue',    'firebrick3'],
"     \ ['darkgreen',   'RoyalBlue3'],
"     \ ['darkcyan',    'SeaGreen3'],
"     \ ['darkred',     'DarkOrchid3'],
"     \ ['red',         'firebrick3'],
"     \ ]
" let g:rbpt_max = 16

" Command-T configuration
let g:CommandTMaxHeight=20

" Sparkup
" https://github.com/rstacruz/sparkup
" let g:sparkupNextMapping = '<c-s>'

" SLIMV {{{
" http://www.vim.org/scripts/script.php?script_id=2531
"let g:slimv_lisp = '"java -cp `lein classpath` clojure.main"'
let g:slimv_repl_split = 4
let g:slimv_repl_syntax = 1

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabLongestHighlight = 1

" Scratch
command! ScratchToggle call <SID>ScratchToggle()
function! s:ScratchToggle()
  if bufexists("*Scratch*")
    exec "normal! :ScratchClose"
  else
    exec "normal! :ScratchOpen"
  endif
endfunction
nnoremap <Silent> <Leader><Leader><S> :ScratchToggle<CR>

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
map <C-\> :tnext<CR>

" Find where the abbreviations.txt file exists for the abbrevlist plug-in to
" use.
for s:rt_path in split(&runtimepath, ',')
  if isdirectory(s:rt_path)
    let g:support_file_path=s:rt_path
    break
  endif
endfor

let g:abbrevlist_filename=g:support_file_path.'/abbreviations.txt'

" Statline integration
let g:statline_fugitive=1

" Highlight VCS conflict markers
" match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" " MiniBufExpl Colors
" hi MBEVisibleActive guifg=#A6DB29 guibg=fg
" hi MBEVisibleChangedActive guifg=#F1266F guibg=fg
" hi MBEVisibleChanged guifg=#F1266F guibg=fg
" hi MBEVisibleNormal guifg=#5DC2D6 guibg=fg
" hi MBEChanged guifg=#CD5907 guibg=fg
" hi MBENormal guifg=#808080 guibg=fg

" vimrc.autogroups: autogroup definitions.
" ------------------------------------------------------------------------
if has("autocmd")
  " Markdown setup.
  augroup ft_markdown_vimrc
    autocmd!
    autocmd BufNewFile,BufRead *.{md,markdown,mdown,mkd,mkdn} setfiletype markdown
    autocmd FileType markdown call <SID>setupMarkdown()

    " Use <localleader>1/2/3 to add headings.
    autocmd Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
    autocmd Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
    autocmd Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>
  augroup END

  augroup ft_nginx
    autocmd!

    autocmd BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
    autocmd BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
    autocmd BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
    autocmd BufRead,BufNewFile vhost.nginx                            set ft=nginx

    autocmd FileType nginx setlocal foldmethod=marker foldmarker={,}
  augroup END

  augroup ft_xml_vimrc
    autocmd!
    autocmd FileType xml set foldmethod=syntax
  augroup END

  augroup ft_puppet_vimrc
    autocmd!

    autocmd Filetype puppet setlocal foldmethod=marker
    autocmd Filetype puppet setlocal foldmarker={,}
  augroup END

  augroup ft_ruby_vimrc
    autocmd!
    " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
    autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} setfiletype ruby

    autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
"   autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
"   autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
"   autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
    autocmd FileType eruby setlocal wrap linebreak nolist foldmethod=syntax
  augroup END

  augroup ft_text_vimrc
    autocmd!
    autocmd FileType text call <SID>setupTextWrapping()
  augroup END

  augroup ft_html_vimrc
    autocmd!
    autocmd FileType text,html,xhtml setlocal wrap linebreak nolist
  augroup END

  augroup ft_java_vimrc
    autocmd!

    autocmd FileType java setlocal foldmethod=marker
    autocmd FileType java setlocal foldmarker={,}
  augroup END

  augroup ft_javascript_vimrc
    autocmd!

    autocmd FileType javascript setlocal foldmethod=marker
    autocmd FileType javascript setlocal foldmarker={,}
  augroup END

  augroup ft_lisp_vimrc
    autocmd!
    autocmd FileType lisp call TurnOnLispFolding()
  augroup END

  augroup ft_shell_vimrc
    autocmd!
    autocmd FileType sh,zsh,csh setlocal comments=:# formatoptions+=r
  augroup END

  augroup ft_c_vimrc
    autocmd!
    " When starting to edit a file: For *.c and *.h files set formatting of
    " comments and set C-indenting on. For other files switch it off. Don't
    " change the order, it's important that the line with * comes first.
    autocmd BufRead *.gsoap,*.dox,*.h.tmpl,*.cpp.tmpl setlocal filetype=cpp
    autocmd BufRead *.gsoap setlocal include=^\s*#\s*include\|^\s*#\s*import
    autocmd FileType c,cpp,objc,objcpp setlocal foldmethod=syntax
  augroup END

  augroup ft_css_vimrc
    autocmd!

    autocmd BufNewFile,BufRead *.less setlocal filetype=less

    autocmd Filetype less,css setlocal foldmethod=marker
    autocmd Filetype less,css setlocal foldmarker={,}
    autocmd Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd Filetype less,css setlocal iskeyword+=-

    " Use <Leader>S to sort properties.  Turns this:
    "
    "     p {
    "         width: 200px;
    "         height: 100px;
    "         background: red;
    "
    "         ...
    "     }
    "
    " into this:

    "     p {
    "         background: red;
    "         height: 100px;
    "         width: 200px;
    "
    "         ...
    "     }
    autocmd BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    " Make {<CR> insert a pair of brackets in such a way that the cursor is correctly
    " positioned inside of them AND the following code doesn't get unfolded.
    autocmd BufNewFile,BufRead *.less,*.css inoremap <buffer> {<CR> {}<Left><CR><space><space><space><space>.<CR><ESC>kA<bs>
  augroup END

  augroup ft_django_vimrc
    autocmd!

    autocmd BufNewFile,BufRead urls.py           setlocal nowrap
    autocmd BufNewFile,BufRead urls.py           normal! zR
    autocmd BufNewFile,BufRead dashboard.py      normal! zR
    autocmd BufNewFile,BufRead local_settings.py normal! zR

    autocmd BufNewFile,BufRead admin.py     setlocal filetype=python.django
    autocmd BufNewFile,BufRead urls.py      setlocal filetype=python.django
    autocmd BufNewFile,BufRead models.py    setlocal filetype=python.django
    autocmd BufNewFile,BufRead views.py     setlocal filetype=python.django
    autocmd BufNewFile,BufRead settings.py  setlocal filetype=python.django
    autocmd BufNewFile,BufRead settings.py  setlocal foldmethod=marker
    autocmd BufNewFile,BufRead forms.py     setlocal filetype=python.django
    autocmd BufNewFile,BufRead common_settings.py  setlocal filetype=python.django
    autocmd BufNewFile,BufRead common_settings.py  setlocal foldmethod=marker
  augroup END

  augroup ft_org_vimrc
    autocmd!

    autocmd Filetype org nmap <buffer> Q vahjgq
  augroup END

  augroup ft_quickfix_vimrc
    autocmd!
    autocmd Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
  augroup END

  augroup ft_rest_vimrc
    autocmd!

    autocmd Filetype rst nnoremap <buffer> <localleader>1 yypVr=
    autocmd Filetype rst nnoremap <buffer> <localleader>2 yypVr-
    autocmd Filetype rst nnoremap <buffer> <localleader>3 yypVr~
    autocmd Filetype rst nnoremap <buffer> <localleader>4 yypVr`
  augroup END

  augroup ft_python_vimrc
    autocmd!

    autocmd Filetype python noremap  <buffer> <localleader>rr :RopeRename<CR>
    autocmd Filetype python vnoremap <buffer> <localleader>rm :RopeExtractMethod<CR>
    autocmd Filetype python noremap  <buffer> <localleader>ri :RopeOrganizeImports<CR>

    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType python setlocal define=^\s*\\(def\\\\|class\\)
    autocmd FileType python compiler nose
    autocmd FileType man nnoremap <buffer> <CR> :q<CR>
  augroup END

  augroup ft_vim_vimrc
    autocmd!

    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType help setlocal textwidth=78
"   autocmd BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
  augroup END

" let g:slimv_leader = '\'
" let g:slimv_keybindings = 2

  augroup ft_clojure_vimrc
    autocmd!
    autocmd FileType clojure call TurnOnClojureFolding()
    autocmd FileType clojure compiler clojure
    autocmd FileType clojure setlocal report=100000
    autocmd FileType clojure nnoremap <buffer> o jI<CR><ESC>kA
    autocmd FileType clojure nnoremap <buffer> O I<CR><ESC>kA

    autocmd BufWinEnter        Slimv.REPL.clj setlocal winfixwidth
    autocmd BufNewFile,BufRead Slimv.REPL.clj setlocal nowrap
    autocmd BufNewFile,BufRead Slimv.REPL.clj setlocal foldlevel=99
    autocmd BufNewFile,BufRead Slimv.REPL.clj nnoremap <buffer> A GA
    autocmd BufNewFile,BufRead Slimv.REPL.clj nnoremap <buffer> <localleader>R :emenu REPL.<Tab>

    " Fix the eval mapping.
    autocmd FileType clojure nmap <buffer> \ee \ed

    " Indent top-level form.
    autocmd FileType clojure nmap <buffer> <localleader>= v((((((((((((=%

    " Use a swank command that works, and doesn't require new app windows.
    autocmd FileType clojure let g:slimv_swank_cmd='!dtach -n /tmp/dtach-swank.sock -r winch lein swank'
  augroup END

  augroup ft_sqlish_vimrc
    autocmd!
    autocmd FileType sql,plsql setlocal fo=tcroq2 cin com=sr:/*,mb:*,elx:*/,:--
  augroup END

  augroup ft_json_vimrc
    autocmd!
    " add json syntax highlighting
    autocmd BufNewFile,BufRead *.json setfiletype javascript
  augroup END

  augroup vimrcExtra
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal g`\"" |
          \ endif

    " Automatically load .vimrc source when saved
    autocmd BufWritePost .vimrc source $MYVIMRC
    autocmd BufWritePost .gvimrc source $MYGVIMRC
  augroup END
  augroup vimrcAllBuffers
    autocmd!
    autocmd BufRead * set modeline number
"   autocmd FileType * set fo=tcroq2 nocin si com& 
  augroup END
  augroup vimrcWindows
    autocmd!
    " Save when losing focus
    " autocmd FocusLost * :wa

    " Resize splits when the window is resized
    autocmd VimResized * exe "normal! \<C-W>="
  augroup END
else
  set autoindent
endif

" config_files: Useful maps for managing config files
" ------------------------------------------------------------------------
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>eg :vsplit $MYGVIMRC<CR>
nnoremap <Leader>es :vsplit $HOME/.vim/snippets/<CR>

" Shell
function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <Silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <Silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <Leader>! :Shell 

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" Clean whitespace
map <Leader>W  :%s/\s\+$//<CR>:let @/=''<CR>

" Dammit, Slimv
map <Leader>WW :%s/\s\+$//<CR>:let @/=''<CR>

" Substitute
nnoremap <Leader>s :%s//<Left>

" Change case
nnoremap <C-U> gUiw
inoremap <C-U> <ESC>gUiwea

" Hg ---------------------------------------------------------------------- {{{

function! s:HgDiff()
  diffthis

  let fn = expand('%:p')
  let ft = &ft

  wincmd v
  edit __hgdiff_orig__

  setlocal buftype=nofile

  normal ggdG
  execute "silent r!hg cat --rev . " . fn
  normal ggdd

  execute "setlocal ft=" . ft

  diffthis
  diffupdate
endf
command! -nargs=0 HgDiff call s:HgDiff()
nnoremap <leader>hd :HgDiff<cr>

function! s:HgBlame()
  let fn = expand('%:p')

  wincmd v
  wincmd h
  edit __hgblame__
  vertical resize 28

  setlocal scrollbind winfixwidth nolist nowrap nonumber buftype=nofile ft=none

  normal ggdG
  execute "silent r!hg blame -undq " . fn
  normal ggdd
  execute ':%s/\v:.*$//'

  wincmd l
  setlocal scrollbind
  syncbind
endf
command! -nargs=0 HgBlame call s:HgBlame()
nnoremap <leader>hb :HgBlame<cr>

" Diffoff
nnoremap <Leader>D :diffoff!<cr>

set diffopt-=iwhite
let g:diffwhitespaceon = 1
function! s:ToggleDiffWhitespace() "{{{
  if g:diffwhitespaceon
    set diffopt-=iwhite
    let g:diffwhitespaceon = 0
  else
    set diffopt+=iwhite
    let g:diffwhitespaceon = 1
  endif
  diffupdate
endfunc "}}}
nnoremap <leader>dw :call <SID>ToggleDiffWhitespace()<CR>

" Replaste
nnoremap <D-p> "_ddPV`]=

function! NyanMe() " {{{
    hi NyanFur             guifg=#BBBBBB
    hi NyanPoptartEdge     guifg=#ffd0ac
    hi NyanPoptartFrosting guifg=#fd3699 guibg=#fe98ff
    hi NyanRainbow1        guifg=#6831f8
    hi NyanRainbow2        guifg=#0099fc
    hi NyanRainbow3        guifg=#3cfa04
    hi NyanRainbow4        guifg=#fdfe00
    hi NyanRainbow5        guifg=#fc9d00
    hi NyanRainbow6        guifg=#fe0000


    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl None
    echo ""

    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanFur
    echon "╰"
    echohl NyanPoptartEdge
    echon "⟨"
    echohl NyanPoptartFrosting
    echon "⣮⣯⡿"
    echohl NyanPoptartEdge
    echon "⟩"
    echohl NyanFur
    echon "⩾^ω^⩽"
    echohl None
    echo ""

    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl None
    echon " "
    echohl NyanFur
    echon "”   ‟"
    echohl None

    sleep 1
    redraw
    echo " "
    echo " "
    echo "Noms?"
    redraw
endfunction " }}}
command! NyanMe call NyanMe()

" The last thing we do is load bundles via Pathogen.
call pathogen#infect()
" call pathogen#helptags()
syntax on
filetype plugin indent on

" % to bounce from do to end etc.
runtime! macros/matchit.vim
