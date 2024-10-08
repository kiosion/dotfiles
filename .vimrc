set shell=/bin/bash

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

" raise max mem for ale/coc/ripgrep
set mmp=5000

" vim-svelte-plugin
let g:svelte_preprocessor_tags = [
  \ { 'name': 'scss', 'tag': 'style' },
  \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' },
  \ ]

let g:svelte_preprocessors = ['typescript', 'scss']

" fzf
let $FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules --exclude dist --exclude build'

" Copilot
let g:copilot_ignore_node_version = 1

" ALE
let g:ale_linters = {
 \ 'javascript': ['prettier', 'eslint'],
 \ 'typescript': ['prettier', 'eslint'],
 \ 'typescriptreact': ['prettier', 'eslint'],
 \ 'javascriptreact': ['prettier', 'eslint'],
 \ 'svelte': ['prettier', 'eslint'],
 \ 'html': ['prettier'],
 \ 'css': ['prettier'],
 \ 'scss': ['prettier'],
 \ 'go': ['golangci-lint', 'gofmt', 'gopls'],
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
 \ 'go': ['gofmt', 'gopls'],
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

" Airline   
let g:airline#extensions#tabline#enabled = 1    
let g:airline#extensions#tabline#formatter = 'unique_tail'    
let g:airline#extensions#hunks#enabled=0    
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#branch#icon=''
  
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
"
" These options and commands enable some very useful features in Vim, that 
" no user should have to live without.
"
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible
"
" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
if has('filetype')
    filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
    syntax on
endif

"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files 
" in the same editor window. Users can use multiple split windows or multiple 
" tab pages to edit multiple files, but it is still best to enable an option to 
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same 
" window and switch from an unsaved buffer without saving it first. Also 
" allows you to keep an undo history for multiple files when re-using the same 
" window in this way. Note that using persistent undo also lets you undo in 
" multiple files even in the same window, but is less efficient and is actually 
" designed for keeping undo history after closing Vim entirely. Vim will complain 
" if you try to quit without saving, and swap files will keep you safe if your 
" computer crashes.
"set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
set confirm
" set autowriteall

" Better command-line completion
set wildmenu
"
" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Modelines have historically been a source of security vulnerabilities.
" As such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Configure default ':term' opts
set shell=fish

" Fold by syntax, not manually or indent
set foldmethod=syntax

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

 " Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled,keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=1

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
if has('mouse')
    set mouse=a
endif

" Set the command window height to 2 lines, to avoid many cases of having to
" press <Enter> to continue"
set cmdheight=1

" Display line numbers on the left (nu for normal, rnu for rel, both for mix)
set nu

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Collapse open split windows to just 1 line
set wmh=0


"------------------------------------------------------------
" Indentation options {{{1
" 
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set shiftwidth=4
"set tabstop=4

"------------------------------------------------------------
" Scroll options {{{1
set scrolloff=5

" Smooth scrolling mappings
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
inoremap <C-e> <Esc>5<C-e>i
inoremap <C-y> <Esc>5<C-y>i
vnoremap <C-e> 5<C-e>
vnoremap <C-y> 5<C-y>

"------------------------------------------------------------
" Mappings {{{1

let mapleader = ","

" Useful mappings

" Toggle fold of current line's code block
"nnoremap <Leader>z za

"nnoremap <Esc> k

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Copy to system clipboard in visual mode
vnoremap <Leader>y "+y
vnoremap <Leader>Y "+yg_

" Paste from system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" pane/split stuff

" Map Ctrl + <hjkl> to move between split view windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" Swap horizontal splits
nnoremap <Leader>wj :wincmd J<CR>
nnoremap <Leader>wk :wincmd K<CR>

" Swap vertical splits
nnoremap <Leader>wh :wincmd H<CR>
nnoremap <Leader>wl :wincmd L<CR>

" Resize split horizontally
nnoremap <C-Right> <C-w>>
nnoremap <C-Left> <C-w><

" Resize split vertically
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-

" line manipulation stuff

if has('macunix')
  " Move selected lines up (visual) (Option+K)
  xnoremap ˚ :m-2<CR>gv=gv

  " Move selected lines down (visual) (Option+J)
  xnoremap ∆ :m'>+1<CR>gv=gv

  " Move current line up (Option+K)
  nnoremap ˚ :<C-u>m-2<CR>==

  " Move current line down (Option+J)
  nnoremap ∆ :<C-u>m+<CR>==
else 
  " TODO: Why don't A-J/K work on linux? Not already bound or anything...
  " Move selected lines up (visual) (Alt+Up)
  xnoremap <A-Up> :m-2<CR>gv=gv

  " Move selected lines down (visual) (Alt+Down)
  xnoremap <A-Down> :m'>+1<CR>gv=gv

  " Move selected line up (Alt+Up)
  nnoremap <A-Up> :<C-u>m-2<CR>==

  " Move selected line down (Alt+Down)
  nnoremap <A-Down> :<C-u>m+<CR>==
endif

" tab stuff

" shadow gr to act as gT and move to the previous tab
nnoremap gr gT

" Move to the next tab
nnoremap <Leader>l :tabnext<CR>
" Move to the previous tab
nnoremap <Leader>h :tabprevious<CR>
" Move to the first tab
nnoremap <Leader>1 :tabfirst<CR>
" Move to the last tab
nnoremap <Leader>$ :tablast<CR>
" Move to a specific tab number
nnoremap <Leader>2 :tabn 2<CR>
nnoremap <Leader>3 :tabn 3<CR>
nnoremap <Leader>4 :tabn 4<CR>
nnoremap <Leader>5 :tabn 5<CR>
nnoremap <Leader>6 :tabn 6<CR>
nnoremap <Leader>7 :tabn 7<CR>
nnoremap <Leader>8 :tabn 8<CR>
nnoremap <Leader>9 :tabn 9<CR>
nnoremap <Leader>0 :tabn 10<CR>

" Move current tab to the right
nnoremap <Leader>] :tabm +1<CR>
" Move current tab to the left
nnoremap <Leader>[ :tabm -1<CR>

" fzf stuff

" Run :Files command with <Leader>fn
nnoremap <Leader>fn :Files<CR>
vnoremap <Leader>fn <Esc>:Files<CR>

" Run :Rg command with <Leader>r
nnoremap <Leader>rg :Rg<CR>
vnoremap <Leader>rg <Esc>:Rg<CR>

" Remap :Rg to only search file contents and ignore names/extensions
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Rg current word under cursor
nnoremap <Leader>rw :Rg <C-r><C-w><CR>

" ALE / coc stuff

" Move between ALE errors/warnings
nnoremap <Leader>aj :ALENext<CR>
nnoremap <Leader>ak :ALEPrevious<CR>

" Jump to definition w/ coc.nvim on gD
nnoremap gD <Plug>(coc-definition)
" Jump to definition in new split tab on gd
nnoremap gd :vsplit<CR><C-w>w<Plug>(coc-definition)

" Hover over definition with K
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Scroll within active popup via <C-j> and <C-k> - if no popups, use ctrl-j/k
" to switch between horiz splits
nnoremap <silent><expr> <C-j> PopupVisible() ? ScrollPopup(3) : "\<C-W>j"
nnoremap <silent><expr> <C-k> PopupVisible() ? ScrollPopup(-3) : "\<C-W>k"

function! PopupVisible()
    return len(popup_list()) > 0
endfunction

function! ScrollPopup(nlines)
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

" Accept completion with Enter if coc is active, otherwise just Enter
inoremap <silent><expr> <Enter> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" Close coc with <Esc> if active, otherwise just <Esc>
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#close() : "\<Esc>"

" NERDTree stuff (TODO: move to new section, keybinds is getting unwieldy)

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! CheckIfCurrentBufferIsFile()
  return strlen(expand('%')) > 0
endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && CheckIfCurrentBufferIsFile() && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()

function! ToggleTree()
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

" Toggle NERDTree with Ctrl + B
nmap <C-b> :call ToggleTree()<CR>

"------------------------------------------------------------

