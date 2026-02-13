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
echo '[1/4] Installing Homebrew...'
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Linuxbrew PATH設定
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo '[2/4] Updating Homebrew packages...'
brew doctor || true
brew update
brew upgrade
brew bundle --file="$DOTFILES_DIR/Brewfile"
brew cleanup

# =============================================================================
# gvm (Go Version Manager)
# =============================================================================
echo '[3/4] Installing gvm...'
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
echo '[4/4] Creating symlinks...'

# ホームディレクトリへのシンボリックリンク
declare -a home_files=(
  ".zshrc"
  ".vimrc"
  ".gitconfig"
  ".ideavimrc"
  ".commit_template"
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
echo '6. Initialize Google Cloud SDK (if needed):'
echo '   gcloud init'
echo ''
echo '----------------------------------------'
