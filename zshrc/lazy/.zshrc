# --- Terminal SSH Agent Integration ---
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"
fi
alias git="ssh-add -l &>/dev/null || ssh-add; git"
alias lazygit="ssh-add -l &>/dev/null || ssh-add; lazygit"

load_nvm() {
  unset -f nvm node npm npx
  source /usr/share/nvm/init-nvm.sh
}
nvm()  { load_nvm; nvm "$@"; }
node() { load_nvm; node "$@"; }
npm()  { load_nvm; npm "$@"; }
npx()  { load_nvm; npx "$@"; }
# . "/home/abhay/.deno/env"

