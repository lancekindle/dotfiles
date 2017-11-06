" ============== VUNDLE STUFF BEGINS ========================================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
" ================== ADD PLUGINS HERE ==================================
" You must run :PluginInstall after adding a plugin here
" (run :PluginInstall! to update plugins)
Plugin 'VundleVim/Vundle.vim'
Plugin 'rust-lang/rust.vim'   " install rust highlighting
Plugin 'Valloric/YouCompleteMe' " code completion
" to recompile or install for first time:
" cd ~/.vim/bundle/YouCompleteMe
" python2 install.py
Plugin 'suan/vim-instant-markdown' " markdown viewer
Plugin 'scrooloose/syntastic' "syntax checking plugin
" Plugin 'scrooloose/nerdcommenter' "toggle block commenting using \c-<space>
Plugin 'tpope/vim-commentary'   "toggle comment using gc, paragraph with gcap
" Filetree view and open / edit in newtabs using t and T
Plugin 'scrooloose/nerdtree'
" Nerdtree plugin for better display
Bundle 'jistr/vim-nerdtree-tabs'
"prevent tabular hell when clipboard pasting
Plugin 'ConradIrwin/vim-bracketed-paste' "toggle paste mode when pasting
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim' "fuzzy search filesystem for file to edit
" Useful for editting files within a complex-hierarchy project
Plugin 'tpope/vim-fugitive' " git commands
Plugin 'sickill/vim-monokai' " colorscheme
Plugin 'tomasr/molokai' " colorscheme 2 (for assembly)
Plugin 'vim-airline/vim-airline' " stylish status line
Plugin 'fatih/vim-go'  " go development with vim
Plugin 'airblade/vim-gitgutter'  " git +,- marks during file editting
Plugin 'natw/keyboard_cat.vim'  " load file to 'type' using :PlayMeOff <file>
" " ================= END VUNDLE STUFF =======================================

filetype plugin indent on " end general vundle config
" Turn of swap files and backups
set nobackup
set noswapfile
set nowritebackup

" " ================= BEGIN PLUGIN CONFIG ===================================
" set a global YouCompleteMe config file for syntax checking
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" turn off confirmation of ycm_extra_conf
let g:ycm_confirm_extra_conf = 0

" blacklist certain filetype from being auto-completed
let g:ycm_filetype_blacklist = {
      \ 'asm' : 1, 'inc' : 1,
      \}
let g:syntastic_mode_map = { 'passive_filetypes': ['asm', 'inc'] }
let g:syntastic_disabled_filetypes=['asm', 'inc']
let g:syntastic_asm_checkers=['']  "I think this last one did it
let g:syntastic_inc_checkers=['']

" YouCompleteMe use the system installation of python2
let g:ycm_path_to_python_interpreter = '/usr/bin/python2'

""use python3 for syntax checking
let g:syntastic_python_python_exec = 'python3'

"some useful syntastic options
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
            \ "mode": "active",
            \ "passive_filetypes": ["python"] } " do not actively check python
" hide certain files in NERDTree
let NERDTreeIgnore = ['\.pyc$', '\.sqlite3$', '\.png$', '\.jpg$']
" Ensure NERDTree window size is sufficiently small
let NERDTreeWinSize=20

" " ================= END PLUGIN CONFIG ===================================

" ======================= [ Visual (Look) ] ===========================
""enable color syntax highlighting
syntax enable
"use monokai colorscheme
colorscheme monokai
" show trailing whitespace
set list
set listchars=trail:.,extends:#,nbsp:.,tab:▷\ 
"relative line-numbers to cursor position, but Cursor shows absolute line#
set number
set relativenumber
"when in insert mode, remove all linenumbers entirely. This has the added
"benefit that copying from vim is much easier when in insert mode
"when in normal mode, show hybrid numbers
"also toggle display of trailing whitespace and tabs
autocmd InsertEnter * silent!:set nonumber norelativenumber list
autocmd InsertEnter * silent!:GitGutterSignsDisable
autocmd InsertLeave * silent!:set number relativenumber nolist
autocmd InsertLeave * silent!:GitGutterSignsEnable
"cursor line and column position
set ruler
"vertical bar on column 80
set colorcolumn=80
hi ColorColumn ctermbg=240
""highlight matches when searching
set hlsearch
""always show the status line
set laststatus=2
""override terminal colors to 256
set t_Co=256

" ========================= [ Behavior (Feel) ] ========================
"when ignorecase and smartcase are both on, searches are case-insensitive
"unless it contains an uppercase letter
set smartcase
set ignorecase
""incrementally search for matches
set incsearch
" set smart-indenting (like matching previous line indentation level)
set autoindent
set smartindent
" replace tabs with spaces (aka softtabstop width) when inserting tabs
set expandtab
" tabs and indenting all look like 4 width/columns
" NOTE: python file-type sets custom tabbing behavior (tabstop=8), which makes
" tabs in python files stand out. However, if a file uses tabs throughout, I
" want to edit that file in the same style using tabs. Function SetTabOrSpaces
" (below) will reset tab behavior and set noexpandtab as desired in this case
set tabstop=4 softtabstop=4 shiftwidth=4
"allow backspacing over more than current line
set backspace=indent,eol,start

" ================== [ Keyboard Remaps ] =============================
"remap Y to copy from cursor to end of line (to mimick D behavior)
nnoremap Y y$
" Map space to leader  (which used to be   \  --aka backslash)
map <space> <leader>
" For compatability, map double space to double leader.
map <space><space> <leader><leader>
"auto-correct :Q to :q and :W to :w
:command WQ wq
:command Wq wq
:command W w
:command Q q
"remap pageup and pagedown to vim's 2xctrl-u and 2xctrl-d respectively
"for more consistent text traversal
"<silent> so that they don't post commands to history
"<C-O> is vim's prefix before executing a C- command in insert mode
nmap <silent> <PageDown> <C-D><C-D>
nmap <silent> <PageUp> <C-U><C-U>
imap <silent> <PageDown> <C-O><C-D><C-O><C-D>
imap <silent> <PageUp> <C-O><C-U><C-O><C-U>
vmap <silent> <PageDown> <C-D><C-D>
vmap <silent> <PageUp> <C-U><C-U>
" Remap window movement
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
"remap F12 to strip whitespaces
nnoremap <silent> <F12> :call <SID>StripTrailingWhitespaces()<CR>
" Toggle Nerdtree file view on and off
map <leader>f <plug>NERDTreeTabsToggle<CR>



" Dvorak-Qwerty mixing. When in insert mode (or writing commands) use dvorak.
" when in normal mode (including keyboad shortcuts) use qwerty layout.  This
" makes it so that common keys like dd and hjkl behave as expected according
" to qwerty-based muscle memory, but I can still type with dvorak. This script
" only runs when $DVQP_KEYBOARD_ENABLED is set.
" HOW THIS WORKS: each "let &langmap" maps a row of a dvorak keys to a row of
" of qwerty keys (using the ';' as a divider between the two groups. This
" mapping is only used when in normal mode. Otherwise, command mode and insert
" mode use the existing keyboard layout (dvorak)
if $DVQP_KEYBOARD_ENABLED == 1
    "source ~/.vim/dvorak_qwerty_noremaps.vim
    echo "enabling dvorak keyboard"
endif

""""""""""""""""""""""""""""""""""""""""""""""
 """"""""""""functions mapped to keys"""""""""""
""""""""""""""""""""""""""""""""""""""""""""""
"http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""
  """""""""""filetype specific config""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""

" choose to use tabs or spaces after opening a file
autocmd BufReadPost * call SetTabOrSpaces()
function SetTabOrSpaces()
    " Determines whether to use spaces or tabs on the current buffer.
    if getfsize(bufname("%")) > 256000
        " File is very large, just use the default.
        return
    endif

    let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^ "'))

    setlocal expandtab
    if numTabs > numSpaces
        " do not replace tabs with spaces to stay consistent with current style
        setlocal noexpandtab
        " reset tab widths for consistency
        setlocal tabstop=4 softtabstop=4 shiftwidth=4
        "echo "WARNING! File uses tabs instead of spaces. Defaulting to tabs"
        " asm options may want to change tabstops (this function gets called
        " AFTER asm, so we must call it again to set options)
        if (&ft == "asm" || &ft == "inc" || &ft == "gbz80")
            silent call SetGameboyAsmOptions()
        endif
    endif
endfunction


"autocmd == a command that is automatically ran
"silent == prevent output when this gets called
autocmd FileType python silent call SetPythonOptions()
function SetPythonOptions()
    " set desired text width to 72 (for wrapping comments)
    set textwidth=72
    "do NOT automatically wrap text. Must highlight and press GQ
    set formatoptions-=t
    " can run and interact with code by pressing <F5>
    " in normal mode, do NOT save file before running
    " put "" around %:p (filename) for file-paths with spaces included
    nmap <F5> :silent !tmux split-window -h 'python3 -i "%:p"'<CR>
    " allow running in python2 with <F2>
    nmap <F2> :silent !tmux split-window -h 'python2 -i "%:p"'<CR>
    " in insert mode, save file before running
    imap <F5> <Esc>:w<CR>:SyntasticCheck<CR>:silent !tmux split-window -h 'python3 -i "%:p"'<CR>
    nmap <F6> :silent !tmux split-window -h 'python3 -m pdb "%:p"'<CR>
    " interestingly, I can't use /usr/bin/env which would allow the script to
    " optionally specify python version. But env doesn't allow arguments to
    " pass, which means I cannot run interactive python. so it stays as python3
endfunction

autocmd FileType rust silent call SetRustOptions()
function SetRustOptions()
    " can run code and see output by pressing <F5>
    " in normal mode, do NOT save file before running
    nmap <F5> :silent !tmux split-window -h 'cargo run --release; read -p "press [enter] to close"'<CR>
    " in insert mode, save file before running
    imap <F5> <Esc>:w<CR>:silent !tmux split-window -h 'cargo run --release; read -p "press [enter] to close"'<CR>
    "nmap is keybinding in normal mode, imap is bindings in insert mode
    "<Esc> exits insert mode
endfunction

autocmd FileType sh silent call SetShellScriptOptions()
function SetShellScriptOptions()
    " run shell script (.sh) by pressing F5. Run it as sudo pressing F2
    nmap <F5> :silent !tmux split-window -h '"%:p"; read -p "[enter] to close. F2 to run as sudo"'<CR>
    " run shell script (.sh) as sudo by pressing F2
    nmap <F2> :silent !tmux split-window -h 'sudo "%:p"; read -p "[enter] to close"'<CR>
endfunction

autocmd FileType go silent call SetGoLangOptions()
function SetGoLangOptions()
    " run go script (.go) by pressing F5.
    nmap <F5> :GoRun<CR>
endfunction

autocmd FileType c silent call SetCOptions()
function SetCOptions()
    " run go script (.go) by pressing F5.
    nmap <F5> :silent !tmux split-window -h 'gcc "%:p"; ./a.out; read -p "[enter] to close."'<CR>
    nmap <F6> :silent !tmux split-window -h '~/bin/gbdk/bin/lcc -o a.gb "%:p"; ~/bin/gb_emulate.sh a.gb;'<CR>
endfunction

autocmd BufNewFile,BufRead *.asm,*.inc set filetype=gbz80
autocmd FileType gbz80 silent call SetGameboyAsmOptions()
function SetGameboyAsmOptions()
    " toggle (Off) syntastic checking
    let g:ycm_auto_trigger=0 " turn off YouCompleteMe <tab> completion
    colorscheme molokai
    " molokai colorscheme fix for matching parenthesis
    hi MatchParen      ctermfg=208 ctermbg=233 cterm=bold
    set noshowmatch "do not auto-match parenthesis (molokai colorscheme fix)
    " do not replace tabs with spaces to stay consistent with current style
    setlocal noexpandtab
    " reset tab widths for consistency
    setlocal tabstop=8 softtabstop=0 shiftwidth=8
    set nolist  "don't highlight non-text characters
    source ~/.vim/syntax/gbz80.vim "set up highlighting
    " run by pressing F5: compile gameboy game and run it
    nmap <F5> :silent !tmux split-window -h '~/bin/gameboy/gb_build_and_play.sh "%:r"'<CR>
endfunction

autocmd FileType ruby silent call SetRubyOptions()
function SetRubyOptions()
    " set desired text width to 72 (for wrapping comments)
    set textwidth=72
    "do NOT automatically wrap text. Must highlight and press GQ
    set formatoptions-=t
    nmap <F5> :silent !tmux split-window -h 'irb --simple-prompt -r "%:p"'<CR>
    " https://stackoverflow.com/a/27870513
    " https://stackoverflow.com/a/3292515
endfunction
