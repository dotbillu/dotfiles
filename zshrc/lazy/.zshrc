export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

load_nvm() {
  unset -f nvm node npm npx
  source /usr/share/nvm/init-nvm.sh
}
nvm()  { load_nvm; nvm "$@"; }
node() { load_nvm; node "$@"; }
npm()  { load_nvm; npm "$@"; }
npx()  { load_nvm; npx "$@"; }
# . "/home/abhay/.deno/env"

