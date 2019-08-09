export PATH=$HOME/google-cloud-sdk/bin:$HOME/.nodebrew/current/bin:$HOME/.composer/vendor/bin:$HOME/.rbenv/bin:$HOME/.pyenv/shims:$HOME/.local/bin:/usr/local/opt/openssl/bin:/usr/local/opt/postgresql@9.6/bin:$PATH
export FPATH="${HOME}/dotfiles/zshrc:${FPATH}"
export PGDATA="/usr/local/var/postgresql@9.6"

eval "$(rbenv init - zsh)"

autoload -Uz zshrc-base && zshrc-base
#autoload -Uz zshrc-zplug && zshrc-zplug
autoload -Uz zshrc-zplugin && zshrc-zplugin

alias ls='ls -G'
alias vi='vim'
alias psql='/usr/local/opt/postgresql@9.6/bin/psql'
alias ssh='~/bin/ssh-change-profile.sh'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yoshida_kazuhiro/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yoshida_kazuhiro/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yoshida_kazuhiro/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yoshida_kazuhiro/google-cloud-sdk/completion.zsh.inc'; fi
