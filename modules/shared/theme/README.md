# Theme System

A unified, dynamic theme system for your dotfiles that allows seamless theme switching across all applications.

## Features

- **16-color palette** standardized across all applications
- **Dynamic theme switching** with live updates (no rebuild required)
- **Multiple themes** including Catppuccin, Rose Pine, Beige, and Minimal variants
- **Wallpaper integration** - each theme can have an associated wallpaper
- **Font configuration** - themes can specify preferred fonts
- **Runtime theme cycling** - easily preview different themes

## Available Commands

### `theme-switch <name>`
Switch to a specific theme. Lists available themes if no name provided.

```bash
theme-switch beige
theme-switch rose-pine
theme-switch catppuccin-mocha
```

### `theme-cycle`
Cycle to the next theme in the list. Perfect for previewing themes.

```bash
theme-cycle  # Switch to next theme
```

### `theme-info`
Display current theme information with visual color palette.

```bash
theme-info
```

### `theme-from-wallpaper [image]`
Generate theme from a wallpaper (uses gowall for color extraction).

```bash
theme-from-wallpaper ~/Pictures/wallpaper.png
```

## Available Themes

### Beige Family
- `beige` - Warm, minimal light theme
- `beige-dark` - Warm, minimal dark theme

### Rose Pine Family
- `rose-pine` - Base dark theme
- `rose-pine-moon` - Moon variant
- `rose-pine-dawn` - Light variant

### Catppuccin Family
- `catppuccin-latte` - Light theme
- `catppuccin-frappe` - Dark blue theme
- `catppuccin-macchiato` - Dark purple theme
- `catppuccin-mocha` - Darkest theme

### Minimal Family
- `minimal-light` - Monochrome light
- `minimal-dark` - Monochrome dark

## How It Works

### Theme Structure

Each theme defines:
- **4 base colors**: base, mantle, surface, overlay
- **4 text colors**: text, subtext0, subtext1, muted
- **8 accent colors**: primary, secondary, red, orange, yellow, green, cyan, blue
- **Metadata**: wallpaper path, font preference

### Application Integration

When you switch themes:

1. **Theme files are symlinked** to `~/.config/current-theme/`
2. **Applications reload automatically**:
   - Kitty: via remote control or SIGUSR1
   - Tmux: sources config
   - Neovim: watches symlink and reloads
   - Btop: regenerates theme and reloads
   - macOS (barik/sketchybar): via SIGUSR1

3. **palette.json updated** for runtime apps that read it

### Zero Rebuild Required

All theme switching happens at runtime through:
- Symlink updates (instant)
- Application reload signals
- File watchers in Neovim

## Adding a New Theme

Edit `modules/shared/theme/registry.nix`:

```nix
my-theme = mkTheme {
  name = "my-theme";
  
  # Base colors
  base = "#..."; mantle = "#..."; surface = "#..."; overlay = "#...";
  
  # Text colors
  text = "#..."; subtext0 = "#..."; subtext1 = "#..."; muted = "#...";
  
  # Accent colors
  primary = "#..."; secondary = "#...";
  red = "#..."; orange = "#..."; yellow = "#...";
  green = "#..."; cyan = "#..."; blue = "#...";
  
  # Optional
  wallpaper = "~/path/to/wallpaper.png";
  font = "My Preferred Font";
};
```

Rebuild your config and the theme will be available immediately.

## Implementation Philosophy

- **Minimal overhead**: Symlinks and signals, no heavy processes
- **Single source of truth**: Registry defines all themes
- **Runtime flexibility**: No rebuilds for theme changes
- **Clean separation**: Theme system is independent of application configs
- **DRY principle**: Utilities in `utils.nix` for reusable functions

## Files

- `registry.nix` - Theme definitions
- `utils.nix` - Helper functions
- `default.nix` - Main theme module
- `~/.config/themes/` - Pre-generated theme files
- `~/.config/current-theme/` - Symlinks to active theme
