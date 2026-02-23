# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


source ~/.zshrc.themes
source ~/.zshrc.alias 
source /usr/share/nvm/init-nvm.sh
export NODE_OPTIONS='--max-old-space-size=6144'

export PATH="$HOME/.local/bin:$PATH"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
. "/home/abhay/.deno/env"
export EDITOR=nvim
export VISUAL=nvim
