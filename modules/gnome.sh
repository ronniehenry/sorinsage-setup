#!/usr/bin/env bash
# =============================================================================
# Module: gnome.sh
# GNOME 50 customization — extensions, gsettings, SorinSage aesthetic
# =============================================================================

set -euo pipefail

log()  { echo -e "\033[0;36m[gnome]\033[0m $1"; }
ok()   { echo -e "\033[0;32m[ok]\033[0m $1"; }
warn() { echo -e "\033[1;33m[warn]\033[0m $1"; }

# -----------------------------------------------------------------------------
# GNOME extension prerequisites
# -----------------------------------------------------------------------------
log "Installing GNOME extension tools..."
sudo apt install -y \
  gnome-shell-extension-manager \
  gnome-tweaks \
  gnome-shell-extensions

ok "GNOME tools installed."

# -----------------------------------------------------------------------------
# gsettings — interface preferences
# -----------------------------------------------------------------------------
log "Applying gsettings..."

# Clock format
gsettings set org.gnome.desktop.interface clock-format '12h'

# Font rendering
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'slight'

# Workspaces
gsettings set org.gnome.mutter dynamic-workspaces true
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

# Hot corners off (Just Perfection handles this)
gsettings set org.gnome.desktop.interface enable-hot-corners false

# Window button layout
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

ok "gsettings applied."

# -----------------------------------------------------------------------------
# Extension notes (manual install required via Extension Manager)
# -----------------------------------------------------------------------------
# The following extensions are part of the SorinSage preset.
# Install them via the GNOME Extension Manager app or extensions.gnome.org:
#
#   - Just Perfection       → Super key behavior, UI tweaks
#   - Blur my Shell         → Panel and overview blur
#   - Rounded Window Corners Reborn → Consistent corner radius
#   - User Themes           → Allows custom shell themes
#
# After installing, apply your Colloid/Orchis GTK theme and
# Papirus icon theme with teal folder colors via GNOME Tweaks.

warn "Extensions must be installed manually via Extension Manager."
warn "See README.md for the full SorinSage extension and theme list."

ok "GNOME module complete."
