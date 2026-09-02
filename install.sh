#!/bin/sh
set -eu

check_os() {
  if [ "$(uname)" != "Darwin" ]; then
    echo "This script is intended for macOS only."
    exit 1
  fi
}

clone_repo() {
  if [ ! -d "$HOME/.config" ]; then
    echo "Cloning dotfiles repository..."
    git clone --recurse-submodules https://github.com/Esteban-Bermudez/dotfiles.git "$HOME/.config"
  else
    echo "Dotfiles repository already exists. Skipping cloning."
    if [ -d "$HOME/.config/.git" ]; then
      echo "Updating submodules..."
      git -C "$HOME/.config" submodule update --init --recursive 2>/dev/null || true
    fi
  fi
}

install_mise() {
  if ! command -v mise >/dev/null 2>&1 && ! command -v "$HOME/.local/bin/mise" >/dev/null 2>&1; then
    echo "Installing mise..."
    curl https://mise.run | sh
  else
    echo "mise is already installed. Skipping installation."
  fi
}

bootstrap() {
  echo "Bootstrapping with mise..."
  MISE_BIN="$HOME/.local/bin/mise"
  if [ ! -x "$MISE_BIN" ]; then
    MISE_BIN="$(command -v mise 2>/dev/null || true)"
  fi
  if [ -z "$MISE_BIN" ] || [ ! -x "$MISE_BIN" ]; then
    echo "mise not found. Please restart your shell and run: mise bootstrap --yes"
    exit 1
  fi
  # Trust the config (needed for bootstrap files/packages)
  "$MISE_BIN" trust "$HOME/.config/mise/config.toml" 2>/dev/null || true
  "$MISE_BIN" bootstrap --yes
}

main() {
  check_os
  clone_repo
  echo "Installing mise package manager..."
  install_mise
  echo "Running mise bootstrap (packages, dotfiles, macOS defaults, tools)..."
  bootstrap
  echo "------------------------------------------------------------------------"
  echo "All installations are complete."
  echo "Setup complete! Please use Kitty as your terminal emulator."
  echo "If Docker/Karabiner prompted for sudo, run again in a Terminal with TTY."
  echo "------------------------------------------------------------------------"
}

main
