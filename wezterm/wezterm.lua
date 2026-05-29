-- =============================================================================
--  WezTerm 設定 (Linux版 / WSL + WSLg)
--  WSL 内で動く Linux 版 WezTerm 用。nvim と端末が同じ WSL ファイルシステム上で
--  動くため、md-render.nvim の画像プレビュー(kitty graphics protocol)が動作する。
--  (Windows 版 WezTerm では nvim=WSL / 端末=Windows となりパス転送が成立せず
--   画像が出ないため、Linux 版 + WSLg へ移行した。)
--
--  配置: install.sh が ~/.config/wezterm へシンボリックリンクする。
-- =============================================================================
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- マシン固有のローカル設定 (git 管理外の wezterm/local.lua)。
-- 背景画像パスなど、リポジトリに含めたくない設定をここから読む。
local has_local, local_cfg = pcall(dofile, wezterm.config_dir .. '/local.lua')
if not has_local or type(local_cfg) ~= 'table' then
  local_cfg = {}
end

-- Linux 版はローカル(WSL)シェルを直接起動するため default_domain は不要。

-- ---------------------------------------------------------------------------
-- フォント (Windows 側からコピーした Moralerspace Neon HW = Nerd Font 内蔵)
-- ---------------------------------------------------------------------------
config.font = wezterm.font 'Moralerspace Neon HW'
config.font_size = 14.0
config.use_ime = true -- 日本語入力

-- WSLg では Wayland 経由の IME が不安定 (fcitx5 が即死) なため、XWayland で動かし
-- fcitx5(--disable=wayland で X11 起動) と XIM 経由で連携する。linux.zsh も参照。
config.enable_wayland = false

-- ---------------------------------------------------------------------------
-- WSLg(Wayland) でカーソルテーマが見つからないエラーの対策。
-- 事前に `sudo apt install -y dmz-cursor-theme` でテーマ本体を入れること。
-- ---------------------------------------------------------------------------
config.xcursor_theme = 'DMZ-White'
config.xcursor_size = 24

-- ---------------------------------------------------------------------------
-- 画像プレビュー: kitty graphics protocol はデフォルトで有効
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- 見た目 (truecolor はネイティブ対応)
-- ---------------------------------------------------------------------------
config.color_scheme = 'Tokyo Night' -- お好みで変更可
config.scrollback_lines = 10000
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }
-- 背景画像を使うため非アクティブペインの暗化(inactive_pane_hsb)は効かない。
-- ペインの区別は分割線(split)の色で行う。
config.colors = { split = '#ff5fd7' }

-- 背景画像 (パスは git 管理外の local.lua で background_image に指定したときのみ有効)。
-- hsb.brightness で画像自体の明るさを調整 (下げるほど暗い。0.1=ほぼ黒, 0.3=薄め)。
if local_cfg.background_image then
  config.background = {
    {
      source = { File = local_cfg.background_image },
      hsb = { brightness = local_cfg.background_brightness or 0.20 },
      horizontal_align = 'Center',
      vertical_align = 'Middle',
    },
  }
end
-- ウィンドウ全体の透過 (XWayland/WSLg では効かないことがある)
config.window_background_opacity = 0.95

-- ---------------------------------------------------------------------------
-- タブ/ペイン操作: tmux 風キーバインド (leader = Ctrl+b)
-- ---------------------------------------------------------------------------
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.tab_and_split_indices_are_zero_based = false

config.keys = {
  -- 分割 ( % = 左右 / " = 上下)
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ペイン移動 (hjkl / 矢印)
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- ペインのズーム/閉じる
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- タブ
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },

  -- コピーモード/ペースト
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = ']', mods = 'LEADER', action = act.PasteFrom 'Clipboard' },

  -- Ctrl+b 自体をシェルへ送る
  { key = 'b', mods = 'LEADER|CTRL', action = act.SendKey { key = 'b', mods = 'CTRL' } },
}

-- LEADER + 数字でタブを直接選択
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

-- ---------------------------------------------------------------------------
-- ステータスバー: 右側に pane title と日時
-- ---------------------------------------------------------------------------
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
wezterm.on('update-status', function(window, pane)
  local title = pane:get_title() or ''
  if #title > 21 then
    title = title:sub(1, 21)
  end
  local date = wezterm.strftime '%y-%m-%d %H:%M'
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#ffffff' } },
    { Text = string.format('"%s" %s ', title, date) },
  })
end)

-- 起動時の処理
wezterm.on('gui-startup', function(cmd)
  -- IME(fcitx5) を replace(-r) 起動して新鮮な XIM サーバーに繋ぎ直す。
  -- XIM は再接続に弱く、WezTerm を開き直すと古い fcitx5 への接続が腐って
  -- 日本語切替が効かなくなるため、ウィンドウ起動のたびに起動し直す。
  wezterm.background_child_process { 'fcitx5', '--disable=wayland', '-r', '-d' }
  -- フルスクリーン表示
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

return config
