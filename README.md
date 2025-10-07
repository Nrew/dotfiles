# My NixOS & macOS Dotfiles

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-stable-green.svg?style=flat-square)](https://github.com/nix-community/home-manager)
[![macOS](https://img.shields.io/badge/macOS-aarch64-lightgrey.svg?style=flat-square&logo=apple)](https://www.apple.com/macos)
[![Linux](https://img.shields.io/badge/Linux-x86__64-orange.svg?style=flat-square&logo=linux)](https://kernel.org)

This repository contains my personal NixOS and macOS (via nix-darwin) configurations, managed with Nix and Home Manager.

## ✨ Features

- **🎨 Live Theming**: Change themes instantly without rebuilding (see [Theme System](modules/shared/theme/README.md))
- **🖼️ Wallpaper Integration**: Generate themes from wallpapers using gowall
- **⚡ Minimal Animations**: Smooth, clean, non-distracting visual transitions
- **🪟 Hyprland-like WM**: Aerospace configured with Hyprland-inspired keybindings and workflow
- **📝 NixCats Neovim**: Modern Neovim setup with LSP, Treesitter, and more
- **🔄 Live Reload**: Applications auto-reload when theme changes

## 🎨 Theme System

The live theming system supports:

- **12-color palette** (Catppuccin/Rose Pine model)
- **Runtime switching** - no rebuilds required
- **Wallpaper-based themes** - extract colors from images
- **Multiple presets** - Beige, Rose Pine, Catppuccin, Minimal

### Quick Start

```bash
# Switch theme
theme-switch rose-pine

# Generate from wallpaper
theme-from-wallpaper ~/Pictures/wallpaper.png

# List themes
theme-list
```

See [Theme Documentation](modules/shared/theme/README.md) for details.

## Screenshots

## Supported Systems

*   **Linux:** `x86_64-linux`
*   **macOS:** `aarch64-darwin`

## Installation
