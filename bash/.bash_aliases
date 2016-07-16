# /usr/env/bash

# alias git to several choices. git-loglastdir assumes git-achievements exists
# git-loglastdir records last dir in which git was run. This is then read by
# terminator in a startup script (~/.config/terminator/config):
# .terminator-cd-git-last-dir to cd there upon startup
if [ -f ~/bin/.git-loglastdir ]; then
    alias git=~/bin/.git-loglastdir
elif [ -f ~/bin/git-achievements/git-achievements ]; then
    alias git=~/bin/git-achievements/git-achievements
fi

alias mkvirtualenv="mkvirtualenv -p python3"
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias df="df -h"
alias gits="git status"

# for opening vim docs
alias vimdocs="cd /usr/share/vim/vim*/doc;vim help.txt" 
alias vimdoc=vimdocs
alias xflux="xflux -z 99353"

# force tmux (as best as possible) to use 256 colors
alias tmux="tmux -2"
