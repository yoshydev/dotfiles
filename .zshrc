export PATH=$HOME/.nodebrew/current/bin:$PATH
export FPATH=".zshrc-git:${FPATH}"

autoload -Uz zshrc-base && zshrc-base
autoload -Uz zshrc-zplug && zshrc-zplug
