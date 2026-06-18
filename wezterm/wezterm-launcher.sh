#!/bin/sh
# WSLg 経由で起動される wezterm の IME 環境変数注入ラッパー。
#
# 経緯: WSLg のスタートメニューショートカットは
#   wslg.exe -d Ubuntu-20.04 --cd "~" -- wezterm
# という固定パターンで起動し、`.desktop` の Exec= は使わない。
# このパスでは PAM セッションを通らないため /etc/environment が読まれず、
# zsh が export している GTK_IM_MODULE / QT_IM_MODULE / XMODIFIERS も
# シェルを経由しないため wezterm-gui プロセスに伝わらない。
# 結果として XIM 接続が確立せず日本語入力ができない。
#
# 対策: install.sh が本ファイルを /usr/local/bin/wezterm に symlink する。
# PATH は /usr/local/bin が /usr/bin より先に来るため、wslg.exe の
# `-- wezterm` 解決時に本ラッパーが選ばれ、env を注入してから
# 本体 (/usr/bin/wezterm) を exec する。
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
exec /usr/bin/wezterm "$@"
