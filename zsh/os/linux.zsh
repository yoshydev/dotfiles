# Linux固有設定

# Linuxbrew
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 注: fcitx5 IME 用の環境変数 (GTK_IM_MODULE / QT_IM_MODULE / XMODIFIERS) は
# /usr/local/bin/wezterm ラッパー (wezterm/wezterm-launcher.sh) が wezterm-gui
# 起動時に export する。zsh はその子プロセスとして env を継承するためここでの
# export は不要。
