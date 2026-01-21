# Zshオプション設定

# ディレクトリ移動
setopt auto_cd              # コマンドじゃなければ cd する
setopt autopushd            # cd 時に自動で push
setopt pushd_ignore_dups    # 同じディレクトリを pushd しない

# 補完関連
setopt auto_param_keys      # カッコの対応などを自動的に補完
setopt auto_param_slash     # ディレクトリ名の補完で末尾の / を自動的に付加
setopt list_types           # 補完候補一覧でファイルの種別をマーク表示
setopt magic_equal_subst    # --prefix=/usr などの = 以降も補完
setopt globdots             # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt mark_dirs            # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt complete_in_word     # 語の途中でもカーソル位置で補完
setopt always_last_prompt   # カーソル位置は保持したままファイル名一覧を順次その場で表示

# その他
setopt nobeep               # ビープを鳴らさない
setopt auto_resume          # サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt print_eight_bit      # 出力時8ビットを通す
setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす
unsetopt promptcr           # 出力の文字列末尾に改行コードが無い場合でも表示

# 単語区切り文字
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
