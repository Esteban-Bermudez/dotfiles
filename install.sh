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

# Function to install fonts
install_fonts() {
  echo " - Installing Fira Mono Nerd Font..."
  curl -L -o /tmp/FiraMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip
  unzip -o /tmp/FiraMono.zip -d "$HOME/Library/Fonts/"
  rm /tmp/FiraMono.zip
}

install_docker() {
  if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -L https://desktop.docker.com/mac/main/arm64/Docker.dmg -o /tmp/Docker.dmg
    hdiutil attach /tmp/Docker.dmg
    cp -R /Volumes/Docker/Docker.app /Applications
    hdiutil detach /Volumes/Docker
    rm /tmp/Docker.dmg
    echo ""
    echo " * Docker is now installed. Please open Docker.app from Applications to finish setup. * "
    echo ""
  else
    echo "Docker is already installed. Skipping installation."
  fi
}

install_scroll_reverser() {
  if ! [ -d "/Applications/Scroll Reverser.app" ]; then
    echo "Installing Scroll Reverser..."
    # Zip contains the Scroll Reverser app
    curl -L https://pilotmoon.com/downloads/ScrollReverser-1.9.zip -o /tmp/ScrollReverser.zip
    unzip -o /tmp/ScrollReverser.zip -d /Applications
    rm /tmp/ScrollReverser.zip
    echo ""
    echo " * Scroll Reverser is now installed. Please open Scroll Reverser from Applications to finish setup. * "
    echo ""
  else
    echo "Scroll Reverser is already installed. Skipping installation."
  fi
}

install_rectangle() {
  if ! [ -d "/Applications/Rectangle.app" ]; then
    echo "Installing Rectangle..."
    curl -L https://github.com/rxhanson/Rectangle/releases/download/v0.93/Rectangle0.93.dmg -o /tmp/Rectangle0.93.dmg
    MOUNT_OUTPUT=$(hdiutil attach /tmp/Rectangle0.93.dmg)
    MOUNT_POINT=$(echo "$MOUNT_OUTPUT" | grep "/Volumes/" | awk 'BEGIN{FS="	"}{print $3}')
    cp -R "${MOUNT_POINT}/Rectangle.app" /Applications
    hdiutil detach "${MOUNT_POINT}"
    rm /tmp/Rectangle0.93.dmg
    # Remove the quarantine attribute to prevent Gatekeeper issues
    xattr -d com.apple.quarantine "/Applications/Rectangle.app"
    echo ""
    echo " * Rectangle is now installed. Please open Rectangle from Applications to finish setup. * "
    echo ""
  else
    echo "Rectangle is already installed. Skipping installation."
  fi
}


# Function to install Kitty terminal emulator
install_kitty() {
  #curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  if ! command -v kitty &> /dev/null; then
    echo "Installing Kitty terminal emulator..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    echo "Kitty is now installed. Use this for your terminal emulator."
  else
    echo "Kitty is already installed. Skipping installation."
  fi
}

# Main function
main() {
  check_os
  clone_repo
  create_zshenv
  echo "Installing mise package manager..."
  install_mise
  echo "Installing dev tools..."
  install_tools
  echo "Installing fonts..."
  install_fonts
  echo "Installing GUI applications..."
  install_docker
  install_scroll_reverser
  install_rectangle
  install_kitty
  echo "------------------------------------------------------------------------"
  echo "All installations are complete."
  echo "Setup complete! Please use Kitty as your terminal emulator."
  echo "------------------------------------------------------------------------"
}

main
