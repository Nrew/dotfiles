# Live Theming System

A unified, live theming system for NixOS/nix-darwin that supports runtime theme switching without rebuilds.

## Features

- **12-Color Palette**: Follows Catppuccin/Rose Pine model with exactly 12 semantic colors
- **Live Switching**: Change themes instantly without rebuilding your system
- **Wallpaper Integration**: Generate themes from wallpapers using gowall
- **Multiple Presets**: Beige, Rose Pine, Catppuccin, and minimal themes included
- **Application Support**: Kitty, Tmux, Neovim, and more auto-update

## Color Palette Structure

Each theme uses exactly 12 colors for consistency:

### Base Colors (3)
- `base` - Main background color
- `surface` - Elevated surfaces (cards, panels)
- `overlay` - Overlays, borders, separators

### Text Colors (3)
- `text` - Primary text color
- `subtext` - Secondary text color
- `muted` - Muted/disabled text color

### Accent Colors (6)
- `primary` - Primary accent color
- `secondary` - Secondary accent color
- `love` - Red/error states
- `gold` - Yellow/warning states
- `foam` - Cyan/info states
- `pine` - Green/success states

## Usage

### Switch Theme

```bash
# Switch to a predefined theme
theme-switch rose-pine

# List available themes
theme-list

# Show current theme
theme-info
```

### Wallpaper-Based Themes

```bash
# Generate theme from wallpaper (interactive picker)
theme-from-wallpaper

# Or specify a wallpaper directly
theme-from-wallpaper ~/Pictures/wallpaper.png

# Aliases
wp
wallpaper
```

## Available Themes

### Beige Family
- `beige` - Warm, minimal light theme
- `beige-dark` - Warm, minimal dark theme

### Rose Pine Family
- `rose-pine` - Main variant
- `rose-pine-moon` - Darker variant
- `rose-pine-dawn` - Light variant

### Catppuccin Family
- `catppuccin-latte` - Light variant
- `catppuccin-frappe` - Medium dark
- `catppuccin-macchiato` - Dark variant
- `catppuccin-mocha` - Darkest variant

### Minimal
- `minimal-light` - Pure monochrome light
- `minimal-dark` - Pure monochrome dark

## Configuration

Enable the theme system in your `home.nix`:

```nix
theme = {
  enable = true;
  font = {
    mono = "JetBrainsMono Nerd Font";
    sans = "Inter";
    size = { small = 12; normal = 14; large = 16; };
  };
  borderRadius = 8;
  gap = 16;
  wallpaperDir = "${config.home.homeDirectory}/Pictures/wallpapers";
};
```

## How It Works

1. **Runtime State**: Theme preference stored in `~/.config/theme/current.json`
2. **Live Reload**: Applications listen for signals to reload themes:
   - Kitty: `SIGUSR1`
   - Tmux: Auto-reload config
   - Aerospace/Barik: `SIGUSR1`
3. **No Rebuilds**: Theme changes happen instantly without `nixos-rebuild` or `darwin-rebuild`

## Creating Custom Themes

Use the `mkTheme` function in your config:

```nix
myTheme = registry.mkTheme {
  name = "my-theme";
  base = "#1a1a1a";
  surface = "#252525";
  overlay = "#303030";
  text = "#fafafa";
  subtext = "#b0b0b0";
  muted = "#707070";
  primary = "#d0d0d0";
  secondary = "#b0b0b0";
  love = "#ff6b6b";
  gold = "#f9e2af";
  foam = "#89b4fa";
  pine = "#a6e3a1";
};
```

## Utilities

The theme system includes DRY utilities in `utils.nix`:

- `withAlpha` - Add transparency to colors
- `normalizeColor` - Ensure proper hex format
- `createVariant` - Create theme variants
- `toShellExports` - Generate shell variables
- `toCssVars` - Generate CSS variables
- `toJsonSafe` - Filter palette for JSON

## Integration

Applications integrate with the theme through:

1. **Nix Configuration**: Via `palette` parameter
2. **Shell Variables**: Via `~/.config/theme/palette.sh`
3. **CSS Variables**: Via `~/.config/theme/palette.css`
4. **JSON**: Via `~/.config/theme/palette.json`

## Philosophy

- **Live, not build-time**: Themes should change instantly
- **12 colors only**: Consistency across all themes (Catppuccin/Rose Pine model)
- **DRY principles**: Single responsibility utilities
- **Minimal, clean animations**: Enhance, don't distract
