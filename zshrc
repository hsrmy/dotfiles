# 文字コードの設定
export LANG=ja_JP.UTF-8
# デフォルトのエディターの設定
export EDITOR=nano

# 補完機能を有効にする
fpath=(/usr/local/share/zsh-completions/src /usr/share/zsh/vendor-completions $fpath)
autoload -U compinit; compinit -u
# 大文字小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補もLS_COLORSで色づけ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# コマンドの履歴を保存するファイル
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups
setopt share_history

#移動したディレクトリを記録
setopt auto_pushd
#補完候補を詰めてする表示
setopt list_packed
#補完候補表示時等にビープ音を鳴らさない
setopt nolistbeep

#プロンプトの設定
PROMPT="%F{green}%n@%m%F{white}:%f%F{cyan}%~%f$ "

# alias
alias dco="docker-compose"

# direnv
eval "$(direnv hook zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
