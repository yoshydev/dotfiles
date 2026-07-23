-- =============================================================================
--  WezTerm 設定 (WSL/NixOS 側 = wezterm-mux-server 用)
--
--  Windows 版 wezterm-gui が SSH (127.0.0.1:2222) 経由で接続する
--  wezterm-mux-server が読む設定。GUI 側の設定 (フォント・キーバインド・
--  配色・背景) は Windows 側 ~/.wezterm.lua (dotfiles: windows/wezterm.lua)
--  が担当し、ここは mux server が保持する端末モデル側の設定のみを置く。
--
--  kitty graphics protocol (md-render.nvim の画像プレビュー) は t=f の
--  ファイルパス解決が mux server 側 (= WSL 内) で行われるため、この構成で
--  パッチ不要で動作する。
--
--  配置: install.sh が ~/.config/wezterm へシンボリックリンクする。
-- =============================================================================
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- スクロールバックは mux server がペインごとに保持する
config.scrollback_lines = 10000

return config
