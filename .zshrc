export FPATH="${HOME}/dotfiles/zshrc:${FPATH}"
export PGDATA="/usr/local/var/postgresql@9.6"

path=(
  $HOME/.pyenv/shims(N-/)
  $HOME/google-cloud-sdk/bin(N-/)
  $HOME/.nodebrew/current/bin(N-/)
  $HOME/.composer/vendor/bin(N-/)
  $HOME/.rbenv/bin(N-/)
  $HOME/.jenv/bin(N-/)
  $HOME/.local/bin(N-/)
  /usr/local/opt/openssl/bin(N-/)
  /usr/local/bin
  $path
)

## gvm
[[ -s "${HOME}/.gvm/scripts/gvm" ]] && source "${HOME}/.gvm/scripts/gvm"
## jenv
eval "$(jenv init -)"

autoload -Uz zshrc-base && zshrc-base
autoload -Uz zshrc-zinit && zshrc-zinit
autoload -Uz zshrc-gc-sdk && zshrc-gc-sdk
autoload -Uz zshrc-rbenv && zshrc-rbenv
## aws command completer
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws

alias ls='ls -G'
alias vi='vim'
alias sed='gsed'

