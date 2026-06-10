# Linux固有設定

# Linuxbrew
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# -----------------------------------------------------------------------------
# 日本語入力 (IME): WSLg + fcitx5
#   WAYLAND_DISPLAY がある = WSLg セッション。fcitx5 を IME として使う。
#   (WezTerm 等の端末で日本語入力するための設定)
#
#   fcitx5 本体の起動は systemd ユーザーサービス (fcitx5.service) に一本化した。
#   ここで起動すると wezterm フックとの二重起動レースで XIM が詰まるため、
#   シェルからは環境変数の設定のみ行う。詳細は fcitx5/fcitx5.service を参照。
# -----------------------------------------------------------------------------
if [ -n "$WAYLAND_DISPLAY" ]; then
  export GTK_IM_MODULE=fcitx
  export QT_IM_MODULE=fcitx
  export XMODIFIERS=@im=fcitx
fi
