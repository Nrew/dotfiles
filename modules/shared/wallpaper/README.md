# Wallpaper Module

A Nix-focused wallpaper management module for nix-darwin that uses platform-appropriate tools.

## Features

- 🖼️ **macOS**: Uses `gowall` for efficient wallpaper management
- 🐧 **Linux**: Interactive fzf-based wallpaper selector with live preview
- 👁️ Live image preview in kitty terminal (Linux)
- 🎨 Theme-aware integration
- 📁 Supports multiple image formats (jpg, jpeg, png, webp)

## Configuration

### Enable the Module

In your `home/default.nix`:

```nix
{
  wallpaper.enable = true;
}
```

### Custom Wallpaper Directory

By default, wallpapers are loaded from `~/.config/dotfiles/images/wallpapers`. To customize:

```nix
{
  theme.wallpaperDir = "/path/to/your/wallpapers";
}
```

## Usage

### macOS (gowall)

The module uses `gowall` on macOS, which must be installed via Homebrew:

```bash
brew install gowall
```

Then run the wallpaper command:

```bash
wallpaper
# or use the alias
wp
```

Gowall provides:
- Automatic wallpaper rotation
- Support for multiple displays
- Built-in wallpaper sources
- Efficient macOS integration

For gowall-specific options, pass them directly:

```bash
wallpaper --help           # Show gowall help
wallpaper --interval 300   # Change wallpaper every 5 minutes
```

### Linux (fzf selector)

On Linux, the module provides an interactive fzf-based selector:

```bash
wallpaper
```

**Navigation:**
- `↑`/`↓` or `j`/`k` - Navigate through wallpapers
- `Enter` - Select wallpaper
- `Esc` or `Ctrl-c` - Cancel

**Preview:**
- Kitty terminal: Full image preview using kitty's icat
- Fallback: Text-based info (filename, size, dimensions)

### Current Wallpaper

The current wallpaper is tracked via symlink at:
```
~/.local/state/current-wallpaper
```

## Platform-Specific Details

### macOS

- Uses `gowall` (Homebrew package)
- Integrates with macOS desktop settings
- Supports multiple displays
- Automatic wallpaper rotation

### Linux

- Uses fzf for interactive selection
- Kitty terminal image preview
- ImageMagick for image information
- Manual wallpaper setting

## Troubleshooting

### macOS: gowall not found

Install gowall via Homebrew:
```bash
brew install gowall
```

### Linux: No wallpapers found

Ensure your wallpaper directory exists and contains supported images:
```bash
mkdir -p ~/.config/dotfiles/images/wallpapers
```

### Preview not working (Linux)

1. For kitty preview, ensure you're using kitty terminal
2. For dimensions, ImageMagick is required (included automatically)

## Example Structure

```
~/.config/dotfiles/images/wallpapers/
├── nature/
│   ├── forest.jpg
│   └── ocean.png
├── abstract/
│   └── geometric.webp
└── minimal/
    └── dark.jpg
```

The selector will find all images recursively.
