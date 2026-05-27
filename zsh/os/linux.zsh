# Linux固有設定

# Linuxbrew
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# -----------------------------------------------------------------------------
# 日本語入力 (IME): WSLg + fcitx5
#   WAYLAND_DISPLAY がある = WSLg セッション。fcitx5 を IME として使う。
#   (WezTerm 等の端末で日本語入力するための設定)
# -----------------------------------------------------------------------------
if [ -n "$WAYLAND_DISPLAY" ]; then
  export GTK_IM_MODULE=fcitx
  export QT_IM_MODULE=fcitx
  export XMODIFIERS=@im=fcitx
  # fcitx5 デーモンが未起動なら起動する。
  # WSLg では wayland アドオンが表示接続を維持できず即死するため、
  # --disable=wayland で無効化し X11(XWayland) 経由で動かす。
  if command -v fcitx5 >/dev/null 2>&1 && ! pgrep -x fcitx5 >/dev/null 2>&1; then
    fcitx5 --disable=wayland -d >/dev/null 2>&1
  fi
fi
