# Dynamic Theme System Architecture

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     USER INTERACTION                             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  theme-switch    │
                    │  <theme-name>    │
                    └──────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────┐
        │  Updates ~/.config/theme/current.json       │
        │  Updates ~/.config/theme/palette.json       │
        └─────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     NEOVIM DETECTION                             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  FocusGained or  │
                    │  BufEnter Event  │
                    └──────────────────┘
                              │
                              ▼
                ┌──────────────────────────────┐
                │  Check theme file mtime      │
                │  (modification time)         │
                └──────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
            ┌──────────────┐    ┌──────────────┐
            │  No Change   │    │   Changed!   │
            └──────────────┘    └──────────────┘
                    │                   │
                    ▼                   ▼
            ┌──────────────┐    ┌──────────────────────────┐
            │  Do Nothing  │    │  Clear palette cache     │
            └──────────────┘    │  Call apply_theme()      │
                                └──────────────────────────┘
                                            │
                                            ▼
                        ┌───────────────────────────────────┐
                        │  Dynamic Palette Loader           │
                        │  (theme.palette.get())            │
                        └───────────────────────────────────┘
                                            │
                            ┌───────────────┴───────────────┐
                            ▼                               ▼
                ┌─────────────────────┐       ┌──────────────────────┐
                │  Load from JSON     │       │  Fallback to         │
                │  (runtime theme)    │       │  build-time palette  │
                └─────────────────────┘       └──────────────────────┘
                            │                               │
                            └───────────────┬───────────────┘
                                            ▼
                            ┌───────────────────────────────┐
                            │  Configure rose-pine theme    │
                            │  with current palette         │
                            └───────────────────────────────┘
                                            │
                                            ▼
                            ┌───────────────────────────────┐
                            │  Apply custom highlights      │
                            └───────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      VISUAL RESULT                               │
│              🎨 Theme Updated in Neovim! 🎨                     │
└─────────────────────────────────────────────────────────────────┘
```

## Alternative: Manual Reload

```
                    ┌──────────────────┐
                    │  User presses    │
                    │  <leader>uC      │
                    │  or :ThemeReload │
                    └──────────────────┘
                              │
                              ▼
                ┌──────────────────────────────┐
                │  Clear palette cache         │
                │  Call apply_theme()          │
                └──────────────────────────────┘
                              │
                              ▼
                    (Same flow as above)
```

## Key Components

### 1. Dynamic Palette Loader (`modules/shared/neovim/default.nix`)
- Written by Nix to `~/.config/nvim/lua/theme/palette.lua`
- Module with `get()` function
- Tries runtime JSON first, falls back to build-time palette

### 2. Theme Plugin (`lua/plugins/theme.lua`)
- Loads palette using dynamic loader
- Watches theme file for changes
- Applies theme to rose-pine and custom highlights
- Provides manual reload commands

### 3. File Watcher Autocmd
- Monitors `~/.config/theme/palette.json`
- Triggers on `FocusGained` and `BufEnter`
- Compares modification time
- Reloads only if changed

### 4. Theme Switch Script (`modules/shared/theme/default.nix`)
- Shell script: `theme-switch <name>`
- Updates JSON theme files
- Reloads other applications (kitty, tmux, etc.)

## Data Flow

### Build Time (Nix Evaluation)
```
Nix Config (default.nix)
    │
    ├─> Generate dynamic palette loader
    │   (with build-time fallback palette)
    │
    └─> Generate ~/.config/nvim/lua/theme/palette.lua
```

### Runtime (Theme Switching)
```
theme-switch command
    │
    ├─> Update ~/.config/theme/current.json
    │   {"variant": "beige", "custom": null}
    │
    └─> Update ~/.config/theme/palette.json
        {"variant": "beige", "colors": {...}, ...}
```

### Runtime (Neovim Detection)
```
Neovim Event (Focus/BufEnter)
    │
    ├─> Check file mtime
    │
    ├─> If changed:
    │   │
    │   ├─> Clear palette cache
    │   │
    │   ├─> Call palette.get()
    │   │   │
    │   │   ├─> Try: Read ~/.config/theme/palette.json
    │   │   │
    │   │   └─> Fallback: Use build-time palette
    │   │
    │   └─> Apply to rose-pine and highlights
    │
    └─> Theme updated!
```

## Advantages

1. **No Rebuild Required**: Theme changes apply without `nixos-rebuild` or `darwin-rebuild`
2. **Instant Feedback**: See theme changes immediately on focus
3. **Fallback Safety**: Always has build-time palette as backup
4. **Manual Control**: Can force reload with keybinding or command
5. **Efficient**: Only checks/reloads when necessary (on focus/buffer change)

## File Locations

- **Dynamic loader**: `~/.config/nvim/lua/theme/palette.lua` (generated by Nix)
- **Runtime theme**: `~/.config/theme/palette.json` (updated by theme-switch)
- **Current theme**: `~/.config/theme/current.json` (updated by theme-switch)
- **Theme plugin**: `modules/shared/neovim/lua/plugins/theme.lua` (in repo)
- **Nix config**: `modules/shared/neovim/default.nix` (in repo)
