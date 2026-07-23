# エイリアス設定

# 基本コマンド
alias ls='ls -G'
alias ll='ls -altr'
alias vi='vim'

# Docker
alias drma='docker ps -aq | xargs docker rm'
alias drmia='docker images -aq | xargs docker rmi'

# docker-compose
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcp='docker-compose ps'
alias dci='docker-compose images'

# Laravel sail
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'

# Lazygit
alias lg='lazygit'

# NixOS (設定は ~/dotfiles/nixos、/etc/nixos はそこへの symlink)
alias nrs='sudo nixos-rebuild switch --flake ~/dotfiles/nixos#nixos'
alias nrb='sudo nixos-rebuild build --flake ~/dotfiles/nixos#nixos'
