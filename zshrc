# Default editor
export EDITOR=nano

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

local DOTFILES=$(dirname $(realpath .zshrc))

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

# completion confiuration
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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