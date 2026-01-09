#!/bin/sh

set -eu

# Function to check if running on macOS
check_os() {
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is intended for macOS only."
    exit 1
  fi
}

# Function to clone the repository
clone_repo() {
  if [ ! -d "$HOME/.config" ]; then
    echo "Cloning dotfiles repository..."
    git clone --recurse-submodules https://github.com/Esteban-Bermudez/dotfiles.git "$HOME/.config"
  else
    echo "Dotfiles repository already exists. Skipping cloning."
  fi
}

# Function to create .zshenv
create_zshenv() {
  if [ -f "$HOME/.zshenv" ]; then
    echo ".zshenv already exists. Skipping creation."
    return
  fi
  echo "Creating .zshenv file..."
  echo 'ZDOTDIR=~/.config/zsh/' > "$HOME/.zshenv"
}

# Function to install mise
install_mise() {
  if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
  else
    echo "mise is already installed. Skipping installation."
  fi
}

# Function to install tools with mise
install_tools() {
    echo "Installing tools with mise..."
  if command -v ~/.local/bin/mise &> /dev/null; then 
    ~/.local/bin/mise install
  else
    echo "mise has not been activated. Cannot install tools."
    echo "Please restart your shell to activate mise and run the script again."
    exit 1
  fi
}

# Main function
main() {
  check_os
  clone_repo
  create_zshenv
  install_mise
  install_tools
  echo "Setup complete! Please restart your shell for all changes to take effect."
}

main
