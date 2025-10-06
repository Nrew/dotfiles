# Wallpaper Module

A Nix-focused wallpaper management module for nix-darwin that provides interactive wallpaper selection with live preview.

## Features

- 🖼️ Interactive wallpaper selection using fzf
- 👁️ Live image preview in kitty terminal
- 🎨 Theme-aware color scheme
- 📁 Supports multiple image formats (jpg, jpeg, png, webp)
- 🔗 Tracks current wallpaper via symlink
- ✅ Full Nix store path integration

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

### Select a Wallpaper

Run the wallpaper selector:

```bash
wallpaper
# or use the alias
wp
```

### Navigation

- `↑`/`↓` or `j`/`k` - Navigate through wallpapers
- `Enter` - Select wallpaper
- `Ctrl-d` - Scroll preview down
- `Ctrl-u` - Scroll preview up
- `Esc` or `Ctrl-c` - Cancel

### Current Wallpaper

The current wallpaper is tracked via symlink at:
```
~/.local/state/current-wallpaper
```

## Image Preview

The module supports two preview modes:

1. **Kitty Terminal** (recommended)
   - Full image preview using kitty's icat
   - Renders actual image in the preview pane
   
2. **Fallback Mode**
   - Text-based preview showing:
     - Filename
     - File size
     - Image dimensions (requires ImageMagick)

## Technical Details

### Dependencies

All dependencies are automatically installed via Nix:
- `findutils` - File searching
- `imagemagick` - Image information
- `fzf` - Interactive selection
- `kitty` - Image preview (optional, for better UX)

### Nix Integration

The module uses several Nix best practices:

1. **Store Paths**: All utilities use explicit Nix store paths
2. **String Interpolation**: Image formats defined in Nix, not shell
3. **Type Safety**: Configuration validated at build time
4. **Assertions**: Directory path validation

### macOS Integration

Uses native macOS System Events to set wallpaper:
```applescript
tell application "System Events" to tell every desktop to set picture to "<path>"
```

## Troubleshooting

### No wallpapers found

Ensure your wallpaper directory exists and contains supported image formats:
```bash
mkdir -p ~/.config/dotfiles/images/wallpapers
```

### Preview not working

1. For kitty preview, ensure you're using kitty terminal
2. For dimensions, ImageMagick is required (included automatically)

### Wallpaper not applying

Check that you have proper permissions and System Events access on macOS.

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
