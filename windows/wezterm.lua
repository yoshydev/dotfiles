-- =============================================================================
--  Windows版 WezTerm 設定 (WSL/NixOS への mux 接続)
--
--  配置: windows/setup.ps1 が %USERPROFILE%\.wezterm.lua へコピーする。
--  直接 %USERPROFILE%\.wezterm.lua を編集した場合はここへ反映すること。
--
--  wezterm 内蔵の libssh で WSL 内 sshd (127.0.0.1:2222) に接続し、
--  wezterm-mux-server と mux プロトコルで通信する。
--  ConPTY を経由しないため kitty graphics protocol がそのまま通り、
--  t=f のファイルパスも WSL 側で解決される (md-render.nvim がパッチ不要で動く)。
--  描画は Windows ネイティブ (GPU)、日本語入力は Windows IME。
--
--  経緯:
--  - WSLg + Linux版wezterm は XWayland に DRI3 が無く CPU 描画しかできず遅い
--  - unix_domains + proxy_command(wsl.exe) 方式は、wezterm-gui が子プロセスの
--    stdio に socketpair を渡す実装と wsl.exe の相性で通信不能だった → SSH 方式
--  - scrollback_lines 等の端末モデル側の設定は WSL 側 wezterm.lua (mux server が
--    読む) が担当。このファイルは GUI 側 (描画・キーバインド・見た目) を担当
--  - wezterm は nightly を使う (20240203 安定版は mux プロトコル不整合で接続不可)
-- =============================================================================
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ---------------------------------------------------------------------------
-- mux 接続 (WSL/NixOS)
-- ---------------------------------------------------------------------------
config.ssh_domains = {
  {
    name = 'wsl-nixos',
    remote_address = '127.0.0.1:2222',
    username = 'yunip',
    multiplexing = 'WezTerm',
    remote_wezterm_path = '/run/current-system/sw/bin/wezterm',
    ssh_option = {
      identityfile = 'C:\\Users\\yunip\\.ssh\\wezterm_mux_ed25519',
    },
  },
}
-- 起動時に自動で mux ドメインへ接続
config.default_gui_startup_args = { 'connect', 'wsl-nixos' }

-- PC再起動直後は WSL VM が停止しており 127.0.0.1:2222 の sshd が存在しないため、
-- 接続前に NixOS ディストリを起動し sshd の active を待つ (最大10秒)。
--
-- 重要: WSL はデーモン (sshd セッション含む) だけではディストリを生存カウント
-- しないため、wsl.exe 経由の明示的なプロセスが無くなると数十秒で idle 終了し、
-- mux 接続ごと切断される。そこで常駐の keep-alive プロセス (sleep infinity) を
-- 先に spawn しておく。このプロセスは wezterm 終了後も残り、NixOS を起動した
-- ままにする (終了したいときは Windows 側で `wsl --shutdown`)。
-- 設定リロードのたびに走らないよう GLOBAL でガード (GUIプロセス内で一度だけ)。
if not wezterm.GLOBAL.wsl_boot_done then
  wezterm.GLOBAL.wsl_boot_done = true
  -- keep-alive (ディストリの起動も兼ねる)。GUI 再起動のたびにプロセスが累積
  -- しないよう、WSL 側の flock で単一インスタンス化する (獲得済みなら即終了)。
  wezterm.background_child_process {
    'wsl.exe', '-d', 'NixOS', '--exec', '/bin/sh', '-c',
    'exec /run/current-system/sw/bin/flock -n /tmp/wezterm-wsl-keepalive.lock /run/current-system/sw/bin/sleep infinity',
  }
  -- sshd が listen するまで同期的に待ってから mux 接続へ進む
  wezterm.run_child_process {
    'wsl.exe', '-d', 'NixOS', '--exec', '/bin/sh', '-c',
    'for i in $(seq 1 50); do /run/current-system/sw/bin/systemctl is-active -q sshd.service && exit 0; /run/current-system/sw/bin/sleep 0.2; done; exit 1',
  }
end

-- ---------------------------------------------------------------------------
-- フォント / IME
-- ---------------------------------------------------------------------------
config.font = wezterm.font 'Moralerspace Neon HW'
-- font_size は未指定 (デフォルト 12.0)。WSLg版の 14.0 を持ち込むと Windows の
-- DPIスケーリングも掛かって大きすぎた。
config.use_ime = true -- Windows IME で日本語入力

-- ---------------------------------------------------------------------------
-- 見た目
-- ---------------------------------------------------------------------------
config.color_scheme = 'Tokyo Night'
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }
-- 背景画像を使うため非アクティブペインの暗化(inactive_pane_hsb)は効かない。
-- ペインの区別は分割線(split)の色で行う。
config.colors = { split = '#ff5fd7' }

-- 背景画像 (Windows 側パス)
config.background = {
  {
    source = { File = 'C:\\Users\\yunip\\OneDrive\\Pictures\\pokemon\\Wallpaper_PokemonSV_B_1920_1080.jpg' },
    hsb = { brightness = 0.20 },
    horizontal_align = 'Center',
    vertical_align = 'Middle',
  },
}
config.window_background_opacity = 0.95

config.audible_bell = 'Disabled'

-- ---------------------------------------------------------------------------
-- タブ/ペイン操作: tmux 風キーバインド (leader = Ctrl+q)
-- ---------------------------------------------------------------------------
config.leader = { key = 'q', mods = 'CTRL', timeout_milliseconds = 1000 }
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

  -- Ctrl+q 自体をシェルへ送る
  { key = 'q', mods = 'LEADER|CTRL', action = act.SendKey { key = 'q', mods = 'CTRL' } },
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

-- 起動時の処理 (各ウィンドウの初回に実行)。ガードの意味は Linux 版と同じ:
-- window-config-reloaded は各ウィンドウの初回に必ず発火し、wezterm.GLOBAL の
-- ガードで設定リロード時の再実行 (フルスクリーンのトグル) を防ぐ。
wezterm.on('window-config-reloaded', function(window)
  wezterm.GLOBAL.window_initialized = wezterm.GLOBAL.window_initialized or {}
  local id = tostring(window:window_id())
  if wezterm.GLOBAL.window_initialized[id] then
    return
  end
  wezterm.GLOBAL.window_initialized[id] = true

  -- フルスクリーン表示。mux ドメインへの attach 完了前にフルスクリーン化すると
  -- リサイズがリモートペインに伝播せず、nvim 等が小さい領域に描画される
  -- レースがあるため、少し遅らせて実行する。
  wezterm.time.call_after(1.0, function()
    if not window:get_dimensions().is_full_screen then
      window:toggle_fullscreen()
    end
  end)
end)

return config
