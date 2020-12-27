# Common darwin settings
export LANG=ja_JP.UTF-8

fpath=($HOME/.brew/share/zsh-completions /usr/local/share/zsh-completions/src /usr/share/zsh/vendor-completions $fpath)

export PATH=/opt/anyenv/bin:$HOME/bin:$PATH
export LESSOPEN='| /Users/hsrmy/bin/mylesspipe.sh %s'

alias ls="ls --color=auto -h"
alias curl="curl -L --anyauth"
alias find=gfind
alias xargs=gxargs
alias awk=gawk
alias psf=pstree

export PATH=/usr/local/opt/bison/bin:/$(brew --prefix coreutils)/libexec/gnubin:$PATH

# Remove duplicate PATHs
typeset -U path PATH