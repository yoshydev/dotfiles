-- =============================================================================
--  WezTerm 設定
--  WSL2 (Ubuntu-20.04) を既定シェルとし、画像プレビュー (kitty graphics
--  protocol) が動作する端末として構成する。tmux の代替として WezTerm の
--  タブ/ペイン分割を使うため、旧 .tmux.conf の機能をここへ移植している。
--
--  配置: setup.ps1 が %USERPROFILE%\.wezterm.lua へコピーする。
--  編集後は setup.ps1 を再実行し、WezTerm を再起動 (または Ctrl+Shift+R) する。
-- =============================================================================
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ---------------------------------------------------------------------------
-- 起動時に WSL (Ubuntu-20.04) を開く
-- ---------------------------------------------------------------------------
config.default_domain = 'WSL:Ubuntu-20.04'

-- ---------------------------------------------------------------------------
-- フォント (Windows Terminal と揃える: Moralerspace Neon HW = Nerd Font 内蔵)
-- ---------------------------------------------------------------------------
config.font = wezterm.font 'Moralerspace Neon HW'
config.font_size = 11.0
config.use_ime = true -- 日本語入力 (IME) を有効化

-- ---------------------------------------------------------------------------
-- 画像プレビュー
--   WezTerm は kitty graphics protocol をデフォルトで実装している。
--   tmux を介さずこの端末上で直接 nvim を動かすことで md-render.nvim 等の
--   画像プレビューが動作する (tmux 経由では動かないため WezTerm 分割を使う)。
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- 見た目 (truecolor はネイティブ対応)
-- ---------------------------------------------------------------------------
config.color_scheme = 'Tokyo Night' -- お好みで変更可
config.scrollback_lines = 10000
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }

-- 非アクティブペインを暗くして視認性を上げる (旧 window-style 相当)
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.6 }

-- ペイン区切り線の色 (旧 pane-active-border colour205 = ピンク 相当)
config.colors = {
  split = '#ff5fd7',
}

-- ---------------------------------------------------------------------------
-- タブ/ペイン操作: tmux 風キーバインド (leader = Ctrl+b)
--   旧 tmux の prefix (Ctrl+b) をそのまま leader にして移行負担を抑える。
-- ---------------------------------------------------------------------------
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.tab_and_split_indices_are_zero_based = false -- タブ/ペイン番号を1始まりに (旧 base-index 1)

config.keys = {
  -- 分割 ( % = 左右 / " = 上下、tmux と同じ割り当て)
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ペイン移動 (Ctrl+b → hjkl または矢印)
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- ペインのズーム/閉じる (tmux z / x)
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- タブ (tmux c / n / p)
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },

  -- コピーモード/ペースト (tmux [ / ])
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = ']', mods = 'LEADER', action = act.PasteFrom 'Clipboard' },

  -- Ctrl+b 自体をシェルへ送る (tmux の prefix prefix 相当)
  { key = 'b', mods = 'LEADER|CTRL', action = act.SendKey { key = 'b', mods = 'CTRL' } },
}

-- LEADER + 数字でタブを直接選択 (tmux prefix 数字)
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

-- ---------------------------------------------------------------------------
-- ステータスバー: 右側に pane title と日時 (旧 status-right 相当)
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

return config
