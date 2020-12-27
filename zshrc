# Default editor
export EDITOR=nano

# completion confiuration
autoload -Uz compinit && compinit
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

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups share_history hist_no_store 

setopt auto_pushd
setopt list_packed
setopt nolistbeep

# Alias configuration
alias dco="docker-compose"

local DOTFILES=$(dirname $(realpath ${HOME}/.zshrc))

if [ "$(uname)" = 'Darwin' ]; then
  source ${DOTFILES}/zsh/darwin.zshrc    
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
  source  ${DOTFILES}/zsh/linux.zshrc
  if [ -e /etc/debian_version -o -e /etc/debian_release ]; then
    source ${DOTFILES}/zsh/debian.zshrc
  elif [ -e /etc/arch-release ]; then
    source ${DOTFILES}/zsh/archlinux.zshrc
  fi
fi

[ -f ${DOTFILES}/p10k.zsh ] && source ${DOTFILES}/p10k.zsh
source ${DOTFILES}/zsh/theme/powerlevel/powerlevel10k.zsh-theme

# direnv configuration
[ -x $(which direnv) ] && eval "$(direnv hook zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


function command_not_found_handler() {
  if [ $(( $(od -vAn --width=4 -tu4 -N4 </dev/urandom) % 5 )) -lt 4 ]; then
    echo "\"$1\"なんてコマンド見つからないよ〜(●・▽ ・●)"
  else
    echo "(*>△ <)＜\"$1\"なんてコマンド見つからないよっっ"
    echo "(*>△ <)＜ナーンナーンっっ"
  fi
  return 127;
}