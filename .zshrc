export PATH=$HOME/.pyenv/shims:$HOME/google-cloud-sdk/bin:$HOME/.nodebrew/current/bin:$HOME/.composer/vendor/bin:/usr/local/bin:$PATH
export FPATH="${HOME}/dotfiles/zshrc:${FPATH}"

autoload -Uz zshrc-base && zshrc-base
#autoload -Uz zshrc-zplug && zshrc-zplug
autoload -Uz zshrc-zplugin && zshrc-zplugin

alias ls='ls -G'
alias vi='vim'
