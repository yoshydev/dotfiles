export PATH=$HOME/.nodebrew/current/bin:$HOME/.composer/vendor/bin:$PATH
export FPATH="${HOME}/dotfiles/zshrc:${FPATH}"

autoload -Uz zshrc-base && zshrc-base
autoload -Uz zshrc-zplug && zshrc-zplug

alias ls='ls -G'
alias vi='vim'
