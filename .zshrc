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
  /usr/local/opt/mysql-client/bin(N-/)
  /usr/local/opt/openssl/bin(N-/)
  /usr/local/bin(N-/)
  $path
)

## gvm
[[ -s "${HOME}/.gvm/scripts/gvm" ]] && source "${HOME}/.gvm/scripts/gvm"
## jenv
if type "jenv" > /dev/null 2>&1; then
  eval "$(jenv init -)"
fi

autoload -Uz zshrc-base && zshrc-base
autoload -Uz zshrc-zinit && zshrc-zinit
autoload -Uz zshrc-gc-sdk && zshrc-gc-sdk
autoload -Uz zshrc-rbenv && zshrc-rbenv
## aws command completer
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws

alias ls='ls -G'
alias ll='ls -altr'
alias vi='vim'
alias sed='gsed'
## Docker
alias drma='docker ps -aq | xargs docker rm'
alias drmia='docker images -aq | xargs docker rmi'
## docker-compose
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcp='docker-compose ps'
alias dci='docker-compose images'
## Laravel sail
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'

