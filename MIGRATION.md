# Theme System Refactoring - Migration Guide

## Summary of Changes

This refactoring implements a live theming system with runtime switching, removing the need for system rebuilds when changing themes.

## Breaking Changes

### 1. Removed Files/Modules
- ❌ `modules/shared/wallpaper/` - Integrated into theme system
- ❌ `modules/shared/theme/state.json` - Replaced with runtime state

### 2. Configuration Changes

#### Old Configuration (home.nix)
```nix
wallpaper.enable = true;
```

#### New Configuration (home.nix)
```nix
# wallpaper.enable is removed - automatically enabled with theme system
theme = {
  enable = true;
  # ... other theme options
};
```

### 3. Command Changes

#### Old Commands
```bash
wallpaper              # Old wallpaper selector
theme-switch <theme>   # Required rebuild
```

#### New Commands
```bash
theme-switch <theme>         # Live switch - no rebuild
theme-from-wallpaper [img]   # Generate theme from wallpaper
theme-list                   # List available themes
theme-info                   # Show current theme

# Aliases
wp                           # Alias for theme-from-wallpaper
wallpaper                    # Alias for theme-from-wallpaper
```

## New Features

### 1. 12-Color Palette System

Themes now use exactly 12 semantic colors (like Catppuccin/Rose Pine):

**Base Colors (3)**
- `base` - Main background
- `surface` - Elevated surfaces
- `overlay` - Overlays, borders

**Text Colors (3)**
- `text` - Primary text
- `subtext` - Secondary text
- `muted` - Muted/disabled text

**Accent Colors (6)**
- `primary` - Primary accent
- `secondary` - Secondary accent
- `love` - Red/errors
- `gold` - Yellow/warnings
- `foam` - Cyan/info
- `pine` - Green/success

### 2. Runtime State Location

Theme state moved from:
- ❌ `~/.config/dotfiles/modules/shared/theme/state.json`

To:
- ✅ `~/.config/theme/current.json`

This file is now gitignored and created at runtime.

### 3. Live Theme Switching

Themes now switch instantly without rebuilds:

```bash
theme-switch catppuccin-mocha  # Instant switch
```

Applications auto-reload:
- Kitty (SIGUSR1)
- Tmux (auto-reload config)
- Aerospace/Barik (SIGUSR1)

### 4. DRY Utilities

New utilities in `modules/shared/theme/utils.nix`:

```nix
# Color utilities
withAlpha color alpha          # Add transparency
normalizeColor color           # Ensure # prefix
isValidHex color               # Validate hex color

# Theme utilities
createVariant base mods        # Create theme variant
mergePalettes [p1 p2]          # Merge palettes

# Export utilities
toShellExports palette prefix  # Generate shell vars
toCssVars palette prefix       # Generate CSS vars
toJsonSafe palette             # Filter for JSON
```

## Migration Steps

### 1. Update Home Configuration

Remove wallpaper module reference:

```nix
# Before
wallpaper.enable = true;

# After
# Not needed - wallpaper functionality is in theme system
```

### 2. Update Theme Switching Workflow

```bash
# Before (required rebuild)
theme-switch rose-pine
# waited for: darwin-rebuild switch --flake .#owl

# After (instant)
theme-switch rose-pine
# Done! Applications reload automatically
```

### 3. Wallpaper Workflow

```bash
# Before
wallpaper                    # Used separate module

# After
theme-from-wallpaper         # Integrated in theme
wp                          # Shorthand alias
```

### 4. Custom Themes

If you had custom themes in `state.json`, migrate to `mkTheme`:

```nix
# In your config
myCustomTheme = registry.mkTheme {
  name = "my-theme";
  base = "#...";
  surface = "#...";
  # ... 12 colors total
};
```

## Enhanced Features

### 1. Aerospace Improvements

- Enabled normalization for cleaner layouts
- Reduced gaps to 12px for minimal aesthetic
- Added fullscreen toggle (`alt-m`)
- Extended workspace support (1-9)
- Hyprland-inspired keybindings

### 2. Application Integration

All theme-aware applications automatically update:
- Kitty terminal
- Tmux multiplexer
- Neovim editor
- Aerospace WM
- Sketchybar (via Barik)

## Rollback (if needed)

If you need to rollback, you can revert commits:

```bash
git revert HEAD~2..HEAD  # Revert last 2 commits
```

Or switch to the previous branch state before the refactor.

## Questions?

See:
- [Theme System README](modules/shared/theme/README.md)
- [Theme Registry](modules/shared/theme/registry.nix)
- [Theme Utils](modules/shared/theme/utils.nix)
