" ============== VUNDLE STUFF BEGINS ========================================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
" ================== ADD PLUGINS HERE ==================================
" You must run :PluginInstall after adding a plugin here
Plugin 'VundleVim/Vundle.vim'
Plugin 'rust-lang/rust.vim'   " install rust highlighting
Plugin 'Valloric/YouCompleteMe' " code completion
" to recompile or install for first time:
" cd ~/.vim/bundle/YouCompleteMe
" python2 install.py
Plugin 'suan/vim-instant-markdown' " markdown viewer
Plugin 'scrooloose/syntastic' "syntax checking plugin
Plugin 'scrooloose/nerdcommenter' "toggle block commenting using \c-<space>
"prevent tabular hell when clipboard pasting
Plugin 'ConradIrwin/vim-bracketed-paste' "toggle paste mode when pasting
" fuzzy search and edit files within current directory.
" Useful for editting files within a complex-hierarchy project
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-fugitive' " git commands
Plugin 'sickill/vim-monokai' " colorscheme
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
"
"
" "
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" auto-approve removal
" "
     " " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line
" " All of your Plugins must be added before the following line
" " ================= END VUNDLE STUFF =======================================

filetype plugin indent on " end general vundle config

" " ================= BEGIN PLUGIN CONFIG ===================================
" set a global YouCompleteMe config file for syntax checking
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" turn off confirmation of ycm_extra_conf
let g:ycm_confirm_extra_conf = 0

"let YouCompleteMe use the system installation of python2
let g:ycm_path_to_python_interpreter = '/usr/bin/python2'

""use python3 for syntax checking
let g:syntastic_python_python_exec = 'python3'

"some useful syntastic options
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
            \ "mode": "active",
            \ "passive_filetypes": ["python"] }

" " ================= END PLUGIN CONFIG ===================================


" set smart-indenting (like matching previous line indentation level)
set autoindent
set smartindent
" replace tabs with spaces (aka softtabstop width) when inserting tabs
set expandtab
" tabs and indenting all look like 4 width/columns
set tabstop=4 softtabstop=4 shiftwidth=4
" NOTE: python file-type sets custom tabbing behavior (tabstop=8), which makes
" tabs in python files stand out. However, if a file uses tabs throughout, I
" want to edit that file in the same style using tabs. Function SetTabOrSpaces
" (below) will reset tab behavior and set noexpandtab as desired in this case

"ignore case of searches if all lowercase, else case sensitive(like normal)
set smartcase
set ignorecase

""highlight matches when searching
set hlsearch

""incrementally search for matches
set incsearch

"relative line-numbers except at line where cursor resides, which shows
"absolute number. (aka hybrid numbers)
set number
set relativenumber
"when in insert mode, remove all linenumbers entirely. This has the added
"benefit that copying from vim is much easier when in insert mode
"when in normal mode, show hybrid numbers
autocmd InsertEnter * silent!:set nonumber norelativenumber
autocmd InsertLeave * silent!:set number relativenumber

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

""enable colors
syntax enable
"use monokai colorscheme
colorscheme monokai

"allow backspacing over more than current line
set backspace=indent,eol,start

" Turn of swap files and backups
set nobackup
set noswapfile
set nowritebackup

"Ctrl+Backspace will delete word. (only works in terminal that generates a
"C-H event from C-BS (like xterm). Terminator DOES NOT WORK with this
inoremap <C-H> <C-w>

""override terminal colors to 256
set t_Co=256

"cursor line and column position
set ruler

"vertical bar on column 80
set colorcolumn=80
hi ColorColumn ctermbg=240

""always show the status line
set laststatus=2

"remap F1 to strip whitespaces
nnoremap <silent> <F1> :call <SID>StripTrailingWhitespaces()<CR>

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
        echo "WARNING! File uses tabs instead of spaces. Defaulting to tabs"
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
    nmap <F5> :silent !tmux split-window -h '"%:p"; read -p "[enter] to close. F2 to run as sudo"'
    " run shell script (.sh) as sudo by pressing F2
    nmap <F2> :silent !tmux split-window -h 'sudo "%:p"; read -p "[enter] to close"'
endfunction
