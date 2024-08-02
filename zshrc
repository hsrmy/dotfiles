# Default editor
export EDITOR=nano

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups share_history hist_no_store

setopt auto_pushd list_packed nolistbeep

# anyenv configuretion
export ANYENV_ROOT="/opt/anyenv"
export ANYENV_DEFINITION_ROOT=${ANYENV_ROOT}/config
export PATH=$ANYENV_ROOT/bin:$PATH
fpath=(${ANYENV_ROOT}/completions $fpath)

# Alias configuration
alias dco="docker compose"
alias ipinfo="curl -sS https://ipinfo.io|jq -r '.ip'"
alias gitbd="git branch --merged|egrep -v '\*|pre-staging|staging|develop|main|master'|xargs git branch -d"
alias nodeenv="nodenv"

local DOTFILES=$(dirname $(realpath ${HOME}/.zshrc))

if [ "$(uname)" = 'Darwin' ]; then
  source ${DOTFILES}/zsh/darwin.zshrc
  local PLATFORM='mac'
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
  source ${DOTFILES}/zsh/linux.zshrc
  local PLATFORM='linux'
fi

[ -f ${DOTFILES}/p10k.zsh ] && source ${DOTFILES}/p10k.zsh
source ${DOTFILES}/zsh/theme/powerlevel/powerlevel10k.zsh-theme

# completion confiuration
autoload -Uz compinit && compinit -u
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# go path
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH
export GOENV_DISABLE_GOPATH=1

function command_not_found_handler() {
  if [ $(( $(od -vAn --width=4 -tu4 -N4 </dev/urandom) % 5 )) -lt 4 ]; then
    echo "\"$1\"なんてコマンド見つからないよ〜(●・▽ ・●)"
  else
    echo "(*>△ <)＜\"$1\"なんてコマンド見つからないよっっ"
    echo "(*>△ <)＜ナーンナーンっっ"
  fi

  if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
    if [[ -x /usr/lib/command-not-found ]] ; then
        [[ -x /usr/lib/command-not-found ]] || return 1
        /usr/lib/command-not-found --no-failure-msg -- ${1+"$1"} && :
    fi
  fi
  return 127;
}

# Setting for peco
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
if type peco &> /dev/null; then
  zle -N peco-select-history
  bindkey '^R' peco-select-history
else
  echo "Shortcut ^R (peco-select-history) is disabled! (Please install \"peco\")"
fi

# Setting for ghq
function ghq-cd() {
  local selected_dir=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ~/git/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
if type peco &> /dev/null && type peco &> /dev/null; then
  zle -N ghq-cd
  bindkey '^]' ghq-cd
else
  echo "Shortcut ^] (ghq-cd) is disabled! (Please install \"ghq\" and \"peco\")"
fi

# Remove duplicate PATHs
typeset -U path PATH

autoload -U +X bashcompinit && bashcompinit

complete -C "/opt/homebrew/bin/aws_completer" aws
complete -o nospace -C /opt/anyenv/envs/tfenv/bin/terraform terraform