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
  zsh \
  curl \
  wget \
  git \
  htop \
  fastfetch \
  unzip \
  p7zip-full \
  ffmpeg \
  vlc \
  gimp \
  inkscape \
  obs-studio \
  timeshift \
  transmission-gtk \
  fuse

# install media player
cd ~/Downloads
wget https://files.strawberrymusicplayer.org/strawberry_1.2.20-resolute_amd64.deb
sudo apt install strawberry_1.2.20-resolute_amd64.deb -y
rm strawberry_1.2.20-resolute_amd64.deb
cd ~

ok "apt packages installed."

# -----------------------------------------------------------------------------
# Flatpak apps
# -----------------------------------------------------------------------------
log "Installing Flatpak apps..."

FLATPAKS=(

  # Creative / Content
  org.kde.kdenlive
  fr.handbrake.ghb

  # Productivity / Notes

  # Communication
 
  # Utilities
  com.github.tchx84.Flatseal
  io.github.flattool.Warehouse
  it.mijorus.gearlever
  io.github.getnf.embellish
  org.localsend.localsend_app

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

# -----------------------------------------------------------------------------
# Ohmyzsh (for SorinSage / personal creative work)
# -----------------------------------------------------------------------------
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
