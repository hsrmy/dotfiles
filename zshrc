# =============================================================================
# Amazon Q integration
# =============================================================================
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# =============================================================================
# Basic configuration
# =============================================================================
export EDITOR=nano

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups share_history hist_no_store extended_history
setopt auto_pushd list_packed nolistbeep

# =============================================================================
# Dotfiles configuration
# =============================================================================
DOTFILES=$(dirname "$(realpath "${HOME}"/.zshrc)")

# =============================================================================
# Platform-specific configuration
# =============================================================================
if [ "$(uname)" = 'Darwin' ]; then
  source "${DOTFILES}/zsh/darwin.zshrc"
elif [ "$(uname -s | cut -c1-5)" = 'Linux' ]; then
  source "${DOTFILES}/zsh/linux.zshrc"
fi

# =============================================================================
# Anyenv configuration
# =============================================================================
export ANYENV_ROOT="/opt/anyenv"
export ANYENV_DEFINITION_ROOT="${ANYENV_ROOT}/config"
export GOENV_PATH_ORDER="front"

# =============================================================================
# Go configuration
# =============================================================================
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"
export GOENV_DISABLE_GOPATH=1

# =============================================================================
# Remove duplicate PATHs (after all PATH modifications)
# =============================================================================
typeset -U path PATH

# =============================================================================
# Aliases
# =============================================================================
alias dco="docker compose"
alias ipinfo="curl -sS https://ipinfo.io|jq -r '.ip'"
alias gitbd="git branch --merged|grep -E -v '\*|pre-staging|staging|develop|main|master'|xargs git branch -d"
alias nodeenv="nodenv"
alias prco="gh pr checkout"
alias qc="q chat"
alias cl="claude"
alias escape="pbpaste|sed 's/\\\u\(....\)/\&#x\1;/g'|nkf --numchar-input -w;echo"
alias rgpg="gpgconf --kill gpg-agent && echo \"test\" | gpg --clearsign > /dev/null"
alias asl="aws sso login --profile"

# =============================================================================
# Theme configuration
# =============================================================================
[ -f "${DOTFILES}/p10k.zsh" ] && source "${DOTFILES}/p10k.zsh"
source "${DOTFILES}/zsh/theme/powerlevel/powerlevel10k.zsh-theme"

# =============================================================================
# Completion system
# =============================================================================
# Setup completion paths
[ -n "$ANYENV_ROOT" ] && fpath=("${ANYENV_ROOT}/completions" "${ANYENV_ROOT}/envs/"*/completions "${fpath[@]}")
fpath=("${HOME}/.docker/completions" "${fpath[@]}")

autoload -Uz compinit && compinit -u

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command "ps -u $USER -o pid,%cpu,tty,cputime,cmd"

autoload -U +X bashcompinit && bashcompinit

# AWS CLI completion
if command -v brew &> /dev/null && [ -f "$(brew --prefix awscli)/bin/aws_completer" ]; then
  complete -C "$(brew --prefix awscli)/bin/aws_completer" aws
elif command -v aws_completer &> /dev/null; then
  complete -C aws_completer aws
fi
# Terraform completion
if [ -f /opt/anyenv/envs/tfenv/bin/terraform ]; then
  complete -o nospace -C /opt/anyenv/envs/tfenv/bin/terraform terraform
elif [ -f /usr/local/bin/terraform ]; then
  complete -o nospace -C /usr/local/bin/terraform terraform
fi

# =============================================================================
# Functions
# =============================================================================
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

function peco-select-history() {
  local sel cmd
  sel=$(\history -i -f -n -r 1 | peco --query "$LBUFFER")
  [[ -z $sel ]] && return

  cmd=$(printf "%s\n" "$sel" | sed -E 's|^[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]]+[0-9]{2}:[0-9]{2}[[:space:]]+||')

  BUFFER="$cmd"
  CURSOR=$#BUFFER
  zle clear-screen
}
if type peco &> /dev/null; then
  zle -N peco-select-history
  bindkey '^R' peco-select-history
else
  echo "Shortcut ^R (peco-select-history) is disabled! (Please install \"peco\")"
fi

function ghq-cd() {
  local selected_dir
  selected_dir=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${HOME}/git/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
if type ghq &> /dev/null && type peco &> /dev/null; then
  zle -N ghq-cd
  bindkey '^]' ghq-cd
else
  echo "Shortcut ^] (ghq-cd) is disabled! (Please install \"ghq\" and \"peco\")"
fi

# =============================================================================
# Amazon Q integration
# =============================================================================
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
