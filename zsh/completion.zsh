# 補完設定

autoload -Uz compinit && compinit
autoload -U promptinit; promptinit

# 補完候補を一覧表示し、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1
# 普通に補完→ 小文字を大文字にして補完→ 大文字を小文字にして補完
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'

# AWS CLI補完
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws
