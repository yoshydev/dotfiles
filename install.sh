#!/bin/bash

set -e

echo '========================================'
echo '  Dotfiles Setup'
echo '========================================'
echo ''

cd "$HOME"

DOTFILES_DIR="$HOME/dotfiles"

# =============================================================================
# Homebrew
# =============================================================================
echo '[1/5] Installing Homebrew...'
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Linuxbrew PATH設定
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo '[2/5] Updating Homebrew packages...'
brew doctor || true
brew update
brew upgrade
brew bundle --file="$DOTFILES_DIR/Brewfile"
brew cleanup

# =============================================================================
# gvm (Go Version Manager)
# =============================================================================
echo '[3/5] Installing gvm...'
if [ ! -d "$HOME/.gvm" ]; then
  echo '  Installing gvm...'
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  echo '  gvm installed successfully'
else
  echo '  gvm already installed, skipping'
fi

# =============================================================================
# シンボリックリンク作成
# =============================================================================
echo '[4/5] Creating symlinks...'

# ホームディレクトリへのシンボリックリンク
declare -a home_files=(
  ".zshrc"
  ".vimrc"
  ".gitconfig"
  ".ideavimrc"
  ".commit_template"
  ".tmux.conf"
  "commitlint.config.js"
)

for file in "${home_files[@]}"; do
  target="$HOME/$file"
  source="$DOTFILES_DIR/$file"

  if [ -L "$target" ]; then
    echo "  Skipping $file (symlink already exists)"
  elif [ -e "$target" ]; then
    echo "  Warning: $target exists and is not a symlink. Backing up..."
    mv "$target" "$target.backup"
    ln -s "$source" "$target"
    echo "  Created symlink for $file"
  else
    ln -s "$source" "$target"
    echo "  Created symlink for $file"
  fi
done

# Neovim設定
nvim_config="$HOME/.config/nvim"
if [ ! -L "$nvim_config" ]; then
  mkdir -p "$HOME/.config"
  if [ -e "$nvim_config" ]; then
    mv "$nvim_config" "$nvim_config.backup"
  fi
  ln -s "$DOTFILES_DIR/nvim" "$nvim_config"
  echo "  Created symlink for nvim config"
else
  echo "  Skipping nvim config (symlink already exists)"
fi

# Lazygit設定
lazygit_config="$HOME/.config/lazygit"
if [ ! -L "$lazygit_config" ]; then
  mkdir -p "$HOME/.config"
  if [ -e "$lazygit_config" ]; then
    mv "$lazygit_config" "$lazygit_config.backup"
  fi
  ln -s "$DOTFILES_DIR/lazygit" "$lazygit_config"
  echo "  Created symlink for lazygit config"
else
  echo "  Skipping lazygit config (symlink already exists)"
fi

# WezTerm設定 (WSL側 = wezterm-mux-server 用。GUI は Windows 版 + windows/setup.ps1)
wezterm_config="$HOME/.config/wezterm"
if [ ! -L "$wezterm_config" ]; then
  mkdir -p "$HOME/.config"
  if [ -e "$wezterm_config" ]; then
    mv "$wezterm_config" "$wezterm_config.backup"
  fi
  ln -s "$DOTFILES_DIR/wezterm" "$wezterm_config"
  echo "  Created symlink for wezterm config"
else
  echo "  Skipping wezterm config (symlink already exists)"
fi

# 旧構成 (WSLg + Linux版wezterm + fcitx5) の掃除。dotfiles を指す残骸のみ削除する。
# 詳細は git 履歴 (wezterm/wezterm-launcher.sh, fcitx5/) を参照。
old_wezterm_launcher="/usr/local/bin/wezterm"
if [ -L "$old_wezterm_launcher" ] && [[ "$(readlink "$old_wezterm_launcher")" == "$DOTFILES_DIR"/* ]]; then
  if command -v sudo &> /dev/null; then
    sudo rm -f "$old_wezterm_launcher"
    echo "  Removed legacy wezterm launcher ($old_wezterm_launcher)"
  else
    echo "  Warning: sudo not available; leave legacy $old_wezterm_launcher"
  fi
fi

old_fcitx5_service="$HOME/.config/systemd/user/fcitx5.service"
if [ -L "$old_fcitx5_service" ] && [[ "$(readlink "$old_fcitx5_service")" == "$DOTFILES_DIR"/* ]]; then
  if command -v systemctl &> /dev/null; then
    systemctl --user disable fcitx5.service 2>/dev/null || true
  fi
  rm -f "$old_fcitx5_service"
  echo "  Removed legacy fcitx5.service"
fi

old_fcitx5_config="$HOME/.config/fcitx5/config"
if [ -L "$old_fcitx5_config" ] && [[ "$(readlink "$old_fcitx5_config")" == "$DOTFILES_DIR"/* ]]; then
  rm -f "$old_fcitx5_config"
  echo "  Removed legacy fcitx5 config symlink"
fi

# =============================================================================
# Claude Code設定
# =============================================================================
echo '[5/5] Creating Claude Code config symlinks...'
mkdir -p "$HOME/.claude"
declare -a claude_files=(
  "settings.json"
  "statusline-command.sh"
  "statusline-update-check.sh"
)
for file in "${claude_files[@]}"; do
  target="$HOME/.claude/$file"
  source="$DOTFILES_DIR/claude/$file"
  if [ -L "$target" ]; then
    echo "  Skipping $file (symlink already exists)"
  elif [ -e "$target" ]; then
    echo "  Warning: $target exists. Backing up..."
    mv "$target" "$target.backup"
    ln -s "$source" "$target"
    echo "  Created symlink for $file"
  else
    ln -s "$source" "$target"
    echo "  Created symlink for $file"
  fi
done

# =============================================================================
# 完了メッセージ
# =============================================================================
echo ''
echo '========================================'
echo '  Setup Complete!'
echo '========================================'
echo ''
echo 'Please restart your shell or run:'
echo '  source ~/.zshrc'
echo ''
echo '----------------------------------------'
echo '  Manual Steps Required'
echo '----------------------------------------'
echo ''
echo '1. Create local environment file:'
echo '   cat > ~/dotfiles/zsh/env.local.zsh << EOF'
echo '   export AWS_PROFILE="your-profile"'
echo '   EOF'
echo ''
echo '2. Install Node.js version:'
echo '   nodenv install <version>'
echo '   nodenv global <version>'
echo ''
echo '3. Install Ruby version:'
echo '   rbenv install <version>'
echo '   rbenv global <version>'
echo ''
echo '4. Install Java version (if needed):'
echo '   # Install JDK via SDKMAN, Homebrew, or manually'
echo '   jenv add /path/to/jdk'
echo '   jenv global <version>'
echo ''
echo '5. Install Go version (if needed):'
echo '   source ~/.gvm/scripts/gvm'
echo '   gvm install go<version>'
echo '   gvm use go<version> --default'
echo ''
echo '6. Install Claude Code (if needed):'
echo '   curl -fsSL https://claude.ai/install.sh | sh'
echo ''
echo '7. Initialize Google Cloud SDK (if needed):'
echo '   gcloud init'
echo ''
echo '----------------------------------------'
