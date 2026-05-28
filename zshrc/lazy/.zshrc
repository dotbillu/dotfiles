if [[ -z "$SSH_AUTH_SOCK" ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"
fi
_lazy_ssh_unlock() {
  unset -f git lazygit ssh
  ssh-add -l &>/dev/null || ssh-add
}

git()     { _lazy_ssh_unlock; command git "$@"; }
lazygit() { _lazy_ssh_unlock; command lazygit "$@"; }
ssh()     { _lazy_ssh_unlock; command ssh "$@"; }

load_nvm() {
  unset -f nvm node npm npx
  source /usr/share/nvm/init-nvm.sh
}
nvm()  { load_nvm; nvm "$@"; }
node() { load_nvm; node "$@"; }
npm()  { load_nvm; npm "$@"; }
npx()  { load_nvm; npx "$@"; }
# . "/home/abhay/.deno/env"

