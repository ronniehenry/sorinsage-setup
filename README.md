# SorinSage Setup

> Post-install scripts for a calm, intentional Ubuntu 26.04 LTS desktop.
> Built around the SorinSage aesthetic — soft-masculine, minimal, GNOME-first.

---

## System

- **OS:** Ubuntu 26.04 LTS (Noble)
- **Desktop:** GNOME 50
- **Encryption:** LUKS full-disk, ext4
- **Philosophy:** Stable infrastructure, not a hobby distro

---

## Quick Start

```bash
git clone https://github.com/sorinsage/sorinsage-setup.git
cd sorinsage-setup
chmod +x install.sh modules/*.sh

# Run everything
./install.sh

# Or run a specific module
./install.sh embedded
./install.sh gnome
./install.sh apps
./install.sh fonts
```

---

## Modules

| Module | What it does |
|---|---|
| `embedded.sh` | VS Code, PlatformIO, OpenOCD, stlink-tools, udev rules, dialout/plugdev groups |
| `gnome.sh` | gsettings, font preferences, night light, workspace config |
| `apps.sh` | Core apt packages, Flatpaks (Obsidian, Kdenlive, OBS, etc.), Zed editor |
| `fonts.sh` | Atkinson Hyperlegible, JetBrains Mono, Nerd Fonts, Papirus + teal folders |

---

## GNOME Extensions

These must be installed manually via [GNOME Extension Manager](https://flathub.org/apps/com.mattjakeman.ExtensionManager) or [extensions.gnome.org](https://extensions.gnome.org):

- **Just Perfection** — Super key → App Grid, UI cleanup
- **Blur my Shell** — Panel and overview blur
- **Rounded Window Corners Reborn** — Consistent window corner radius
- **User Themes** — Enables custom shell themes

---

## Aesthetic Stack

| Layer | Choice |
|---|---|
| GTK Theme | Colloid / Orchis (adw-gtk3 base) |
| Icon Theme | Papirus — teal folder color |
| System Font | Atkinson Hyperlegible 11 |
| Monospace Font | JetBrains Mono 10 |
| Wallpaper | Misty / gradient packs |
| Shell Theme | Matching Colloid variant |

---

## Embedded Dev Hardware

- ESP32 (CP2102 / CH340 USB-UART)
- STM32 (ST-Link V2/V3)
- Arduino-compatible boards

Tools: VS Code + PlatformIO extension, Arduino IDE 2 (Flatpak), OpenOCD, stlink-tools, GDB multiarch.

---

## Notes

- Run `./install.sh` as your regular user (not root). sudo will be invoked where needed.
- A **reboot** is recommended after first run to apply udev rules and group memberships.
- Extensions and themes require a **GNOME Shell restart** (`Alt+F2` → `r`) or logout after applying.
- The `gnome.sh` module assumes fonts are already installed. Run `fonts` before `gnome` if running individually.

---

## License

MIT — use freely, adapt to your own setup.
