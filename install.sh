#!/usr/bin/env bash
# =============================================================================
# SorinSage Setup — Ubuntu 26.04 LTS Post-Install Runner
# https://github.com/ronniehenry/sorinsage-setup
# =============================================================================
# Usage:
#   ./install.sh              → runs all modules
#   ./install.sh embedded     → runs only embedded dev module
#   ./install.sh gnome        → runs only GNOME module
#   ./install.sh apps         → runs only apps module
#   ./install.sh fonts        → runs only fonts module
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

log()    { echo -e "${CYAN}[sorinsage]${RESET} $1"; }
ok()     { echo -e "${GREEN}[ok]${RESET} $1"; }
warn()   { echo -e "${YELLOW}[warn]${RESET} $1"; }
err()    { echo -e "${RED}[error]${RESET} $1"; exit 1; }

# Verify running on Ubuntu
if ! grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
  warn "This script is designed for Ubuntu 26.04 LTS. Proceed with caution on other distros."
fi

# Require non-root but with sudo access
if [[ $EUID -eq 0 ]]; then
  err "Do not run this script as root. Run as your regular user with sudo privileges."
fi

sudo -v || err "sudo privileges required."

# Module list
ALL_MODULES=(gnome apps fonts embedded)

run_module() {
  local mod="$1"
  local path="$MODULES_DIR/${mod}.sh"
  if [[ -f "$path" ]]; then
    log "Running module: $mod"
    bash "$path"
    ok "Module complete: $mod"
  else
    warn "Module not found: $mod — skipping"
  fi
}

echo ""
echo -e "${CYAN}╔══════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║     SorinSage Post-Install Setup     ║${RESET}"
echo -e "${CYAN}║         Ubuntu 26.04 LTS             ║${RESET}"
echo -e "${CYAN}╚══════════════════════════════════════╝${RESET}"
echo ""

# Update package lists before anything
log "Updating package lists..."
sudo apt update -qq
ok "Package lists updated."
echo ""

if [[ $# -gt 0 ]]; then
  # Run only the specified module
  run_module "$1"
else
  # Run all modules in order
  for mod in "${ALL_MODULES[@]}"; do
    run_module "$mod"
    echo ""
  done
fi

echo ""
ok "All done. A reboot is recommended to apply group and udev changes."
