#!/usr/bin/env bash
# =============================================================================
# Module: embedded.sh
# Embedded systems development tools — ESP32, STM32, Arduino
# =============================================================================

set -euo pipefail

log()  { echo -e "\033[0;36m[embedded]\033[0m $1"; }
ok()   { echo -e "\033[0;32m[ok]\033[0m $1"; }

# -----------------------------------------------------------------------------
# System packages
# -----------------------------------------------------------------------------
log "Installing embedded dev packages..."
sudo apt install -y \
  build-essential \
  cmake \
  git \
  python3 \
  python3-pip \
  python3-venv \
  openocd \
  stlink-tools \
  gdb-multiarch \
  minicom \
  picocom \
  libusb-1.0-0-dev \
  usbutils

ok "System packages installed."

# -----------------------------------------------------------------------------
# VS Code (if not already present)
# -----------------------------------------------------------------------------
if ! command -v code &>/dev/null; then
  log "Installing VS Code..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | \
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] \
    https://packages.microsoft.com/repos/code stable main" | \
    sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update -qq
  sudo apt install -y code
  ok "VS Code installed."
else
  ok "VS Code already present — skipping."
fi

# -----------------------------------------------------------------------------
# PlatformIO Core (CLI)
# -----------------------------------------------------------------------------
if ! command -v pio &>/dev/null; then
  log "Installing PlatformIO Core..."
  pip3 install --user platformio
  ok "PlatformIO Core installed."
else
  ok "PlatformIO already present — skipping."
fi

# -----------------------------------------------------------------------------
# Arduino IDE 2 (Flatpak)
# -----------------------------------------------------------------------------
if ! flatpak list 2>/dev/null | grep -q "cc.arduino.IDE2"; then
  log "Installing Arduino IDE 2 via Flatpak..."
  flatpak install -y flathub cc.arduino.IDE2
  ok "Arduino IDE 2 installed."
else
  ok "Arduino IDE 2 already present — skipping."
fi

# -----------------------------------------------------------------------------
# udev rules for STM32 (ST-Link) and ESP32 (CP210x, CH340)
# -----------------------------------------------------------------------------
log "Installing udev rules..."

# ST-Link v2/v3
sudo tee /etc/udev/rules.d/49-stlinkv2.rules > /dev/null <<'EOF'
# ST-Link V2
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666", GROUP="plugdev"
# ST-Link V2-1
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666", GROUP="plugdev"
# ST-Link V3
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE="0666", GROUP="plugdev"
EOF

# CP2102 (common ESP32 USB-UART)
sudo tee /etc/udev/rules.d/99-cp210x.rules > /dev/null <<'EOF'
SUBSYSTEM=="usb", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666", GROUP="dialout"
EOF

# CH340/CH341 (common Arduino clones)
sudo tee /etc/udev/rules.d/99-ch340.rules > /dev/null <<'EOF'
SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666", GROUP="dialout"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger
ok "udev rules installed and reloaded."

# -----------------------------------------------------------------------------
# Group memberships
# -----------------------------------------------------------------------------
log "Adding user to dialout and plugdev groups..."
sudo usermod -aG dialout,plugdev "$USER"
ok "Groups updated. A logout/reboot is required for this to take effect."
