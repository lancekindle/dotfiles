# /usr/env/bash

# alias git to several choices. git-loglastdir assumes git-achievements exists
# git-loglastdir records last dir in which git was run. This is then read by
# terminator in a startup script (~/.config/terminator/config):
# .terminator-cd-git-last-dir to cd there upon startup
if [ -f ~/bin/alias/.git-loglastdir ]; then
    alias git=~/bin/alias/.git-loglastdir
elif [ -f ~/bin/alias/git-achievements/git-achievements ]; then
    alias git=~/bin/alias/git-achievements/git-achievements
fi

alias mkvirtualenv="mkvirtualenv -p python3"
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias df="df -h"
alias gits="git status"
alias ll='ls -alFh'
alias la='ls -Ah'
alias l='ls -CFh'
alias tig="tig --all"

# for opening vim docs
alias vimdocs="cd /usr/share/vim/vim*/doc;vim help.txt"
alias vimdoc=vimdocs
alias xflux="xflux -z 99353"

# use neovim instead of vim
alias vim="nvim"

# force tmux (as best as possible) to use 256 colors
alias tmux="tmux -2"

# firefox nightly link (oh so fast)
alias firefox-nightly="~/bin/firefox-nightly/firefox"
