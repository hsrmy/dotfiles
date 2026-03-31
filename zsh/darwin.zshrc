# Common darwin settings
export LANG=ja_JP.UTF-8

# Cache brew prefix for performance
BREW_PREFIX="${BREW_PREFIX:-$(brew --prefix)}"

# anyenv configuration (Homebrew)
if [ -f "${BREW_PREFIX}/bin/anyenv" ]; then
  export ANYENV_ROOT="/opt/anyenv"
  export ANYENV_DEFINITION_ROOT="${ANYENV_ROOT}/config"
  export GOENV_PATH_ORDER="front"
  export PATH="${BREW_PREFIX}/bin:$HOME/bin:$PATH"
  eval "$("${BREW_PREFIX}"/bin/anyenv init -)"
fi

fpath=("${BREW_PREFIX}/share/zsh-completions" "${fpath[@]}")

alias ls="ls --color=auto -h"
alias curl="curl -L --anyauth"
alias find="gfind"
alias xargs="gxargs"
alias awk="gawk"
alias psf="pstree"
alias ippb="ipinfo|pbcopy"
alias pinentry="pinentry-mac"

# Cache brew prefix paths for performance
BREW_PREFIX_COREUTILS="${BREW_PREFIX_COREUTILS:-$(brew --prefix coreutils)}"
BREW_PREFIX_GNU_SED="${BREW_PREFIX_GNU_SED:-$(brew --prefix gnu-sed)}"
BREW_PREFIX_MYSQL="${BREW_PREFIX_MYSQL:-$(brew --prefix mysql-client@8.0)}"
BREW_PREFIX_GREP="${BREW_PREFIX_GREP:-$(brew --prefix grep)}"
BREW_PREFIX_OPENSSL="${BREW_PREFIX_OPENSSL:-$(brew --prefix openssl@3)}"
BREW_PREFIX_CURL="${BREW_PREFIX_CURL:-$(brew --prefix curl)}"

export PATH="${BREW_PREFIX_COREUTILS}/libexec/gnubin:${BREW_PREFIX_GNU_SED}/libexec/gnubin:$PATH"
export PATH="${BREW_PREFIX_MYSQL}/bin:$PATH"
export PATH="${BREW_PREFIX_GREP}/libexec/gnubin:$PATH"
export LDFLAGS="-L${BREW_PREFIX_MYSQL}/lib -L${BREW_PREFIX_OPENSSL}/lib -L${BREW_PREFIX_CURL}/lib"
export CPPFLAGS="-I${BREW_PREFIX_MYSQL}/include -I${BREW_PREFIX_OPENSSL}/include -I${BREW_PREFIX_CURL}/include"

# direnv configuration
[ -f "${BREW_PREFIX}/bin/direnv" ] && eval "$(direnv hook zsh)"

# ssh
ssh-add --apple-use-keychain &> /dev/null

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"