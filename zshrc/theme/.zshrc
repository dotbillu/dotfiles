export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  common-aliases
  sudo
  docker
  npm
  yarn
  rust
  extract
  colored-man-pages
  web-search
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  you-should-use
  zsh-autopair
)

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit
compinit
setopt AUTO_CD

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY

bindkey -e

unset ZSH_AUTOSUGGEST_USE_ASYNC
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
