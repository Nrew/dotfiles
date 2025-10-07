# My NixOS & macOS Dotfiles

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-stable-green.svg?style=flat-square)](https://github.com/nix-community/home-manager)
[![macOS](https://img.shields.io/badge/macOS-aarch64-lightgrey.svg?style=flat-square&logo=apple)](https://www.apple.com/macos)
[![Linux](https://img.shields.io/badge/Linux-x86__64-orange.svg?style=flat-square&logo=linux)](https://kernel.org)

This repository contains my personal NixOS and macOS (via nix-darwin) configurations, managed with Nix and Home Manager.

## Screenshots

## Supported Systems

*   **Linux:** `x86_64-linux`
*   **macOS:** `aarch64-darwin`

## Theme System

This configuration features a unified, dynamic theme system that allows seamless switching between themes without rebuilding.

### Quick Start

```bash
# Switch to a theme
theme-switch beige

# Cycle through themes
theme-cycle

# View current theme with color preview
theme-info

# Generate theme from wallpaper
theme-from-wallpaper ~/Pictures/wallpaper.png
```

### Available Themes

- **Beige**: beige, beige-dark
- **Rose Pine**: rose-pine, rose-pine-moon, rose-pine-dawn
- **Catppuccin**: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
- **Minimal**: minimal-light, minimal-dark

All themes support:
- Live switching (no rebuild required)
- Automatic application reload
- Wallpaper integration
- Font configuration

See [modules/shared/theme/README.md](modules/shared/theme/README.md) for detailed documentation.

## Installation
