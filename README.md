# Nrew's Dotfiles

This repository contains the configuration files and system settings for my personal development environment, managed using the [Nix](https://nixos.org/) package manager. It facilitates a reproducible and portable setup across different machines.

## Table of Contents

- [Overview](#overview)
- [Structure](#structure)
- [Installation](#installation)
- [Usage](#usage)
- [TODO](#todo)
- [References](#references)

## Overview

The configurations in this repository are organized to streamline the setup of my development environment. By leveraging Nix, I can ensure consistency and ease of maintenance across various systems.

## Structure

- **home/**: Contains user-specific configurations managed by [home-manager](https://nix-community.github.io/home-manager/)
- **hosts/**: Host-specific configurations for different machines (owl, crow)
- **modules/**: Modular configurations split between shared and host-specific modules
  - **shared/**: Common configurations used across all systems
  - **owl/**: macOS-specific configurations (aerospace, sketchybar)
- **apps/**: Utility scripts for system management
- **overlays/**: Custom Nixpkgs overlays to modify or extend package definitions
- **flake.nix**: Entry point for the Nix flake, defining the overall system configuration
- **flake.lock**: Locks the dependencies of the flake to ensure reproducibility
