#!/bin/sh
# WSLg 経由で起動される wezterm の IME 初期化ラッパー。
#
# install.sh が本ファイルを /usr/local/bin/wezterm に symlink する。
# PATH 順序 (/usr/local/bin が /usr/bin より先) で wslg.exe の `-- wezterm`
# 解決時にこのラッパーが選ばれる。
#
# 解決している問題:
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
#   PC 再起動直後、systemd ユーザーサービス fcitx5.service が起動完了する前に
#   WSLg autolaunch で wezterm-gui が走り得る。wezterm の XIM クライアントは
#   起動時に X11 ルートの XIM_SERVERS アトムを一度プローブし、未登録なら
#   以降再試行しない。
#   → fcitx5 を systemctl で起動 (idempotent) し、XIM_SERVERS に @server=fcitx
#     が書かれるまで最大 3 秒待ってから本体を exec。
#
# (3) WSLg + fcitx5 起動直後の XIM 通信不成立 (recurring 問題)
#   コールドブート時、fcitx5 が wezterm より十分前 (10秒+) に起動しており
#   XIM_SERVERS も @server=fcitx selection 所有も全て揃っている状態でも、
#   wezterm からの ConvertSelection / SendEvent ClientMessage を fcitx5 が
#   受信処理できないケースがある。fcitx5 を一度再起動すると同じ window ID
#   のまま正常受信に切り替わる (XWayland 側か fcitx5 xim addon の起動直後の
#   バグと推測)。詳細は strace 解析の memory project_wezterm_cold_boot_ime
#   を参照。
#   → wezterm 起動の **後** に fcitx5 を背景再起動して PropertyNotify を
#     発火させ、wezterm の xcb-imdkit に再接続させる。これは新規ウィンドウ
#     ではなく初回 wezterm-gui プロセス起動時のみ実施 (既存ウィンドウへの
#     干渉を避けるため pgrep で判定)。
WEZTERM_GUI_RUNNING=0
if pgrep -x wezterm-gui >/dev/null 2>&1; then
  WEZTERM_GUI_RUNNING=1
fi

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# fcitx5 を確実に起動 (idempotent)。
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

# 初回 wezterm-gui 起動時のみ: fcitx5 を 2 秒後に再起動して XIM 再アナウンスを
# 発火させる。wezterm の xcb-imdkit が PropertyNotify を受けて再接続する。
# 既に wezterm-gui があるときは別ウィンドウを開くだけなので再起動しない。
if [ "$WEZTERM_GUI_RUNNING" = "0" ] && command -v systemctl >/dev/null 2>&1; then
  ( sleep 2; systemctl --user restart fcitx5.service >/dev/null 2>&1 ) &
fi

exec /usr/bin/wezterm "$@"
