# Neovim Configuration

This Neovim configuration uses [nixCats](https://github.com/BirdeeHub/nixCats-nvim) for plugin and dependency management, integrated with Nix for reproducible development environments.

## Architecture

### Plugin Management
- **nixCats**: Manages plugins and their dependencies through Nix
- Plugins are defined in `default.nix` and loaded via Lua configs in `lua/plugins/`
- Each plugin has a corresponding Lua module that exports a `setup()` function

### Theme System
- Dynamic theme loading from Nix-generated palette files
- Fallback palettes built into the configuration
- Theme files are symlinked from `~/.config/current-theme/nvim-palette.lua`
- Automatic theme reloading when theme files change

### Structure
```
neovim/
├── default.nix           # Nix configuration (plugins, LSPs, tools)
├── init.lua              # Main entry point
├── lua/
│   ├── core/            # Core Neovim settings
│   │   ├── options.lua  # Vim options
│   │   ├── keymaps.lua  # Key mappings
│   │   └── autocmds.lua # Autocommands
│   └── plugins/         # Plugin configurations
│       ├── theme.lua    # Theme/colorscheme setup
│       ├── telescope.lua # Fuzzy finder
│       ├── lsp.lua      # LSP configuration
│       └── ...          # Other plugins
└── colors/
    └── dynamic.lua      # Generated colorscheme
```

## Key Features

### LSP Support
Language servers are conditionally enabled based on nixCats categories:
- **Lua**: lua-language-server
- **Nix**: nixd with formatter support
- **TypeScript/JavaScript**: typescript-language-server + eslint_d
- **Python**: pyright + black + ruff
- **Rust**: rust-analyzer + rustfmt
- **Go**: gopls + delve + go tools
- **C/C++**: clangd

### Core Plugins
- **Telescope**: Fuzzy finder (fixed mapping bugs)
- **Neo-tree**: File explorer
- **Treesitter**: Syntax highlighting
- **Blink Completion**: Fast completion engine
- **LSP**: Built-in LSP support
- **Gitsigns**: Git integration
- **Lualine**: Status line
- **Which-key**: Keybinding hints

## Recent Fixes

### Telescope Bug Fixes (2024)
1. Fixed undefined `telescope_config` variable
2. Fixed incorrect quickfix list mapping syntax
3. Fixed API call: `vim.log.level.WARN` → `vim.log.levels.WARN`
4. Removed duplicate `telescope.setup()` call
5. Improved FZF sorter availability checking

### Theme Loading Improvements
1. Added file existence checks before loading theme files
2. Built-in fallback palette to prevent crashes
3. Improved error handling and notifications
4. Added nil check for timer creation

## Usage

### Theme Reload
- Manual reload: `<leader>uC` or `:ThemeReload`
- Automatic: Reloads when theme file changes

### File Navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fr` - Recent files
- `<leader>e` - Toggle file explorer

### LSP
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code action
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format code

## Development

The configuration is designed to be:
1. **Reproducible**: All dependencies managed through Nix
2. **Robust**: Proper error handling and fallbacks
3. **Fast**: Deferred plugin loading for quick startup
4. **Maintainable**: Clear structure and documentation
