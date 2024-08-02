# Common darwin settings
export LANG=ja_JP.UTF-8

fpath=($(brew --prefix)/share/zsh-completions $fpath)

export PATH="/opt/anyenv/bin:$HOME/bin:$PATH"
# export LESSOPEN='| /Users/hsrmy/bin/mylesspipe.sh %s'

alias ls="ls --color=auto -h"
alias curl="curl -L --anyauth"
alias find="gfind"
alias xargs="gxargs"
alias awk="gawk"
alias psf="pstree"
alias ippb="ipinfo|pbcopy"

export PATH="$(brew --prefix coreutils)/libexec/gnubin:$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix mysql-client@8.0)/bin:$PATH"

# anyenv configuration
[ -f $(brew --prefix)/bin/anyenv ] && eval "$(anyenv init -)"

# direnv configuration
[ -f $(brew --prefix)/bin/direnv ] && eval "$(direnv hook zsh)"

# Remove duplicate PATHs
typeset -U path PATH

# ssh
ssh-add --apple-use-keychain &> /dev/null

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"