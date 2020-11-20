export FPATH="${HOME}/dotfiles/zshrc:${FPATH}"
export PGDATA="/usr/local/var/postgresql@9.6"

path=(
  $HOME/.pyenv/shims(N-/)
  $HOME/google-cloud-sdk/bin(N-/)
  $HOME/.nodebrew/current/bin(N-/)
  $HOME/.composer/vendor/bin(N-/)
  $HOME/.rbenv/bin(N-/)
  $HOME/.local/bin(N-/)
  /usr/local/opt/openssl/bin(N-/)
  /usr/local/bin
  $path
)

[[ -s "${HOME}/.gvm/scripts/gvm" ]] && source "${HOME}/.gvm/scripts/gvm"

autoload -Uz zshrc-base && zshrc-base
autoload -Uz zshrc-zinit && zshrc-zinit
autoload -Uz zshrc-gc-sdk && zshrc-gc-sdk
autoload -Uz zshrc-rbenv && zshrc-rbenv

alias ls='ls -G'
alias vi='vim'

