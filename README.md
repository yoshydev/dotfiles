# dotfiles

WSL2 (NixOS) 環境の開発設定ファイル群。

## 構成

```
dotfiles/
├── install.sh              # WSL/Linux セットアップスクリプト
├── Brewfile                # Homebrew パッケージ一覧
├── zsh/                    # Zsh 設定
│   ├── os/                 #   OS別設定 (linux/darwin)
│   ├── tools/              #   バージョン管理ツール (nodenv, rbenv, jenv, gvm)
│   ├── env.zsh             #   環境変数
│   ├── env.local.zsh       #   ローカル環境変数 (git管理外)
│   ├── path.zsh            #   PATH設定
│   ├── aliases.zsh         #   エイリアス
│   ├── options.zsh         #   Zshオプション
│   ├── history.zsh         #   ヒストリ設定
│   ├── completion.zsh      #   補完設定
│   └── plugins.zsh         #   Zinit プラグイン
├── git-hooks/              # グローバル git hooks (core.hooksPath)
│   └── pre-commit          #   gitleaks 秘密情報スキャン + リポジトリ側 hook フォールバック
├── nvim/                   # Neovim 設定 (lazy.nvim)
├── lazygit/                # Lazygit 設定
├── wezterm/                # WezTerm 設定 (WSL側 = wezterm-mux-server 用)
├── claude/                 # Claude Code 設定
├── windows/                # Windows 連携
│   ├── nvim.bat            #   WSL nvim ラッパー
│   ├── wezterm.lua         #   Windows版 WezTerm 設定 (GUI側, mux 接続)
│   └── setup.ps1           #   Windows側セットアップスクリプト
├── .zshrc
├── .vimrc
├── .gitconfig
├── .ideavimrc
└── .commit_template
```

## セットアップ

### WSL / Linux

```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

install.sh が行うこと:

1. Homebrew のインストールとパッケージ導入 (Brewfile)
2. gvm (Go Version Manager) のインストール
3. シンボリックリンクの作成 (`.zshrc`, `.vimrc`, `.gitconfig` 等)
4. Neovim / Lazygit / WezTerm 設定のシンボリックリンク作成
5. Claude Code 設定のシンボリックリンク作成

完了後、手動で必要なもの:

```bash
# シェルの再読み込み
source ~/.zshrc

# 各言語のバージョンをインストール
nodenv install <version> && nodenv global <version>
rbenv install <version> && rbenv global <version>
```

### Windows (WSL連携)

WSL上のNeovimをWindows側の既定エディタとして使うための設定。

WSL側のターミナルで以下を実行:

```bash
cd ~/dotfiles
powershell.exe -ExecutionPolicy Bypass -File "$(wslpath -w ./windows/setup.ps1)" -DotfilesWinDir "$(wslpath -w ./windows)"
```

setup.ps1 が行うこと:

1. `%USERPROFILE%\bin` ディレクトリを作成
2. `nvim.bat` を配置
3. `wezterm.lua` を `%USERPROFILE%\.wezterm.lua` にコピー
4. 環境変数を設定 (`PATH` に `~/bin` を追加、`EDITOR` を設定)

完了後、ターミナルを再起動すれば以下が可能:

- **「プログラムから開く」** で `nvim.bat` を指定してファイルを編集
- ファイルのあるディレクトリがカレントディレクトリとして設定される
- コマンドラインから `nvim <file>` で起動

Git for Windows のエディタとして設定する場合 (setup.ps1 完了時に表示されるコマンドを使用):

```powershell
git config --global core.editor "%USERPROFILE%/bin/nvim.bat"
```

### WezTerm (ターミナル / Markdown 画像プレビュー)

**Windows 版 WezTerm (nightly) + WSL 内 wezterm-mux-server への SSH mux 接続**
を利用する。GPU 描画・Windows IME での日本語入力・md-render.nvim の画像プレビュー
(kitty graphics protocol) がすべて両立する構成。

- GUI 側設定: `windows/wezterm.lua` (setup.ps1 が `%USERPROFILE%\.wezterm.lua` へコピー)
- mux server 側設定: `wezterm/wezterm.lua` (install.sh が `~/.config/wezterm` へリンク)
- WSL 側の sshd (127.0.0.1:2222, 鍵認証のみ) と wezterm パッケージは
  NixOS の `/etc/nixos/configuration.nix` で構成する
- Windows 版 wezterm は **nightly が必須** (20240203 安定版は mux プロトコル不整合で接続不可)
- 画像プレビューは kitty graphics の t=f パス解決が mux server (WSL側) で
  行われるため動作する。ConPTY (`wsl -d` 直接起動) では APC が握り潰され不可
- PC 再起動後の WSL 未起動は GUI 側設定が接続前に `wsl.exe` で自動起動して対処

旧構成 (Linux 版 WezTerm + WSLg + fcitx5) は WSLg の XWayland に DRI3 が無く
CPU 描画しかできないため廃止 (git 履歴参照)。

### グローバル git hooks (gitleaks)

`.gitconfig` の `core.hooksPath = ~/dotfiles/git-hooks` により、全リポジトリの
コミット時に `git-hooks/pre-commit` が実行され、gitleaks で秘密情報を
スキャンする (gitleaks 本体は NixOS の systemPackages で導入)。

- リポジトリ側 `.git/hooks/pre-commit` があれば続けて実行する (共存可能)
- husky / lefthook 採用リポジトリはローカル config の `core.hooksPath` が
  優先されるため対象外 (プロジェクト側の運用が優先される)
- 誤検出時は行末に `# gitleaks:allow`、恒久除外はリポジトリの `.gitleaks.toml`
