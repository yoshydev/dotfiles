#!/bin/bash

echo 'setup start...'
cd $HOME

# Install Homebrew
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install packages
which brew >/dev/null 2>&1 && brew doctor
brew update
brew upgrade
brew bundle
brew cleanup

# dotfiles
echo 'generate symlink...'
for file in .zshrc .vimrc .gitconfig .ideavimrc Brewfile .commit_template
do
  [ ! -e $file ] && ln -s $HOME/dotfiles/$file .
done

echo 'done!'
