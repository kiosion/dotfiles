" Vim shells out for fzf, gitgutter, ALE and vim-plug's installer, and those
" callers assume a POSIX shell. Fish breaks them. Use :Term for interactive fish.
set shell=/bin/bash
set nocompatible

"-------------------------------------------------------------
" Vim-plug setup {{{1

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"-------------------------------------------------------------
" Plugs {{{1

call plug#begin()
  " ALE, syntax highlighting and linting support
  Plug 'dense-analysis/ale'

  " P lang support and ALE linting
  Plug 'kiosion/p-vim'

  " vim-svelte-plugin, syntax + indent support for svelte filetypes
  Plug 'evanleck/vim-svelte', {'branch': 'main'}

  " html5.vim, for html/xml syntax highlighting
  Plug 'othree/html5.vim'

  " vim-elixir, syntax + lsp for erlang/elixir
  Plug 'elixir-editors/vim-elixir'

  " coc.nvim, autocompletion and ts stuff
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Airline status line
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " CoPilot
  Plug 'github/copilot.vim'

  " vim-javascript
  Plug 'pangloss/vim-javascript'

  " NERDTree
  Plug 'preservim/nerdtree'

  " fzf
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " fugitive
  Plug 'tpope/vim-fugitive'

  " Vimagit
  Plug 'jreybert/vimagit'

  " git-gutter
  Plug 'airblade/vim-gitgutter'

  " tailwindcss intellisense
  Plug 'airblade/vim-tailwind'

  " multi-cursors
  Plug 'mg979/vim-visual-multi'

  " vim-wakatime
  Plug 'wakatime/vim-wakatime'
call plug#end()

"-------------------------------------------------------------
" Plugin configs {{{1

" enable P linting
let g:p_lint = 1

" Raise the regexp engine's memory ceiling. Large generated files (bundled JS,
" protobuf output) blow past the 1000KB default and lose syntax highlighting.
set mmp=5000

" vim-svelte-plugin
let g:svelte_preprocessor_tags = [
  \ { 'name': 'scss', 'tag': 'style' },
  \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' },
  \ ]

let g:svelte_preprocessors = ['typescript', 'scss']

" Search excludes
"
" Both fd and ripgrep already honour .gitignore whenever the search starts
" inside a git repository, and both read .ignore files anywhere. This list is
" only for what is committed and still machine-written, which no ignore file
" covers. Add to the one list and every search below picks it up.
let g:search_exclude = [
  \ '*.pb.go', '*.pb.gw.go', '*.gen.go', '*_generated.go',
  \ '*_pb.ts', '*_pb.*.ts', '*_pb.js', '*.min.js',
  \ 'package-lock.json', 'yarn.lock', '*.snap',
  \ ]

" fd spells this --exclude, ripgrep spells it as a negated --glob.
let g:fd_exclude = join(map(copy(g:search_exclude), '"--exclude " . shellescape(v:val)'))
let g:rg_exclude = join(map(copy(g:search_exclude), '"--glob " . shellescape("!" . v:val)'))

" job_start takes an argument list and runs no shell. That form needs no
" quoting.
let g:rg_exclude_args = flattennew(map(copy(g:search_exclude), '["--glob", "!" . v:val]'))

" fzf
let $FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules --exclude dist --exclude build ' . g:fd_exclude

" Enter opens the result in its own tab. The empty key is how fzf.vim spells
" "no expect key was pressed", which is what Enter produces. drop reuses a
" window or tab that already holds the file rather than opening a second copy
" of it, and 'switchbuf' below is what lets it look in other tabs.
let g:fzf_action = {
  \ '':       'tab drop',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Copilot
let g:copilot_ignore_node_version = 1

" ALE
"
" coc owns the language servers. ALE runs only the linters coc does not
" provide, and does the formatting on save. Listing gopls here as well would
" start a second gopls process per project on top of the one coc-go runs.
"
" ALE has no prettier linter for any of these filetypes, only a fixer, so
" prettier belongs in g:ale_fixers alone.
let g:ale_linters = {
 \ 'javascript': ['eslint'],
 \ 'typescript': ['eslint'],
 \ 'typescriptreact': ['eslint'],
 \ 'javascriptreact': ['eslint'],
 \ 'svelte': ['eslint'],
 \ 'go': ['golangci-lint'],
 \ 'elixir': ['mix_format'],
 \}

let g:ale_fixers = {
 \ 'javascript': ['prettier', 'eslint'],
 \ 'typescript': ['prettier', 'eslint'],
 \ 'typescriptreact': ['prettier', 'eslint'],
 \ 'javascriptreact': ['prettier', 'eslint'],
 \ 'svelte': ['prettier', 'eslint'],
 \ 'html': ['prettier'],
 \ 'css': ['prettier'],
 \ 'scss': ['prettier'],
 \ 'go': ['goimports'],
 \ 'elixir': ['mix_format'],
 \}

let g:ale_pattern_options = {
 \ '.*node_modules.*$': {'ale_enabled': 0},
 \ '.*dist.*$': {'ale_enabled': 0},
 \ '.*-config.js$': {'ale_enabled': 0},
 \ '.*/build/.*$': {'ale_enabled': 0},
 \}

let g:ale_fix_on_save = 1

" GitGutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" GitGutter claims ]c and [c for hunk navigation by default. Keep those, but
" drop its other default maps so <Leader>g is free for the git group below.
let g:gitgutter_map_keys = 0

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#branch#icon=''
let g:airline#extensions#coc#enabled=1

let g:airline_powerline_fonts = 1

let g:airline_theme='deus'

"------------------------------------------------------------
" Colour customization {{{1

set termguicolors

colorscheme catppuccin_macchiato

" coc.nvim
highlight CocFloating ctermbg=DarkGrey ctermfg=LightGrey
highlight CocMenuSel ctermbg=250 ctermfg=16
highlight CocListBgGrey ctermbg=DarkGrey ctermfg=LightGrey
highlight CocListLine ctermbg=DarkGrey ctermfg=LightGrey

"-------------------------------------------------------------
" Features {{{1

if has('filetype')
    filetype indent plugin on
endif

if has('syntax')
    syntax on
endif

"------------------------------------------------------------
" Options {{{1

" coc applies cross-file edits (rename, code actions) by loading the other
" buffers. Without 'hidden' those edits fail on any file not already open.
set hidden

" Everything driven by CursorHold reads as broken at the 4000ms default:
" symbol highlighting, diagnostic messages, gitgutter refresh.
set updatetime=300

" gitgutter, ALE and coc all place signs. Pinning the column stops the text
" from shifting sideways every time a sign appears or clears.
set signcolumn=yes

" Airline lives in the status line, and laststatus=1 hides it until a split
" exists.
set laststatus=2

set confirm
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set visualbell
set t_vb=
set cmdheight=1
set nu
set notimeout ttimeout ttimeoutlen=200
set wmh=0
set scrolloff=5

" New splits open where the eye already is.
set splitright
set splitbelow

" Jumping to a file already open somewhere goes to that window or tab instead
" of loading a second copy. Quickfix jumps and :drop both read this.
set switchbuf=useopen,usetab

if has('mouse')
    set mouse=a
endif

" Indentation
set shiftwidth=4
set softtabstop=4
set expandtab

" Folding is manual. foldmethod=syntax cost a syntax pass on every edit and
" produced no folds, because none of these filetypes define syntax folds
" without an opt-in flag. This vimrc marks its own sections with {{{1. Those get
" foldmethod=marker instead.
autocmd FileType vim setlocal foldmethod=marker foldlevel=0

"------------------------------------------------------------
" Keymaps {{{1
"
" The scheme. Every new binding has an obvious home under it:
"
"   g<key>          go somewhere (LSP navigation, vim's own convention)
"   ]x / [x         next / previous x
"   <Leader>f       find
"   <Leader>c       code
"   <Leader>g       git
"   <Leader>w       window
"   <Leader>t       tab
"
" <Leader>? prints the whole list.

let mapleader = " "
nnoremap <Space> <Nop>

"------------------------------------------------------------
" Keymaps: navigation {{{2

" gd jumps in place, gD opens the definition beside the current file. gD is
" normally go-to-declaration, which for Go and TypeScript is the same location
" as the definition. The key is better spent on the split.
nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gD :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Hover. definitionHover shows the signature and the definition body, which is
" what hovering in a full IDE gives you.
nnoremap <silent> K :call ShowDocumentation()<CR>

" Ctrl+click goes to the declaration, or lists usages when already on it.
" Ctrl+right-click walks the jump list back.
nnoremap <silent> <C-LeftMouse> <LeftMouse>:call SmartJump()<CR>
nnoremap <C-RightMouse> <C-o>

" Highlight the other occurrences of whatever the cursor is on.
autocmd CursorHold * silent call CocActionAsync('highlight')

"------------------------------------------------------------
" Keymaps: next and previous {{{2

" Diagnostics come from ALE. coc-settings.json sets diagnostic.displayByAle,
" so the language server's errors arrive through ALE as well.
nnoremap <silent> ]d :ALENextWrap<CR>
nnoremap <silent> [d :ALEPreviousWrap<CR>

" ]c and [c are gitgutter's, left as they are.

" gt and gT already do this in one keystroke and are built in. These exist so
" the bracket family stays complete. Capital T moves the tab instead.
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]T :tabmove +1<CR>
nnoremap <silent> [T :tabmove -1<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

"------------------------------------------------------------
" Keymaps: find {{{2

nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fg :Rg<CR>
nnoremap <silent> <Leader>fw :Rg <C-r><C-w><CR>
nnoremap <silent> <Leader>fb :Buffers<CR>
nnoremap <silent> <Leader>fl :BLines<CR>
nnoremap <silent> <Leader>fr :History<CR>
nnoremap <silent> <Leader>fc :Commands<CR>
nnoremap <silent> <Leader>fh :Helptags<CR>
nnoremap <silent> <Leader>fm :Maps<CR>
nnoremap <silent> <Leader>fj :Jumps<CR>

" References, implementations and comment mentions of the symbol under the
" cursor, merged into one quickfix list. Same action Ctrl+click reaches.
nnoremap <silent> <Leader>fu :call Usages()<CR>
nnoremap <silent> <Leader>fU :call SmartJump()<CR>

" Project-wide symbol search and the current file's structure.
nnoremap <silent> <Leader>fs :CocList -I symbols<CR>
nnoremap <silent> <Leader>fo :CocList outline<CR>
nnoremap <silent> <Leader>fd :CocList diagnostics<CR>

" fzf's :Rg searches file contents only. Without this it also matches on the
" path. Every hit in a file whose name contains the term then floods the list.
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '
  \   . g:rg_exclude . ' -- ' . shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

"------------------------------------------------------------
" Keymaps: code {{{2

nmap <Leader>cr <Plug>(coc-rename)
nmap <Leader>ca <Plug>(coc-codeaction-cursor)
xmap <Leader>ca <Plug>(coc-codeaction-selected)
nmap <Leader>cA <Plug>(coc-codeaction-source)
nmap <Leader>cf <Plug>(coc-fix-current)
nmap <Leader>cl <Plug>(coc-codelens-action)
nmap <Leader>cF <Plug>(coc-format)
xmap <Leader>cF <Plug>(coc-format-selected)
nnoremap <silent> <Leader>cs :call ShowDocumentation()<CR>

" Call and type hierarchy. Call hierarchy answers who calls this and what does
" it call. That question only means anything for a function or a method. On a
" type name it fails with "X is not a function". Use ct and cT for types, or
" gi for the concrete implementations of an interface.
nnoremap <silent> <Leader>ci :call CocActionAsync('showIncomingCalls')<CR>
nnoremap <silent> <Leader>co :call CocActionAsync('showOutgoingCalls')<CR>
nnoremap <silent> <Leader>ct :call CocActionAsync('showSuperTypes')<CR>
nnoremap <silent> <Leader>cT :call CocActionAsync('showSubTypes')<CR>

"------------------------------------------------------------
" Keymaps: git {{{2

nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>gd :Gdiffsplit<CR>
nnoremap <silent> <Leader>gl :Commits<CR>
nnoremap <silent> <Leader>gL :BCommits<CR>
nnoremap <silent> <Leader>gm :Magit<CR>
nnoremap <silent> <Leader>gp :GitGutterPreviewHunk<CR>
nnoremap <silent> <Leader>gu :GitGutterUndoHunk<CR>
nnoremap <silent> <Leader>gS :GitGutterStageHunk<CR>

" Files changed against HEAD.
nnoremap <silent> <Leader>gf :GFiles?<CR>

"------------------------------------------------------------
" Keymaps: window {{{2

" Ctrl+hjkl moves focus. <Leader>w plus hjkl moves the window itself.
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Ctrl+j and Ctrl+k scroll a documentation popup when one is open, and fall
" back to moving between splits when none is.
nnoremap <silent><expr> <C-j> PopupVisible() ? ScrollPopup(3) : "\<C-w>j"
nnoremap <silent><expr> <C-k> PopupVisible() ? ScrollPopup(-3) : "\<C-w>k"

nnoremap <silent> <Leader>wh :wincmd H<CR>
nnoremap <silent> <Leader>wj :wincmd J<CR>
nnoremap <silent> <Leader>wk :wincmd K<CR>
nnoremap <silent> <Leader>wl :wincmd L<CR>

nnoremap <silent> <Leader>wv :vsplit<CR>
nnoremap <silent> <Leader>ws :split<CR>
nnoremap <silent> <Leader>wc :close<CR>
nnoremap <silent> <Leader>wo :only<CR>
nnoremap <silent> <Leader>w= <C-w>=

" Resize with the arrow keys.
nnoremap <C-Right> <C-w>>
nnoremap <C-Left> <C-w><
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-

"------------------------------------------------------------
" Keymaps: tab {{{2

nnoremap <silent> <Leader>tn :tabnew<CR>
nnoremap <silent> <Leader>tc :tabclose<CR>
nnoremap <silent> <Leader>to :tabonly<CR>

nnoremap <silent> <Leader>1 :tabn 1<CR>
nnoremap <silent> <Leader>2 :tabn 2<CR>
nnoremap <silent> <Leader>3 :tabn 3<CR>
nnoremap <silent> <Leader>4 :tabn 4<CR>
nnoremap <silent> <Leader>5 :tabn 5<CR>
nnoremap <silent> <Leader>6 :tabn 6<CR>
nnoremap <silent> <Leader>7 :tabn 7<CR>
nnoremap <silent> <Leader>8 :tabn 8<CR>
nnoremap <silent> <Leader>9 :tablast<CR>

"------------------------------------------------------------
" Keymaps: everything else {{{2

" Yank to end of line, matching D and C. Normal mode only: mapping this with
" :map also rebinds visual Y, which then yanks the selection charwise instead
" of the lines it covers.
nnoremap Y y$

" System clipboard.
vnoremap <Leader>y "+y
vnoremap <Leader>Y "+yg_
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Clear search highlighting. This used to live on <C-l>, where the split
" navigation mapping overwrote it.
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" File tree.
nnoremap <silent> <Leader>e :call ToggleTree()<CR>
nnoremap <silent> <C-b> :call ToggleTree()<CR>

" The cheatsheet.
nnoremap <silent> <Leader>? :call Cheatsheet()<CR>

" Interactive fish, since 'shell' is bash for everything Vim runs itself.
command! Term terminal ++curwin fish

" Scroll five lines at a time.
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
vnoremap <C-e> 5<C-e>
vnoremap <C-y> 5<C-y>

" Move the current line or selection up and down. macOS sends the composed
" character for Option+j and Option+k rather than a meta key.
if has('macunix')
  xnoremap ˚ :m-2<CR>gv=gv
  xnoremap ∆ :m'>+1<CR>gv=gv
  nnoremap ˚ :<C-u>m-2<CR>==
  nnoremap ∆ :<C-u>m+<CR>==
else
  xnoremap <A-Up> :m-2<CR>gv=gv
  xnoremap <A-Down> :m'>+1<CR>gv=gv
  nnoremap <A-Up> :<C-u>m-2<CR>==
  nnoremap <A-Down> :<C-u>m+<CR>==
endif

"------------------------------------------------------------
" Keymaps: insert mode {{{2

" Enter accepts a completion when coc's menu is open. Copilot keeps Tab.
inoremap <silent><expr> <Enter> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" Esc closes coc's menu before it leaves insert mode. This sits in the path of
" every arrow key, since those send Esc-prefixed sequences. It works because
" ttimeoutlen is short. Remove it first if insert mode ever feels laggy.
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#close() : "\<Esc>"

" Ask for completions without typing another character.
inoremap <silent><expr> <C-Space> coc#refresh()

"------------------------------------------------------------
" Functions {{{1

function! ShowDocumentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('definitionHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

"------------------------------------------------------------
" Functions: usages {{{2

function! s:Uri2Path(uri) abort
  return substitute(a:uri, '^file://', '', '')
endfunction

function! s:HasCoc(feature) abort
  try
    return CocHasProvider(a:feature)
  catch
    return 0
  endtry
endfunction

" State for one search. Every source writes here and decrements pending, and
" whichever finishes last opens the picker.
let s:usages = {'pending': 0}

function! s:UsagesEcho() abort
  redraw
  echo printf('Usages of %s: %d refs, %d impls, %d text%s',
    \ s:usages.word, s:usages.ref, s:usages.impl, len(s:usages.rg),
    \ s:usages.pending > 0 ? '  (searching)' : '')
endfunction

" ripgrep already carries the line text for every hit it reports, and every
" semantic reference is also a textual hit of the same word. Tagging ripgrep's
" output from the language server's positions avoids opening each matched file
" a second time just to read one line out of it.
function! s:Fmt(kind, path, lnum, col, text) abort
  let colour = a:kind ==# 'ref' ? '32' : (a:kind ==# 'impl' ? '35' : '90')
  return printf("%s:%s:%s:\033[%sm[%s]\033[0m %s",
    \ a:path, a:lnum, a:col, colour, a:kind, a:text)
endfunction

function! s:Tag(line) abort
  let m = matchlist(a:line, '^\(.\{-}\):\(\d\+\):\(\d\+\):\(.*\)$')
  if empty(m)
    return a:line
  endif
  " ripgrep reports paths under the './' it was given. Marks are keyed without.
  let key = substitute(m[1], '^\./', '', '') . ':' . m[2]
  let s:usages.seen[key] = 1
  return s:Fmt(get(s:usages.marks, key, 'text'), m[1], m[2], m[3], m[4])
endfunction

function! s:UsagesDone() abort
  if s:usages.pending > 0
    return
  endif
  if exists('s:usages.timer')
    call timer_stop(s:usages.timer)
  endif
  call s:UsagesEcho()

  if empty(s:usages.rg)
    echohl WarningMsg | echo 'No usages of ' . s:usages.word | echohl None
    return
  endif

  let s:usages.seen = {}
  let lines = map(s:usages.rg, {_, l -> s:Tag(l)})

  " A type that implements an interface almost never spells the interface name
  " out as a whole word. ripgrep never reported those lines. Put the language
  " server hits the text search could not have found in front, reading one
  " line out of the file for each. Only a handful reach this loop.
  let extra = []
  let cache = {}
  for [kind, path, lnum] in s:usages.locs
    let key = path . ':' . lnum
    if has_key(s:usages.seen, key)
      continue
    endif
    let s:usages.seen[key] = 1
    if !has_key(cache, path)
      let cache[path] = filereadable(path) ? readfile(path) : []
    endif
    call add(extra, s:Fmt(kind, path, lnum, 1, trim(get(cache[path], lnum - 1, ''))))
  endfor
  let lines = extra + lines

  let tmp = tempname()
  call writefile(lines, tmp)

  " fzf#vim#grep gives the preview window scrolled to the match, multi-select
  " with Tab, and a sink that fills the quickfix list when more than one line
  " is chosen. Feeding it a file avoids re-running the search.
  call fzf#vim#grep('cat ' . shellescape(tmp),
    \ fzf#vim#with_preview({'options': ['--prompt', 'Usages(' . s:usages.word . ')> ']}), 0)
endfunction

function! s:CollectLsp(kind, err, result) abort
  for loc in type(a:result) == v:t_list ? a:result : []
    let path = fnamemodify(s:Uri2Path(loc.uri), ':.')
    let lnum = loc.range.start.line + 1
    let key = path . ':' . lnum
    if a:kind ==# 'impl' || !has_key(s:usages.marks, key)
      let s:usages.marks[key] = a:kind
    endif
    call add(s:usages.locs, [a:kind, path, lnum])
    let s:usages[a:kind] += 1
  endfor
  let s:usages.pending -= 1
  call s:UsagesEcho()
  call s:UsagesDone()
endfunction

function! s:CollectRg(job, status) abort
  if filereadable(s:usages.tmp)
    let s:usages.rg = readfile(s:usages.tmp)
    call delete(s:usages.tmp)
  endif
  let s:usages.pending -= 1
  call s:UsagesEcho()
  call s:UsagesDone()
endfunction

" A language server on a large repository can take a while to answer. Give up
" waiting rather than leaving the search looking hung, and show what arrived.
function! s:UsagesTimeout(timer) abort
  if s:usages.pending <= 0
    return
  endif
  echohl WarningMsg | echo 'Usages: language server did not answer, showing text matches' | echohl None
  let s:usages.pending = 0
  call s:UsagesDone()
endfunction

" Everything that touches the symbol under the cursor. The language server
" reports semantic uses only, which is why a plain reference search misses the
" name where it appears in a doc comment. ripgrep covers that half. Each of
" the three sources runs without blocking. Vim stays usable while a slow
" server catches up.
function! Usages() abort
  let word = expand('<cword>')
  if empty(word)
    echohl WarningMsg | echo 'No symbol under cursor' | echohl None
    return
  endif

  if has_key(s:usages, 'job') && job_status(s:usages.job) ==# 'run'
    call job_stop(s:usages.job)
  endif

  let s:usages = {'word': word, 'marks': {}, 'locs': [], 'seen': {}, 'rg': [],
    \ 'ref': 0, 'impl': 0, 'pending': 1, 'tmp': tempname()}

  for [kind, action, feature] in [
    \ ['ref', 'references', 'reference'],
    \ ['impl', 'implementations', 'implementation']]
    if s:HasCoc(feature)
      let s:usages.pending += 1
      call CocActionAsync(action, function('s:CollectLsp', [kind]))
    endif
  endfor

  " The trailing '.' and the null stdin both matter. A job's stdin is a pipe
  " rather than a terminal, and ripgrep with no path argument reads stdin when
  " it is not a terminal. It would find nothing and exit 1.
  " Generated files are excluded from the text half only. A semantic hit in one
  " still arrives from the language server and lands in the extra pass above,
  " so a real reference inside generated code is never hidden.
  let s:usages.job = job_start(
    \ ['rg', '--vimgrep', '--word-regexp', '--fixed-strings']
    \   + g:rg_exclude_args + ['--', word, '.'],
    \ {'in_io': 'null', 'out_io': 'file', 'out_name': s:usages.tmp,
    \  'err_io': 'null', 'exit_cb': function('s:CollectRg')})

  let s:usages.timer = timer_start(20000, function('s:UsagesTimeout'))
  call s:UsagesEcho()
endfunction

" One key that behaves the way ctrl+click does in a full IDE. Standing on a
" use of a symbol, jump to where it is declared. Standing on the declaration
" there is nowhere to jump. List everything that uses it instead.
function! s:SmartJumpDone(err, defs) abort
  if type(a:defs) == v:t_list && len(a:defs) > 0
    let d = a:defs[0]
    let here = resolve(s:Uri2Path(d.uri)) ==# resolve(expand('%:p'))
      \ && line('.') == d.range.start.line + 1
      \ && col('.') > d.range.start.character
      \ && col('.') <= d.range.end.character
    if !here
      call CocActionAsync('jumpDefinition')
      return
    endif
  endif
  call Usages()
endfunction

function! SmartJump() abort
  if !s:HasCoc('definition')
    call Usages()
    return
  endif
  call CocActionAsync('definitions', function('s:SmartJumpDone'))
endfunction

function! PopupVisible() abort
    return len(popup_list()) > 0
endfunction

function! ScrollPopup(nlines) abort
    let winids = popup_list()
    if len(winids) == 0
        return
    endif

    " Ignore hidden popups
    let prop = popup_getpos(winids[0])
    if prop.visible != 1
        return
    endif

    let firstline = prop.firstline + a:nlines
    let buf_lastline = str2nr(trim(win_execute(winids[0], "echo line('$')")))
    if firstline < 1
        let firstline = 1
    elseif prop.lastline + a:nlines > buf_lastline
        let firstline = buf_lastline + prop.firstline - prop.lastline
    endif

    call popup_setoptions(winids[0], {'firstline': firstline})
endfunction

"------------------------------------------------------------
" Functions: NERDTree {{{2

function! IsNERDTreeOpen() abort
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! CheckIfCurrentBufferIsFile() abort
  return strlen(expand('%')) > 0
endfunction

function! SyncTree() abort
  if &modifiable && IsNERDTreeOpen() && CheckIfCurrentBufferIsFile() && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

function! ToggleTree() abort
  if CheckIfCurrentBufferIsFile()
    if IsNERDTreeOpen()
      NERDTreeClose
    else
      NERDTreeFind
    endif
  else
    NERDTree
  endif
endfunction

" An augroup. Re-sourcing this file then replaces the autocmd rather than adding
" a second copy that runs NERDTreeFind twice on every buffer read.
augroup nerdtree_sync
  autocmd!
  autocmd BufRead * call SyncTree()
augroup END

"------------------------------------------------------------
" Functions: cheatsheet {{{2

function! Cheatsheet() abort
  let l:lines = [
    \ '  NAVIGATE',
    \ '    gd            definition',
    \ '    gD            definition, in a split',
    \ '    gy            type definition',
    \ '    gi            implementations',
    \ '    gr            references',
    \ '    K             hover: signature and definition',
    \ '    Ctrl-click    declaration, or usages when already on it',
    \ '    Ctrl-rightclick / Ctrl-o / Ctrl-i   back, back, forward',
    \ '',
    \ '  NEXT / PREVIOUS',
    \ '    ]d [d         diagnostic        ]c [c   git hunk',
    \ '    ]q [q         quickfix          ]b [b   buffer',
    \ '    gt gT         tab               ]T [T   move tab',
    \ '',
    \ '  <Leader> is Space',
    \ '',
    \ '  FIND                              CODE',
    \ '    ff  files                         cr  rename',
    \ '    fg  grep                          ca  code action',
    \ '    fw  grep word under cursor        cA  code action, whole file',
    \ '    fb  buffers                       cf  quick fix',
    \ '    fl  lines in this buffer          cl  run code lens',
    \ '    fr  recent files                  cF  format',
    \ '    fs  project symbols               cs  show docs',
    \ '    fo  outline of this file          ci  incoming calls',
    \ '    fd  diagnostics                   co  outgoing calls',
    \ '    fc  commands                      ct  super types',
    \ '    fh  vim help                      cT  sub types',
    \ '    fm  every mapping',
    \ '    fj  jump list',
    \ '    fu  usages: refs + impls + comment mentions, with preview',
    \ '    fU  same, but jump to the declaration when not already on it',
    \ '        Tab marks several, Enter on those fills the quickfix list',
    \ '',
    \ '    ci and co are call hierarchy, for functions and methods only.',
    \ '    On an interface use gi for implementations, or ct and cT.',
    \ '',
    \ '  GIT                               WINDOW',
    \ '    gs  status (fugitive)             wh wj wk wl  move window',
    \ '    gm  status (magit)                wv ws        vsplit, split',
    \ '    gb  blame                         wc wo        close, only',
    \ '    gd  diff split                    w=           equalize',
    \ '    gl  commits                       Ctrl-hjkl    move focus',
    \ '    gL  commits for this file         Ctrl-arrows  resize',
    \ '    gf  files changed vs HEAD',
    \ '    gp  preview hunk',
    \ '    gu  undo hunk',
    \ '    gS  stage hunk',
    \ '',
    \ '  TAB                               OTHER',
    \ '    tn tc to  new, close, only        y Y p P   system clipboard',
    \ '    1-8       go to tab               /         clear highlight',
    \ '    9         last tab                e Ctrl-b  file tree',
    \ '                                      ?         this screen',
    \ '',
    \ '  Opt-j / Opt-k moves the line or selection.  :Term opens fish.',
    \ '  q closes this window.',
    \ ]

  botright new
  execute 'resize' min([len(l:lines) + 1, &lines - 4])
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nowrap nonumber signcolumn=no filetype=cheatsheet
  call setline(1, l:lines)
  setlocal nomodifiable
  nnoremap <buffer><silent> q :close<CR>
  nnoremap <buffer><silent> <Esc> :close<CR>

  syntax match CheatSection "^  [A-Z][A-Z /]*$"
  syntax match CheatKey "^\s\{4,\}\S\+\(\s\+\S\+\)\{0,3\}\ze\s\{2,\}"
  highlight default link CheatSection Title
  highlight default link CheatKey Identifier
endfunction

"------------------------------------------------------------
