# Common linux settings
export LANG=en_US.UTF-8

# anyenv configuration (package manager)
if [ -f /usr/bin/anyenv ] || [ -f /usr/local/bin/anyenv ]; then
  export ANYENV_ROOT="/opt/anyenv"
  export ANYENV_DEFINITION_ROOT="${ANYENV_ROOT}/config"
  export GOENV_PATH_ORDER="front"
  if [ -f /usr/bin/anyenv ]; then
    eval "$(/usr/bin/anyenv init -)"
  elif [ -f /usr/local/bin/anyenv ]; then
    eval "$(/usr/local/bin/anyenv init -)"
  fi
fi

alias ls="ls --color"

fpath=("${DOTFILES}/zsh/completions" "${fpath[@]}")
