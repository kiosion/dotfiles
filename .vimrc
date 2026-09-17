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
"
" Copilot hides its ghost text whenever a completion menu is open. That check
" is in copilot.vim itself (autoload/copilot.vim, s:HideDuringCompletion) and
" it defaults on. coc opens a menu on nearly every keystroke. In practice the
" two were never on screen together and each appeared to eat the other.
" Turning it off lets the menu and the ghost text coexist.
let g:copilot_hide_during_completion = 0

" Copilot claims <Tab> by default, which then does nothing useful while coc's
" menu is up. Each gets its own key instead, further down.
let g:copilot_no_tab_map = 1

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

" Show each diagnostic inline, after the code it belongs to. This is already
" the default on a Vim with textprop and popupwin, which this is, but it is the
" behaviour the whole setup leans on so it is worth saying out loud. Set it to
" 'current' for the cursor's line only if every line at once gets noisy.
let g:ale_virtualtext_cursor = 'all'

" goimports on save both removes imports that are no longer used and adds ones
" the file now needs. gopls adds the import by itself when a completion for an
" unimported package is accepted.

" GitGutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" GitGutter claims ]c and [c for hunk navigation by default. Keep those, but
" drop its other default maps so <Leader>g is free for the git group below.
let g:gitgutter_map_keys = 0

" Airline
"
" The bar along the top listed open buffers whenever only one tab existed, and
" silently switched to listing tabs once a second tab appeared. Two different
" things in one strip, which is why it was hard to tell what a chip up there
" referred to. It now always lists tabs, numbered.
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_type = 0
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

" The macchiato palette. The colourscheme keeps its own copy script-local, so
" without this the groups below would be a wall of hex.
let s:cat = {
  \ 'crust':    '#181926',
  \ 'mantle':   '#1E2030',
  \ 'base':     '#24273A',
  \ 'surface0': '#363A4F',
  \ 'surface1': '#494D64',
  \ 'surface2': '#5B6078',
  \ 'overlay0': '#6E738D',
  \ 'overlay1': '#8087A2',
  \ 'overlay2': '#939AB7',
  \ 'subtext0': '#A5ADCB',
  \ 'subtext1': '#B8C0E0',
  \ 'text':     '#CAD3F5',
  \ 'lavender': '#B7BDF8',
  \ 'blue':     '#8AADF4',
  \ 'sapphire': '#7DC4E4',
  \ 'sky':      '#91D7E3',
  \ 'teal':     '#8BD5CA',
  \ 'green':    '#A6DA95',
  \ 'yellow':   '#EED49F',
  \ 'peach':    '#F5A97F',
  \ 'maroon':   '#EE99A0',
  \ 'red':      '#ED8796',
  \ 'mauve':    '#C6A0F6',
  \ 'pink':     '#F5BDE6',
  \ 'flamingo': '#F0C6C6',
  \ }

" Vim's bundled Go syntax highlights keywords and little else. A function name,
" a type name and a struct field all render as plain text, which is why a Go
" file looks so much flatter here than in GoLand. gopls reports what each
" identifier actually is. The CocSem groups below therefore colour most of a
" file, and the syntax file is left with strings, numbers and comments. That
" split is deliberate. gopls sends one flat token for a whole string, where the
" syntax file highlights the escapes and format verbs inside it.
function! s:Colours() abort
  let c = s:cat
  let groups = {
    \ 'CocFloating':           'guibg=' . c.mantle . ' guifg=' . c.text,
    \ 'CocFloatSbar':          'guibg=' . c.surface0,
    \ 'CocFloatThumb':         'guibg=' . c.overlay0,
    \ 'CocFloatDividingLine':  'guifg=' . c.surface1,
    \ 'CocMenuSel':            'guibg=' . c.surface1 . ' guifg=' . c.text,
    \ 'CocPumSearch':          'guifg=' . c.blue . ' gui=bold',
    \ 'CocListLine':           'guibg=' . c.surface0,
    \
    \ 'CocInlayHint':          'guibg=NONE guifg=' . c.overlay0 . ' gui=italic',
    \
    \ 'CocSemTypeNamespace':     'guifg=' . c.lavender,
    \ 'CocSemTypeType':          'guifg=' . c.yellow,
    \ 'CocSemTypeStruct':        'guifg=' . c.yellow,
    \ 'CocSemTypeInterface':     'guifg=' . c.yellow,
    \ 'CocSemTypeClass':         'guifg=' . c.yellow,
    \ 'CocSemTypeEnum':          'guifg=' . c.yellow,
    \ 'CocSemTypeTypeParameter': 'guifg=' . c.yellow . ' gui=italic',
    \ 'CocSemTypeFunction':      'guifg=' . c.blue,
    \ 'CocSemTypeMethod':        'guifg=' . c.blue,
    \ 'CocSemTypeParameter':     'guifg=' . c.maroon,
    \ 'CocSemTypeVariable':      'guifg=' . c.text,
    \ 'CocSemTypeProperty':      'guifg=' . c.lavender,
    \ 'CocSemTypeEnumMember':    'guifg=' . c.peach,
    \ 'CocSemTypeMacro':         'guifg=' . c.peach,
    \ 'CocSemTypeKeyword':       'guifg=' . c.mauve,
    \ 'CocSemTypeModifier':      'guifg=' . c.mauve,
    \ 'CocSemTypeOperator':      'guifg=' . c.sky,
    \ 'CocSemTypeDecorator':     'guifg=' . c.pink,
    \ 'CocSemTypeComment':       'guifg=' . c.overlay2,
    \
    \ 'PanelDoc':    'guifg=' . c.subtext0,
    \ 'PanelCounts': 'guifg=' . c.subtext1 . ' gui=bold',
    \ 'PanelKeys':   'guifg=' . c.overlay0,
    \
    \ 'CheatSection': 'guifg=' . c.blue . ' gui=bold',
    \ 'CheatKey':     'guifg=' . c.flamingo,
    \ }
  for [group, spec] in items(groups)
    execute 'highlight ' . group . ' ' . spec
  endfor
endfunction

" coc installs its own defaults for these groups when it starts and again after
" every :colorscheme, and a plain :highlight in this file was being overridden.
" Running on both events is what makes these stick.
augroup Colours
    autocmd!
    autocmd VimEnter,ColorScheme * call s:Colours()
augroup END

call s:Colours()

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

" A session file records the value of every option and mapping when 'options' is
" included, and restoring it then overrides this vimrc with a stale copy of
" itself. Layout only.
set sessionoptions-=options

if has('mouse')
    set mouse=a
    " Right click moves the cursor to what was clicked before opening the menu
    " defined further down.
    set mousemodel=popup_setpos
endif

" Rest the pointer on a symbol and its documentation appears, no click needed.
" This asks the terminal to report every mouse movement, which is a lot of
" traffic and which some terminals mis-report as scroll wheel events. Turn it
" off live with :set noballoonevalterm if it misbehaves.
if has('balloon_eval_term')
    set balloonevalterm
    set balloondelay=400
    set balloonexpr=BalloonHover()
endif

" Folding is built on request from the language server, which knows where a
" function body or an if block actually ends. Nothing starts folded.
set foldlevelstart=99

" Indentation
set shiftwidth=4
set softtabstop=4
set expandtab

" Folding is manual. foldmethod=syntax cost a syntax pass on every edit and
" produced no folds, because none of these filetypes define syntax folds
" without an opt-in flag. This vimrc marks its own sections with {{{1. Those get
" foldmethod=marker instead.
augroup vimrc_folding
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker foldlevel=0
augroup END

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
"   <Leader>s       session
"
" <Leader>? prints the whole list.

let mapleader = " "
nnoremap <Space> <Nop>

"------------------------------------------------------------
" Keymaps: navigation {{{2

" gd jumps in place, gD opens the definition beside the current file. gD is
" normally go-to-declaration, which for Go and TypeScript is the same location
" as the definition. The key is better spent on the split.
nnoremap <silent> gd :call CocActionAsync('jumpDefinition', g:symbol_open)<CR>
nnoremap <silent> gD :call CocActionAsync('jumpDefinition', 'vsplit')<CR>
nnoremap <silent> gy :call CocActionAsync('jumpTypeDefinition', g:symbol_open)<CR>
nnoremap <silent> gi :call CocActionAsync('jumpImplementation', g:symbol_open)<CR>
nmap <silent> gr <Plug>(coc-references)

" K opens the symbol panel: signature, doc comment, reference and
" implementation counts, and one key per action. gK is the plain hover for
" when the panel is more than the question deserves.
nnoremap <silent> K :call SymbolPanel()<CR>
nnoremap <silent> gK :call ShowDocumentation()<CR>

" Ctrl+click goes to the declaration, or lists usages when already on it.
" Ctrl+right-click walks the jump list back.
nnoremap <silent> <C-LeftMouse> <LeftMouse>:call SmartJump()<CR>
nnoremap <C-RightMouse> <C-o>

" Double click opens the symbol panel on what was clicked, the mouse
" equivalent of K. Shift+click cannot be used: terminals treat Shift with the
" mouse as "bypass the application and let me select text myself". The click
" never reaches Vim. Command+click is unavailable for a related reason,
" the Command key is never forwarded to a terminal program at all.
nnoremap <silent> <2-LeftMouse> :call SymbolPanel()<CR>

" Right click opens this menu at whatever was clicked. <Leader>m opens the
" same menu at the cursor, without the mouse. Every jump here opens in a tab,
" reusing one that already holds the file rather than replacing this buffer.
nnoremenu PopUp.Quick\ documentation :call SymbolPanel()<CR>
nnoremenu PopUp.Go\ to\ definition   :call SmartJump()<CR>
nnoremenu PopUp.Find\ usages         :call Usages()<CR>
nnoremenu PopUp.Implementations      :call CocActionAsync('jumpImplementation', g:symbol_open)<CR>
nnoremenu PopUp.Type\ definition     :call CocActionAsync('jumpTypeDefinition', g:symbol_open)<CR>
nnoremenu PopUp.Rename\.\.\.         :call CocActionAsync('rename')<CR>
nnoremenu PopUp.Code\ action         :call CocActionAsync('codeAction', 'cursor')<CR>
nnoremenu PopUp.Call\ hierarchy      :call CocActionAsync('showIncomingCalls')<CR>

nnoremap <silent> <Leader>m :popup PopUp<CR>

" Highlight the other occurrences of whatever the cursor is on.
augroup vimrc_symbol_highlight
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

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

" Everything uncommitted, with its diff in the preview pane.
nnoremap <silent> <Leader>gc :Changed<CR>
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

" Move this window out to its own tab, or pull this tab back into a split.
nnoremap <silent> <Leader>wt :call WindowToTab()<CR>
nnoremap <silent> <Leader>wV :call TabToSplit('vsplit')<CR>
nnoremap <silent> <Leader>wS :call TabToSplit('split')<CR>

" Back to the file edited before this one.
nnoremap <silent> <Leader><Leader> <C-^>

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
" Keymaps: session {{{2

" Save once in a repository and its tabs, windows and splits are then restored by
" a bare vim there, and written back when that Vim quits.
nnoremap <silent> <Leader>ss :call SessionSave()<CR>
nnoremap <silent> <Leader>sl :call SessionLoad()<CR>
nnoremap <silent> <Leader>sd :call SessionDelete()<CR>

" Apply an edit to this file without restarting.
nnoremap <Leader>R :ReloadConfig<CR>

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

" Build folds from the language server. za, zR and zM take over from there.
nnoremap <silent> <Leader>zf :call BuildFolds()<CR>

" The cheatsheet.
nnoremap <silent> <Leader>? :call Cheatsheet()<CR>

" Interactive fish, since 'shell' is bash for everything Vim runs itself.
command! Term terminal ++curwin fish

" Scroll five lines at a time.
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
vnoremap <C-e> 5<C-e>
vnoremap <C-y> 5<C-y>

" Option and Alt bindings. macOS sends the composed character for Option plus
" a letter rather than a meta key, which is why these are the glyphs and not
" <A-j>. Option+j is the character below, Option+b is the integral sign.
if has('macunix')
  " Move the current line or selection up and down.
  xnoremap ˚ :m-2<CR>gv=gv
  xnoremap ∆ :m'>+1<CR>gv=gv
  nnoremap ˚ :<C-u>m-2<CR>==
  nnoremap ∆ :<C-u>m+<CR>==

  " Option+b and Option+f jump a word back and forward, in every mode.
  nnoremap ∫ b
  nnoremap ƒ w
  xnoremap ∫ b
  xnoremap ƒ w
  inoremap ∫ <C-o>b
  inoremap ƒ <C-o>w

  " Option+Backspace deletes the word behind the cursor, as it does in a shell.
  inoremap <M-BS> <C-w>
else
  xnoremap <A-Up> :m-2<CR>gv=gv
  xnoremap <A-Down> :m'>+1<CR>gv=gv
  nnoremap <A-Up> :<C-u>m-2<CR>==
  nnoremap <A-Down> :<C-u>m+<CR>==

  nnoremap <A-b> b
  nnoremap <A-f> w
  xnoremap <A-b> b
  xnoremap <A-f> w
  inoremap <A-b> <C-o>b
  inoremap <A-f> <C-o>w
  inoremap <A-BS> <C-w>
endif

"------------------------------------------------------------
" Keymaps: insert mode {{{2

" The two completions are now separate, one key each.
"
"   Ctrl-n / Ctrl-p   move through coc's menu
"   Enter             take the coc item you moved to
"   Ctrl-l            take Copilot's ghost text
"   Ctrl-]            dismiss Copilot
"   Tab               a tab
"
" suggest.noselect leaves nothing selected until you press Ctrl-n. Enter then
" only ever accepts something you actually chose. Otherwise it is a newline.
inoremap <silent><expr> <Enter>
  \ coc#pum#visible() && coc#pum#info()['index'] >= 0
  \ ? coc#pum#confirm() : "\<C-g>u\<CR>"

imap <silent><script><expr> <C-l> copilot#Accept("\<C-l>")

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

"------------------------------------------------------------
" Functions: changed files {{{2

" Every path with uncommitted work, staged or not, plus untracked ones. The
" preview pane shows that file's diff rather than the file, which is what a
" source control panel shows.
function! s:ChangedSource() abort
  let out = []
  for line in systemlist('git status --porcelain=v1 --untracked-files=all')
    if len(line) < 4
      continue
    endif
    " A rename reads "old -> new". Keep the name the file has now.
    let path = substitute(line[3:], '^.* -> ', '', '')
    let path = substitute(path, '^"\(.*\)"$', '\1', '')
    call add(out, printf("%s\t%s", line[0:1], path))
  endfor
  return out
endfunction

function! s:ChangedSink(lines) abort
  for line in a:lines
    let parts = split(line, "\t")
    if len(parts) > 1
      execute 'tab drop' fnameescape(parts[1])
    endif
  endfor
endfunction

command! Changed call fzf#run(fzf#wrap({
  \ 'source': s:ChangedSource(),
  \ 'sink*': function('s:ChangedSink'),
  \ 'options': ['--ansi', '--multi', '--prompt', 'Changed> ',
  \             '--delimiter', "\t", '--preview-window', 'right:60%',
  \             '--preview',
  \             'if git ls-files --error-unmatch {2} >/dev/null 2>&1; then '
  \             . 'git diff --color=always HEAD -- {2} | head -500; '
  \             . 'else cat {2} | head -200; fi']}))

"------------------------------------------------------------
" Functions: folding {{{2

" Ask the language server where the folds are and leave them all open. The
" server knows a function body from an if block, which is what indent folding
" gets wrong.
function! BuildFolds() abort
  if !s:HasCoc('foldingRange')
    echohl WarningMsg | echo 'No folding provider for this filetype' | echohl None
    return
  endif
  call CocAction('fold')
  normal! zR
  echo 'Folds built. za toggles, zR opens all, zM closes all.'
endfunction

"------------------------------------------------------------
" Functions: windows and tabs {{{2

" Take this window out of its split and give it a tab of its own. <C-w>T does
" the same thing and is native, this is here so the help screen can name it.
function! WindowToTab() abort
  if winnr('$') < 2
    echohl WarningMsg | echo 'Only one window in this tab' | echohl None
    return
  endif
  wincmd T
endfunction

" The reverse. Close this tab and reopen its file as a split of the tab that
" Vim lands on, which is the one to the left.
function! TabToSplit(cmd) abort
  if tabpagenr('$') < 2
    echohl WarningMsg | echo 'Only one tab open' | echohl None
    return
  endif
  let buf = bufnr('%')
  tabclose
  execute a:cmd
  execute 'buffer' buf
endfunction

"------------------------------------------------------------
" Functions: symbol panel {{{2

" How every jump started from the panel or the right click menu opens its
" target. drop reuses a window or tab already showing the file, and 'switchbuf'
" further up is what lets it look in other tabs.
let g:symbol_open = 'tab drop'

let s:panel = {'id': 0}

" One blank line between paragraphs, none trailing.
function! s:Squeeze(lines) abort
  let out = []
  for line in a:lines
    if line =~# '^\s*$' && (empty(out) || out[-1] =~# '^\s*$')
      continue
    endif
    call add(out, line)
  endfor
  while !empty(out) && out[-1] =~# '^\s*$'
    call remove(out, -1)
  endwhile
  return out
endfunction

" Hover text arrives as markdown. A fenced block holds the signature and the doc
" comment follows it as prose. The two are returned separately so that only the
" signature is later highlighted as source. Highlighting the whole panel as Go
" gave the word "for" in a doc comment the keyword colour.
function! s:SplitHover(entries) abort
  let code = []
  let doc = []
  let fenced = 0
  for entry in type(a:entries) == v:t_list ? a:entries : []
    for line in split(entry, "\n")
      if line =~# '^\s*```'
        let fenced = !fenced
        continue
      endif
      if fenced
        call add(code, line)
        continue
      endif
      if line =~# '^\s*---\+\s*$'
        continue
      endif
      " A hover ends with a link to the symbol on a documentation site. Worth
      " having in a browser, noise in a panel that cannot follow it.
      if line =~# '^\s*\[[^]]*\]([^)]*)\s*$'
        continue
      endif
      let line = substitute(line, '\[\([^]]*\)\](\([^)]*\))', '\1', 'g')
      call add(doc, substitute(line, '`', '', 'g'))
    endfor
  endfor
  return {'code': s:Squeeze(code), 'doc': s:Squeeze(doc)}
endfunction

function! s:PanelCount(n) abort
  return a:n < 0 ? '...' : a:n
endfunction

" Builds the panel text and records where each part of it ended up, because the
" syntax rules below address those parts by line number and the signature grows
" once the server answers.
function! s:PanelLines() abort
  let lines = copy(s:panel.hover.code)
  let s:panel.code = len(lines)
  let doc = s:panel.hover.doc
  if empty(lines) && empty(doc)
    let doc = ['No documentation for ' . s:panel.word]
  endif
  if !empty(doc)
    if !empty(lines)
      call add(lines, '')
    endif
    let lines += doc
  endif
  let s:panel.doc = len(lines)
  call add(lines, '')
  call add(lines, printf('%s references   %s implementations',
    \ s:PanelCount(s:panel.refs), s:PanelCount(s:panel.impls)))
  let s:panel.counts = len(lines)
  call add(lines, '')
  call add(lines, 'd definition   y type   i implementations   r references')
  call add(lines, 'R rename       a action   c calls   j k scroll   q close')
  return lines
endfunction

" syntax include is the mechanism for embedding one language in part of a buffer.
" Every item it reads is marked contained, which is what keeps Go highlighting
" inside the signature region and out of the prose below it.
function! s:PanelSyntax() abort
  if s:panel.id == 0
    return
  endif
  let cmds = ['syntax clear']
  if !empty(s:panel.ft) && s:panel.code > 0
    call extend(cmds, [
      \ 'unlet! b:current_syntax',
      \ 'syntax include @PanelLang syntax/' . s:panel.ft . '.vim',
      \ 'unlet! b:current_syntax',
      \ printf('syntax region PanelCode start=/\%%1l/ end=/\%%%dl/ contains=@PanelLang keepend',
      \   s:panel.code + 1),
      \ ])
  endif
  call extend(cmds, [
    \ printf('syntax match PanelDoc /\%%>%dl\%%<%dl.*/', s:panel.code, s:panel.doc + 1),
    \ printf('syntax match PanelCounts /\%%%dl.*/', s:panel.counts),
    \ printf('syntax match PanelKeys /\%%>%dl.*/', s:panel.counts),
    \ ])
  for cmd in cmds
    call win_execute(s:panel.id, 'silent! ' . cmd)
  endfor
endfunction

function! s:PanelRedraw() abort
  if s:panel.id != 0 && !empty(popup_getoptions(s:panel.id))
    call popup_settext(s:panel.id, s:PanelLines())
    call s:PanelSyntax()
  endif
endfunction

function! s:PanelScroll(winid, n) abort
  let pos = popup_getpos(a:winid)
  if empty(pos)
    return
  endif
  let last = str2nr(trim(win_execute(a:winid, "echo line('$')")))
  let first = pos.firstline + a:n
  if first < 1
    let first = 1
  elseif pos.lastline + a:n > last
    let first = last + pos.firstline - pos.lastline
  endif
  call popup_setoptions(a:winid, {'firstline': max([1, first])})
endfunction

function! s:PanelFilter(winid, key) abort
  if a:key ==# 'j' || a:key ==# "\<Down>" || a:key ==# "\<ScrollWheelDown>"
    call s:PanelScroll(a:winid, a:key ==# "\<ScrollWheelDown>" ? 3 : 1)
    return 1
  elseif a:key ==# 'k' || a:key ==# "\<Up>" || a:key ==# "\<ScrollWheelUp>"
    call s:PanelScroll(a:winid, a:key ==# "\<ScrollWheelUp>" ? -3 : -1)
    return 1
  elseif a:key ==# "\<C-d>" || a:key ==# "\<PageDown>"
    call s:PanelScroll(a:winid, 5)
    return 1
  elseif a:key ==# "\<C-u>" || a:key ==# "\<PageUp>"
    call s:PanelScroll(a:winid, -5)
    return 1
  endif

  if a:key ==# 'q' || a:key ==# "\<Esc>"
    call popup_close(a:winid)
    return 1
  endif

  let jumps = {
    \ 'd': 'jumpDefinition',
    \ 'y': 'jumpTypeDefinition',
    \ 'i': 'jumpImplementation',
    \ 'D': 'jumpDeclaration',
    \ }

  if has_key(jumps, a:key)
    call popup_close(a:winid)
    call CocActionAsync(jumps[a:key], g:symbol_open)
    return 1
  elseif a:key ==# 'r'
    call popup_close(a:winid)
    call Usages()
    return 1
  elseif a:key ==# 'R'
    call popup_close(a:winid)
    call CocActionAsync('rename')
    return 1
  elseif a:key ==# 'a'
    call popup_close(a:winid)
    call CocActionAsync('codeAction', 'cursor')
    return 1
  elseif a:key ==# 'c'
    call popup_close(a:winid)
    call CocActionAsync('showIncomingCalls')
    return 1
  endif

  " Anything else is swallowed and changes nothing. Closing on every stray key
  " is what made the panel vanish when it was opened from the menu, because the
  " Enter that picked the menu item arrived here straight afterwards. Only q
  " and Esc close it now.
  return 1
endfunction

" One window describing whatever is under the cursor: signature, doc comment,
" how many references and implementations it has, and a key for each action
" that applies to it.
function! SymbolPanel() abort
  let word = expand('<cword>')
  if empty(word)
    echohl WarningMsg | echo 'No symbol under cursor' | echohl None
    return
  endif
  if !s:HasCoc('hover')
    echohl WarningMsg | echo 'No language server for this buffer' | echohl None
    return
  endif

  if s:panel.id != 0
    call popup_close(s:panel.id)
  endif
  let s:panel = {'id': 0, 'word': word, 'ft': &filetype,
    \ 'hover': {'code': [], 'doc': ['Loading...']},
    \ 'code': 0, 'doc': 1, 'counts': 3, 'refs': -1, 'impls': -1}

  " popup_create rather than popup_atcursor: atcursor defaults to moved 'WORD',
  " which closes the panel as soon as the cursor leaves the word it was opened
  " on. This one stays until a key closes it.
  let s:panel.id = popup_create(s:PanelLines(), {
    \ 'title': ' ' . word . ' ',
    \ 'pos': 'botleft',
    \ 'line': 'cursor-1',
    \ 'col': 'cursor',
    \ 'border': [],
    \ 'padding': [0, 1, 0, 1],
    \ 'minwidth': 60,
    \ 'maxwidth': 100,
    \ 'maxheight': 24,
    \ 'scrollbar': 1,
    \ 'mapping': 0,
    \ 'filter': function('s:PanelFilter'),
    \ })

  call s:PanelSyntax()

  call CocActionAsync('getHover', {e, r -> s:PanelSetHover(r)})
  call CocActionAsync('references', {e, r -> s:PanelSetCount('refs', r)})
  call CocActionAsync('implementations', {e, r -> s:PanelSetCount('impls', r)})
endfunction

function! s:PanelSetHover(result) abort
  let s:panel.hover = s:SplitHover(a:result)
  call s:PanelRedraw()
endfunction

function! s:PanelSetCount(field, result) abort
  let s:panel[a:field] = type(a:result) == v:t_list ? len(a:result) : 0
  call s:PanelRedraw()
endfunction

"------------------------------------------------------------
" Functions: pointer hover {{{2

" Documentation under the mouse pointer, without clicking. Warp added mouse
" motion reporting in January 2024 and this Vim has +balloon_eval_term, which
" together are what make it possible at all. coc has no balloon support of its
" own. The request goes straight to the language server for the position under
" the pointer, and the balloon is filled in when the reply lands.

function! s:BalloonService(bufnr) abort
  let ft = getbufvar(a:bufnr, '&filetype')
  for service in CocAction('services')
    if service.state ==# 'running' && index(service.languageIds, ft) >= 0
      return service.id
    endif
  endfor
  return ''
endfunction

function! s:BalloonShow(err, result) abort
  if !empty(a:err) || type(a:result) != v:t_dict
    return
  endif
  let contents = get(a:result, 'contents', '')
  if type(contents) == v:t_dict
    let text = get(contents, 'value', '')
  elseif type(contents) == v:t_list
    let text = join(map(copy(contents),
      \ 'type(v:val) == v:t_dict ? get(v:val, "value", "") : v:val'), "\n")
  else
    let text = contents
  endif
  " A balloon has no syntax of its own. The two halves are flattened back
  " together for it.
  let hover = s:SplitHover([text])
  let lines = hover.code + (empty(hover.code) || empty(hover.doc) ? [] : ['']) + hover.doc
  if !empty(lines)
    call balloon_show(lines)
  endif
endfunction

function! BalloonHover() abort
  let id = s:BalloonService(v:beval_bufnr)
  if empty(id)
    return ''
  endif
  call CocRequestAsync(id, 'textDocument/hover', {
    \ 'textDocument': {'uri': 'file://' . fnamemodify(bufname(v:beval_bufnr), ':p')},
    \ 'position': {'line': v:beval_lnum - 1, 'character': v:beval_col - 1},
    \ }, function('s:BalloonShow'))
  " Nothing to show yet. The callback fills the balloon in.
  return ''
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
  echo printf('Usages of %s: %d refs, %d impls, %d text%s%s',
    \ s:usages.word, s:usages.ref, s:usages.impl, len(s:usages.rg),
    \ s:usages.dropped > 0 ? printf('  (%d outside or generated)', s:usages.dropped) : '',
    \ s:usages.pending > 0 ? '  (searching)' : '')
endfunction

" One rule about what belongs in results, applied to every source.
"
" ripgrep gets this for free: it searches under the working directory and is
" given g:rg_exclude_args. The language server does not. It answers with
" whatever it knows, which for a generated proto type means the .pb.go file the
" type is declared in, and for a concrete type means every interface in the Go
" standard library that the type happens to satisfy. Those are correct answers
" to a question nobody asked, and they used to arrive at the top of the list.
let s:exclude_re = map(copy(g:search_exclude), 'glob2regpat(v:val)')

function! s:Excluded(path) abort
  let tail = fnamemodify(a:path, ':t')
  for re in s:exclude_re
    if tail =~# re
      return 1
    endif
  endfor
  return 0
endfunction

function! s:WorkspaceRoot() abort
  let root = trim(system('git rev-parse --show-toplevel'))
  return v:shell_error == 0 && !empty(root) ? root : getcwd()
endfunction

function! s:Keep(abspath) abort
  if s:Excluded(a:abspath)
    return 0
  endif
  return stridx(a:abspath, s:usages.root . '/') == 0
endfunction

" ripgrep already reports the line text for every hit, and every
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

  " An implementer of an interface almost never spells the interface name out as
  " a whole word. ripgrep cannot have reported those lines. Fill them in from
  " the language server, reading one line out of each file. Everything here has
  " already passed s:Keep. Only a handful reach this loop.
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
  " is chosen. Feeding it a file avoids re-running the search. The label names
  " the file being previewed, which fzf.vim does not set on its own.
  call fzf#vim#grep('cat ' . shellescape(tmp),
    \ fzf#vim#with_preview({'options': [
    \   '--prompt', 'Usages(' . s:usages.word . ')> ',
    \   '--preview-label-pos', '2:top',
    \   '--preview-label', '{1}']}), 0)
endfunction

function! s:CollectLsp(kind, gen, err, result) abort
  " A slow server can answer after the next search has already started. Without
  " this the old answers merge into the new search's results.
  if a:gen != s:usages.gen
    return
  endif
  for loc in type(a:result) == v:t_list ? a:result : []
    let abs = fnamemodify(s:Uri2Path(loc.uri), ':p')
    if !s:Keep(abs)
      let s:usages.dropped += 1
      continue
    endif
    let path = fnamemodify(abs, ':.')
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

function! s:CollectRg(gen, job, status) abort
  if a:gen != s:usages.gen
    return
  endif
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
  let s:usages.gen += 1
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

  let gen = get(s:usages, 'gen', 0) + 1
  let s:usages = {'word': word, 'marks': {}, 'locs': [], 'seen': {}, 'rg': [],
    \ 'ref': 0, 'impl': 0, 'dropped': 0, 'pending': 1, 'gen': gen,
    \ 'tmp': tempname(), 'root': s:WorkspaceRoot()}

  for [kind, action, feature] in [
    \ ['ref', 'references', 'reference'],
    \ ['impl', 'implementations', 'implementation']]
    if s:HasCoc(feature)
      let s:usages.pending += 1
      call CocActionAsync(action, function('s:CollectLsp', [kind, gen]))
    endif
  endfor

  " The trailing '.' and the null stdin both matter. A job's stdin is a pipe
  " rather than a terminal, and ripgrep with no path argument reads stdin when
  " it is not a terminal. It would find nothing and exit 1.
  let s:usages.job = job_start(
    \ ['rg', '--vimgrep', '--word-regexp', '--fixed-strings']
    \   + g:rg_exclude_args + ['--', word, '.'],
    \ {'in_io': 'null', 'out_io': 'file', 'out_name': s:usages.tmp,
    \  'err_io': 'null', 'exit_cb': function('s:CollectRg', [gen])})

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
      call CocActionAsync('jumpDefinition', g:symbol_open)
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
" Functions: session and reload {{{2

" Sourcing this file again applies all of it to the running Vim. Every autocmd
" in it is inside an augroup that begins with autocmd!, which is what stops a
" reload from installing a second copy of each one. A new Plug line is the one
" thing a reload cannot pick up, because vim-plug reads those only at startup.
"
" A command rather than a function, because Vim refuses to redefine a function
" that is on the stack (E127). Reloading from inside one aborted the source at
" that definition and left everything below it stale.
"
" The bare silent quiets airline, which reapplies its theme noisily on every
" reload. A silent! would also swallow real errors.
command! ReloadConfig silent source $MYVIMRC | echo 'Reloaded ' . $MYVIMRC

let s:session_dir = expand('~/.vim/sessions')

" One saved layout per repository rather than per directory. Opening Vim in a
" subdirectory then finds the same layout as opening it at the root. The path
" becomes the file name, with the separators replaced, because two repositories
" can share a basename.
function! s:SessionFile() abort
  return s:session_dir . '/'
    \ . substitute(s:WorkspaceRoot()[1:], '/', '%', 'g') . '.vim'
endfunction

function! SessionSave() abort
  if !isdirectory(s:session_dir)
    call mkdir(s:session_dir, 'p')
  endif
  " NERDTree does not survive the round trip. The session records its window and
  " restores it holding an empty buffer. Close it before the write.
  if exists('g:NERDTree') && g:NERDTree.IsOpen()
    NERDTreeClose
  endif
  execute 'mksession! ' . fnameescape(s:SessionFile())
  " Short on purpose. A message wider than the command line stops Vim on a
  " hit-enter prompt, and a workspace path is easily that wide.
  echo 'Layout saved'
endfunction

function! SessionLoad() abort
  let file = s:SessionFile()
  if !filereadable(file)
    echohl WarningMsg | echo 'No saved layout here' | echohl None
    return
  endif
  execute 'source ' . fnameescape(file)
endfunction

function! SessionDelete() abort
  let file = s:SessionFile()
  if !filereadable(file)
    echohl WarningMsg | echo 'No saved layout here' | echohl None
    return
  endif
  call delete(file)
  echo 'Layout forgotten'
endfunction

" Exit writes the layout back only when this Vim saved or restored that layout in
" the first place, which v:this_session is the record of. Keying off the file
" existing instead meant that opening one named file in a tracked repository
" overwrote the layout with a single window on the way out.
function! s:SessionAutoSave() abort
  if v:this_session ==# s:SessionFile()
    silent call SessionSave()
  endif
endfunction

" Only for a bare vim. Naming a file, piping into stdin or passing -S all say
" what to open, and none of them should be overruled by a saved layout.
function! s:SessionAutoLoad() abort
  if argc() != 0 || !empty(v:this_session) || !filereadable(s:SessionFile())
    return
  endif
  call SessionLoad()
endfunction

augroup vimrc_session
    autocmd!
    autocmd VimLeavePre * call s:SessionAutoSave()
    autocmd VimEnter * nested call s:SessionAutoLoad()
augroup END

command! SessionSave call SessionSave()
command! SessionLoad call SessionLoad()
command! SessionDelete call SessionDelete()

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
    \ '    K             symbol panel, with its own action keys',
    \ '    gK            plain hover',
    \ '    double-click  symbol panel on what was clicked',
    \ '    Ctrl-click    declaration, or usages when already on it',
    \ '    right-click / <Space>m   menu of all of the above',
    \ '    Ctrl-rightclick / Ctrl-o / Ctrl-i   back, back, forward',
    \ '    Jumps open in a tab, reusing one already showing the file.',
    \ '',
    \ '  INSIDE THE SYMBOL PANEL (K)',
    \ '    d definition   y type   i implementations   r references',
    \ '    R rename       a action   c calls   j k scroll   q close',
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
    \ '  GIT                               WINDOW (within one tab)',
    \ '    gc  changed files, with diffs     wh wj wk wl  move window',
    \ '    gs  status (fugitive)             wv ws        vsplit, split',
    \ '    gm  status (magit)                wc wo        close, only',
    \ '    gb  blame                         w=           equalize',
    \ '    gd  diff split                    Ctrl-hjkl    move focus',
    \ '    gl  commits                       Ctrl-arrows  resize',
    \ '    gL  commits for this file         wt           window out to a tab',
    \ '    gf  files changed vs HEAD         wV wS        tab back to a split',
    \ '    gp gu gS  preview, undo, stage hunk',
    \ '',
    \ '  TAB                               FOLD',
    \ '    gt gT     next, previous           zf   build folds from the server',
    \ '    ]T [T     move this tab            za   toggle the fold here',
    \ '    tn tc to  new, close, only         zR   open every fold',
    \ '    1-8       go to tab                zM   close every fold',
    \ '    9         last tab                 zo zc  open, close',
    \ '                                       zj zk  next, previous fold',
    \ '',
    \ '  BUFFER vs TAB',
    \ '    A buffer is an open file. A window shows one. A tab holds a layout',
    \ '    of windows. Opening a file replaces what a window shows, and the',
    \ '    old buffer stays loaded but hidden. The bar on top lists tabs only.',
    \ '    ]b [b  cycle buffers    <Space><Space>  back to the previous file',
    \ '    fb     pick a buffer    :ls             every loaded buffer',
    \ '',
    \ '  COMPLETION (insert mode)',
    \ '    Ctrl-n Ctrl-p   move through the suggestion menu',
    \ '    Enter           take the item you moved to (nothing is preselected)',
    \ '    Ctrl-l          take Copilot ghost text     Ctrl-] dismiss it',
    \ '    Ctrl-Space      ask for suggestions         Tab    stays a tab',
    \ '',
    \ '  SESSION (one saved layout per repository)',
    \ '    ss  save this layout    sl  restore it    sd  forget it',
    \ '    Once saved, a bare vim in this repository reopens that layout and',
    \ '    quitting writes it back. Opening a named file leaves it untouched.',
    \ '',
    \ '  OTHER',
    \ '    y Y p P   system clipboard      Opt-j Opt-k  move line or selection',
    \ '    /         clear highlight       Opt-b Opt-f  jump a word',
    \ '    e Ctrl-b  file tree             Opt-BS       delete word back',
    \ '    ?         this screen           :Term        open fish',
    \ '    R         reload this vimrc (a new Plug line still needs a restart)',
    \ '',
    \ '  Right click for a menu of the actions above at the cursor.',
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
endfunction

"------------------------------------------------------------
