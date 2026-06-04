#!/usr/bin/env bash
# =============================================================================
# Module: apps.sh
# Core applications — apt packages and Flatpaks
# =============================================================================

set -euo pipefail

log()  { echo -e "\033[0;36m[apps]\033[0m $1"; }
ok()   { echo -e "\033[0;32m[ok]\033[0m $1"; }

# -----------------------------------------------------------------------------
# Flatpak setup
# -----------------------------------------------------------------------------
log "Ensuring Flatpak and Flathub are configured..."
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
ok "Flatpak ready."

# -----------------------------------------------------------------------------
# apt packages
# -----------------------------------------------------------------------------
log "Installing apt packages..."
sudo apt install -y \
  curl \
  wget \
  git \
  htop \
  neofetch \
  ripgrep \
  fd-find \
  bat \
  unzip \
  p7zip-full \
  ffmpeg \
  vlc \
  gimp \
  inkscape \
  obs-studio

ok "apt packages installed."

# -----------------------------------------------------------------------------
# Flatpak apps
# -----------------------------------------------------------------------------
log "Installing Flatpak apps..."

FLATPAKS=(
  # Browsers
  org.mozilla.firefox

  # Creative / Content
  org.gimp.GIMP
  org.inkscape.Inkscape
  com.obsproject.Studio
  org.kdenlive.kdenlive
  com.github.PintaProject.Pinta

  # Productivity / Notes
  md.obsidian.Obsidian

  # Communication
  com.discordapp.Discord

  # Utilities
  com.github.tchx84.Flatseal
  io.github.flattool.Warehouse

  # Dev
  cc.arduino.IDE2
)

for app in "${FLATPAKS[@]}"; do
  if flatpak list 2>/dev/null | grep -q "$app"; then
    ok "$app already installed — skipping."
  else
    log "Installing $app..."
    flatpak install -y flathub "$app" || echo "[warn] Failed to install $app — skipping."
  fi
done

ok "Flatpak apps installed."

# -----------------------------------------------------------------------------
# Zed editor (for SorinSage / personal creative work)
# -----------------------------------------------------------------------------
if ! command -v zed &>/dev/null; then
  log "Installing Zed editor..."
  curl -f https://zed.dev/install.sh | sh
  ok "Zed installed."
else
  ok "Zed already present — skipping."
fi
