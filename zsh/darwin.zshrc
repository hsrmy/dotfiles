# Common darwin settings
export LANG=ja_JP.UTF-8

# anyenv configuration (Homebrew)
if [ -f "$(brew --prefix)/bin/anyenv" ]; then
  export ANYENV_ROOT="/opt/anyenv"
  export ANYENV_DEFINITION_ROOT="${ANYENV_ROOT}/config"
  export GOENV_PATH_ORDER="front"
  BREW_PREFIX="$(brew --prefix)"
  export PATH="${BREW_PREFIX}/bin:$HOME/bin:$PATH"
  eval "$("${BREW_PREFIX}"/bin/anyenv init -)"
fi

fpath=("$(brew --prefix)/share/zsh-completions" "${fpath[@]}")

# export LESSOPEN='| /Users/hsrmy/bin/mylesspipe.sh %s'

alias ls="ls --color=auto -h"
alias curl="curl -L --anyauth"
alias find="gfind"
alias xargs="gxargs"
alias awk="gawk"
alias psf="pstree"
alias ippb="ipinfo|pbcopy"
alias pinentry="pinentry-mac"

BREW_PREFIX_COREUTILS="$(brew --prefix coreutils)"
BREW_PREFIX_GNU_SED="$(brew --prefix gnu-sed)"
export PATH="${BREW_PREFIX_COREUTILS}/libexec/gnubin:${BREW_PREFIX_GNU_SED}/libexec/gnubin:$PATH"
BREW_PREFIX_MYSQL="$(brew --prefix mysql-client@8.0)"
export PATH="${BREW_PREFIX_MYSQL}/bin:$PATH"
BREW_PREFIX_GREP="$(brew --prefix grep)"
export PATH="${BREW_PREFIX_GREP}/libexec/gnubin:$PATH"
BREW_PREFIX_OPENSSL="$(brew --prefix openssl@3)"
BREW_PREFIX_CURL="$(brew --prefix curl)"
export LDFLAGS="-L${BREW_PREFIX_MYSQL}/lib -L${BREW_PREFIX_OPENSSL}/lib -L${BREW_PREFIX_CURL}/lib"
export CPPFLAGS="-I${BREW_PREFIX_MYSQL}/include -I${BREW_PREFIX_OPENSSL}/include -I${BREW_PREFIX_CURL}/include"

# direnv configuration
[ -f "$(brew --prefix)/bin/direnv" ] && eval "$(direnv hook zsh)"

# ssh
ssh-add --apple-use-keychain &> /dev/null

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"