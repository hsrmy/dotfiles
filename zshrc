# Default editor
export EDITOR=nano

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups share_history hist_no_store

setopt auto_pushd list_packed nolistbeep

# Alias configuration
alias ls="ls --color"
alias dco="docker-compose"

local DOTFILES=$(dirname $(realpath ${HOME}/.zshrc))

if [ "$(uname)" = 'Darwin' ]; then
  source ${DOTFILES}/zsh/darwin.zshrc
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
  source ${DOTFILES}/zsh/linux.zshrc
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

# anyenv configuretion
export ANYENV_ROOT="/opt/anyenv"
[ -f /opt/anyenv/bin/anyenv ] && eval "$(anyenv init -)"

# direnv configuration
[ -f /usr/local/bin/direnv ] && eval "$(direnv hook zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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