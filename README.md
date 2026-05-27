# dotfiles

WSL2 (Ubuntu) 環境の開発設定ファイル群。

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
├── nvim/                   # Neovim 設定 (lazy.nvim)
├── lazygit/                # Lazygit 設定
├── wezterm/                # WezTerm 設定 (Linux版 / WSL + WSLg)
├── claude/                 # Claude Code 設定
├── windows/                # Windows 連携
│   ├── nvim.bat            #   WSL nvim ラッパー
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
3. 環境変数を設定 (`PATH` に `~/bin` を追加、`EDITOR` を設定)

完了後、ターミナルを再起動すれば以下が可能:

- **「プログラムから開く」** で `nvim.bat` を指定してファイルを編集
- ファイルのあるディレクトリがカレントディレクトリとして設定される
- コマンドラインから `nvim <file>` で起動

Git for Windows のエディタとして設定する場合 (setup.ps1 完了時に表示されるコマンドを使用):

```powershell
git config --global core.editor "%USERPROFILE%/bin/nvim.bat"
```

### WezTerm (ターミナル / Markdown 画像プレビュー)

Markdown の画像プレビュー (md-render.nvim 等, kitty graphics protocol) を使うため、
**WSL 内で動く Linux 版 WezTerm + WSLg** を利用する。

- nvim と端末が同じ WSL ファイルシステム上にあるため画像を表示できる
  (Windows 版 WezTerm では nvim=WSL / 端末=Windows となりファイルパス転送が成立せず不可)
- tmux 経由では md-render.nvim の画像は表示できない (WezTerm の分割機能で代替)

```bash
# Linux 版 WezTerm (Ubuntu 22.04 向け .deb)
curl -L -o /tmp/wezterm.deb \
  "https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb"
sudo apt install -y /tmp/wezterm.deb

# カーソルテーマ (WSLg でカーソル未検出エラーを防ぐ)
sudo apt install -y dmz-cursor-theme

# 端末フォント (Windows 側の Moralerspace を WSL にコピー)
mkdir -p ~/.local/share/fonts
cp /mnt/c/Users/<user>/AppData/Local/Microsoft/Windows/Fonts/MoralerspaceNeonHW-*.ttf ~/.local/share/fonts/
fc-cache -f
```

設定 `wezterm/wezterm.lua` は install.sh が `~/.config/wezterm` へリンクする。
起動は WSL 内で `wezterm` (WSLg 経由で Windows デスクトップにウィンドウが開く)。
