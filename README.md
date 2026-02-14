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
4. Neovim / Lazygit 設定のシンボリックリンク作成
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

Windows側のPowerShellで以下を実行:

```powershell
powershell -ExecutionPolicy Bypass -File \\wsl$\Ubuntu-20.04\home\yunip\dotfiles\windows\setup.ps1
```

setup.ps1 が行うこと:

1. `%USERPROFILE%\bin` ディレクトリを作成
2. `nvim.bat` を配置
3. 環境変数を設定 (`PATH` に `~/bin` を追加、`EDITOR` を設定)

完了後、ターミナルを再起動すれば以下が可能:

- **「プログラムから開く」** で `nvim.bat` を指定してファイルを編集
- ファイルのあるディレクトリがカレントディレクトリとして設定される
- コマンドラインから `nvim <file>` で起動

Git for Windows のエディタとして設定する場合:

```powershell
git config --global core.editor "C:/Users/yunip/bin/nvim.bat"
```
