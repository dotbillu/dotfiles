_load_keychain() {
  unset -f ssh git
  eval $(keychain --eval --quiet)
}

ssh() { _load_keychain; command ssh "$@"; }
git() { _load_keychain; command git "$@"; }


load_nvm() {
  unset -f nvm node npm npx
  source /usr/share/nvm/init-nvm.sh
}
nvm()  { load_nvm; nvm "$@"; }
node() { load_nvm; node "$@"; }
npm()  { load_nvm; npm "$@"; }
npx()  { load_nvm; npx "$@"; }
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
. "/home/abhay/.deno/env"

