#!/usr/bin/env bash
# =============================================================================
# Module: fonts.sh
# Fonts — Atkinson Hyperlegible, JetBrains Mono, Papirus icons
# =============================================================================

set -euo pipefail

log()  { echo -e "\033[0;36m[fonts]\033[0m $1"; }
ok()   { echo -e "\033[0;32m[ok]\033[0m $1"; }

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# -----------------------------------------------------------------------------
# Atkinson Hyperlegible (SorinSage system font)
# -----------------------------------------------------------------------------
# if fc-list | grep -qi "Atkinson Hyperlegible"; then
#   ok "Atkinson Hyperlegible already installed — skipping."
# else
#   log "Installing Atkinson Hyperlegible..."
#   TMP=$(mktemp -d)
#   wget -q "https://fonts.google.com/download?family=Atkinson+Hyperlegible" \
#     -O "$TMP/atkinson.zip" || {
#       log "Trying alternate source..."
#       wget -q "https://brailleinstitute.org/wp-content/uploads/2020/11/Atkinson-Hyperlegible-Font-Print-and-Digital-1.zip" \
#         -O "$TMP/atkinson.zip"
#     }
#   unzip -q "$TMP/atkinson.zip" -d "$TMP/atkinson"
#   find "$TMP/atkinson" -name "*.ttf" -exec cp {} "$FONTS_DIR/" \;
#   rm -rf "$TMP"
#   ok "Atkinson Hyperlegible installed."
# fi

# -----------------------------------------------------------------------------
# JetBrains Mono (monospace / code font)
# -----------------------------------------------------------------------------
# if fc-list | grep -qi "JetBrains Mono"; then
#   ok "JetBrains Mono already installed — skipping."
# else
#   log "Installing JetBrains Mono..."
#   sudo apt install -y fonts-jetbrains-mono || {
#     log "Falling back to manual install..."
#     TMP=$(mktemp -d)
#     JB_URL="https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip"
#     wget -q "$JB_URL" -O "$TMP/jb.zip"
#     unzip -q "$TMP/jb.zip" -d "$TMP/jb"
#     find "$TMP/jb/fonts/ttf" -name "*.ttf" -exec cp {} "$FONTS_DIR/" \;
#     rm -rf "$TMP"
#   }
#   ok "JetBrains Mono installed."
# fi

# -----------------------------------------------------------------------------
# Nerd Fonts — JetBrainsMono Nerd Font (for terminal)
# -----------------------------------------------------------------------------
# if fc-list | grep -qi "JetBrainsMono Nerd"; then
#   ok "JetBrainsMono Nerd Font already installed — skipping."
# else
#   log "Installing JetBrainsMono Nerd Font..."
#   TMP=$(mktemp -d)
#   NF_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
#   wget -q "$NF_URL" -O "$TMP/nf.zip"
#   unzip -q "$TMP/nf.zip" -d "$TMP/nf"
#   find "$TMP/nf" -name "*.ttf" -exec cp {} "$FONTS_DIR/" \;
#   rm -rf "$TMP"
#   ok "JetBrainsMono Nerd Font installed."
# fi

# -----------------------------------------------------------------------------
# Papirus icon theme with teal folder colors
# -----------------------------------------------------------------------------
if [ -d "/usr/share/icons/Papirus" ]; then
  ok "Papirus already installed — skipping."
else
  log "Installing Papirus icon theme..."
  sudo add-apt-repository -y ppa:papirus/papirus
  sudo apt update -qq
  sudo apt install -y papirus-icon-theme
  ok "Papirus installed."
fi

# Papirus folder color — teal
if command -v papirus-folders &>/dev/null; then
  log "Setting Papirus folder color to teal..."
  papirus-folders -C teal --theme Papirus
  ok "Papirus folder color set to teal."
else
  log "Installing papirus-folders..."
  wget -q -O- https://git.io/papirus-folders-install | sh
  papirus-folders -C teal --theme Papirus
  ok "Papirus folder color set to teal."
fi

# -----------------------------------------------------------------------------
# Refresh font cache
# -----------------------------------------------------------------------------
log "Refreshing font cache..."
fc-cache -f
ok "Font cache refreshed."
