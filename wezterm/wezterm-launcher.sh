#!/bin/sh
# WSLg 経由で起動される wezterm の IME 初期化ラッパー。
#
# このラッパーは2つの問題を同時に解決する:
#
# (1) 環境変数の非伝播
#   WSLg のスタートメニューショートカットは
#     wslg.exe -d Ubuntu-20.04 --cd "~" -- wezterm
#   という固定パターンで起動し、`.desktop` の Exec= は使わない。
#   このパスでは PAM セッションを通らないため /etc/environment が読まれず、
#   zsh が export している GTK_IM_MODULE / QT_IM_MODULE / XMODIFIERS も
#   シェルを経由しないため wezterm-gui プロセスに伝わらない。
#   → ここで明示 export する。
#
# (2) コールドブート時の XIM 登録レース
#   PC 再起動直後、WSLg autolaunch で wezterm-gui が起動するタイミングは
#   systemd ユーザーサービス fcitx5.service より僅か (1秒程度) に早いことが
#   ある。wezterm の XIM クライアントは起動時に X11 ルートの XIM_SERVERS
#   アトムを一度プローブし、未登録なら以降再試行しない。fcitx5 が後から
#   起動・XIM 登録しても初回 wezterm では IME が効かない。
#   → fcitx5 が XIM_SERVERS に @server=fcitx を書くまで待ってから本体を exec。
#
# install.sh が本ファイルを /usr/local/bin/wezterm に symlink する。
# PATH 順序 (/usr/local/bin が /usr/bin より先) で wslg.exe の `-- wezterm`
# 解決時にこのラッパーが選ばれる。

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# fcitx5 を確実に起動 (idempotent)。systemd ユーザーサービス側で
# Restart=on-failure が効いている前提だが、念のため。
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user start fcitx5.service 2>/dev/null
fi

# XIM_SERVERS アトムに fcitx が登録されるまで最大 ~3 秒待つ。
# 通常 fcitx5 起動から数百ms で登録される。xprop が無ければスキップ。
if command -v xprop >/dev/null 2>&1; then
  i=0
  while [ "$i" -lt 30 ]; do
    if DISPLAY="${DISPLAY:-:0}" xprop -root XIM_SERVERS 2>/dev/null | grep -q "@server=fcitx"; then
      break
    fi
    sleep 0.1
    i=$((i + 1))
  done
fi

exec /usr/bin/wezterm "$@"
