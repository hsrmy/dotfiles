# Default editor
export EDITOR=nano

# completion confiuration
autoload -U compinit; compinit -u
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups
setopt share_history

setopt auto_pushd
setopt list_packed
setopt nolistbeep

# Alias configuration
alias dco="docker-compose"

if [ -d ${HOME}/git/dotfiles ]; then
  zshrc_dir=${HOME}/git/dotfiles/zsh
elif [ -d ${HOME}/bin/dotfiles ]; then
  zshrc_dir=${HOME}/bin/dotfiles/zsh
elif [ -d ${HOME}/servers/dotfiles ]; then
   zshrc_dir=${HOME}/servers/dotfiles/zsh
fi

if [ "$(uname)" = 'Darwin' ]; then
  source ${zshrc_dir}/darwin.zshrc    
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
  source  ${zshrc_dir}/linux.zshrc
  if [ -e /etc/debian_version -o -e /etc/debian_release ]; then
    source ${zshrc_dir}/debian.zshrc
  elif [ -e /etc/arch-release ]; then
    source ${zshrc_dir}/archlinux.zshrc
  fi
fi

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