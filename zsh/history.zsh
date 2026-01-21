# ヒストリ設定

HISTFILE=~/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_all_dups # 重複するコマンドが記憶されるとき、古い方を削除する
setopt hist_ignore_dups     # 直前と同じコマンドをヒストリに追加しない
setopt hist_save_no_dups    # 重複するコマンドが保存されるとき、古い方を削除する
setopt hist_reduce_blanks   # 余計な空白は除去して記録
setopt extended_history     # zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt hist_verify          # ヒストリを呼び出してから実行する間に一旦編集
setopt share_history        # ヒストリを共有
