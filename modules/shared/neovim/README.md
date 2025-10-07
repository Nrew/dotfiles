# NixCats Neovim Configuration

This is a comprehensive Neovim configuration built with [nixCats](https://github.com/BirdeeHub/nixCats-nvim), providing a modern, feature-rich editing experience with dynamic theme support.

## 🎨 Dynamic Theme System

The theme system supports **live theme switching without rebuilding** your Nix configuration!

### How It Works

1. **Dynamic Palette Loader**: Instead of hard-coding theme colors at build time, Neovim reads the current theme from `~/.config/theme/palette.json` at runtime
2. **Auto-reload on Focus**: When you switch themes using `theme-switch`, Neovim automatically detects the change and reloads when you focus the window
3. **Manual Reload**: Use `<leader>uC` or `:ThemeReload` to force an immediate theme reload

### Theme Commands

```bash
# List available themes
theme-list

# Switch to a theme (live, no rebuild needed!)
theme-switch <theme-name>

# Generate theme from wallpaper
theme-from-wallpaper [image-path]

# Show current theme info
theme-info
```

### In Neovim

- **`<leader>uC`**: Reload colorscheme
- **`:ThemeReload`**: Reload colorscheme (command)

The theme will also auto-reload when you:
- Focus Neovim after running `theme-switch`
- Enter a buffer after a theme change

## 🔌 Plugin System

### Core Plugins

#### Theme & UI
- **rose-pine**: Beautiful color scheme (dynamically configured)
- **telescope**: Fuzzy finder
- **lualine**: Status line
- **bufferline**: Buffer tabs
- **which-key**: Keybinding hints

#### File Management
- **neo-tree**: File explorer
- **yazi**: Terminal file manager integration
- **project.nvim**: Project management

#### LSP & Completion
- **nvim-lspconfig**: LSP client configurations
- **blink.cmp**: Fast, modern completion engine
- **trouble**: Beautiful diagnostics list

#### Treesitter
- Comprehensive language support
- **treesitter-context**: Show context at top of screen
- **nvim-ts-autotag**: Auto close/rename HTML tags
- **treesitter-textobjects**: Smart text objects

#### Editing
- **comment.nvim**: Smart commenting
- **nvim-surround**: Surround text objects
- **flash.nvim**: Fast navigation
- **mini.pairs**: Auto pairs
- **yanky**: Enhanced yank/paste with history

#### Visual
- **indent-blankline**: Indent guides
- **noice**: Better command line and notifications
- **nvim-notify**: Notification manager
- **dressing**: Better UI components

#### Git
- **gitsigns**: Git decorations
- **lazygit**: LazyGit integration

#### Utilities
- **todo-comments**: Highlight TODOs
- **persistence**: Session management
- **vim-bbye**: Better buffer deletion

### Language Support

The configuration automatically enables LSP servers based on enabled categories:

- **Lua**: lua_ls (with nixCats support)
- **Nix**: nixd (with flake integration)
- **TypeScript/JavaScript**: tsserver
- **Python**: pyright
- **Rust**: rust-analyzer
- **Go**: gopls
- **C/C++**: clangd

Language servers are only loaded if their category is enabled in your nixCats configuration.

## ⌨️ Key Mappings

### Leader Key
Space (`<space>`) is the leader key.

### Navigation
- `<C-h/j/k/l>`: Navigate windows
- `j/k`: Smart line navigation (gj/gk for wrapped lines)
- `[b/]b`: Previous/next buffer
- `[d/]d`: Previous/next diagnostic

### Windows
- `<leader>-`: Split horizontally
- `<leader>|`: Split vertically
- `<C-Up/Down/Left/Right>`: Resize windows

### File Operations
- `<leader>e`: Toggle Neo-tree file explorer
- `<leader>ff`: Find files (Telescope)
- `<leader>fg`: Live grep (Telescope)
- `<leader>fb`: Find buffers (Telescope)
- `<leader>fr`: Recent files (Telescope)
- `<leader>-`: Open Yazi at current file
- `<leader>cw`: Open Yazi in working directory

### LSP
- `gd`: Go to definition
- `gD`: Go to declaration
- `gi`: Go to implementation
- `gr`: Find references
- `K`: Hover documentation
- `<C-k>`: Signature help
- `<leader>D`: Type definition
- `<leader>rn`: Rename symbol
- `<leader>ca`: Code actions
- `<leader>cf`: Format code
- `<leader>cd`: Show diagnostic

### Git
- `<leader>gg`: Open LazyGit

### Sessions
- `<leader>qs`: Restore session
- `<leader>ql`: Restore last session
- `<leader>qd`: Don't save current session

### Theme
- `<leader>uC`: Reload colorscheme

### Editing
- `p/P`: Paste (with yanky)
- `<c-p/n>`: Cycle through yank history
- `<leader>v`: Incremental selection (treesitter)

## 🔧 Configuration Structure

```
modules/shared/neovim/
├── default.nix          # NixCats configuration
├── init.lua             # Entry point, plugin loader
├── lua/
│   ├── core/
│   │   ├── options.lua  # Vim options
│   │   ├── keymaps.lua  # Global keymaps
│   │   └── autocmds.lua # Autocommands
│   ├── plugins/         # Plugin configurations
│   │   ├── theme.lua    # Dynamic theme system
│   │   ├── lsp.lua      # LSP configuration
│   │   ├── completion.lua
│   │   ├── telescope.lua
│   │   ├── neo-tree.lua
│   │   └── ...
│   └── theme/
│       └── palette.lua  # Dynamic palette loader (generated)
```

## 🚀 NixCats Integration

This configuration uses nixCats for:

1. **Plugin Management**: All plugins are declared in Nix
2. **Language Server Management**: LSPs installed via Nix
3. **Category System**: Enable/disable language support via categories
4. **Tool Integration**: formatters, linters, etc.

### Enabled Categories

Categories are enabled in `default.nix`:

```nix
categories = {
  general = true;
  lua = true;
  nix = true;
  typescript = true;
  python = true;
  rust = true;
  go = true;
  c = true;
};
```

### Adding a New Plugin

1. Add to `corePlugins` in `default.nix`:
```nix
corePlugins = with pkgs.vimPlugins; [
  # ... existing plugins
  my-new-plugin
];
```

2. Create plugin config in `lua/plugins/my-plugin.lua`:
```lua
local M = {}

function M.setup()
  local ok, plugin = pcall(require, "my-plugin")
  if not ok then return end
  
  plugin.setup({
    -- configuration
  })
end

return M
```

3. Add to plugin loader in `init.lua`:
```lua
local plugins = {
  -- ... existing plugins
  "my-plugin"
}
```

## 📝 Notes

- The configuration uses **deferred loading** for better startup time
- Plugins are loaded 50ms after UI initialization
- Theme changes are detected automatically when switching focus
- All language servers use blink.cmp for completion
- Configuration is fully declarative via Nix

## 🐛 Troubleshooting

### Theme not updating
1. Try manual reload: `<leader>uC` or `:ThemeReload`
2. Check theme file exists: `cat ~/.config/theme/palette.json`
3. Verify theme palette loader: `:lua print(vim.inspect(require('theme.palette').get()))`

### LSP not working
1. Check category is enabled in `default.nix`
2. Verify LSP is running: `:LspInfo`
3. Check logs: `:lua vim.cmd('edit ' .. vim.lsp.get_log_path())`

### Plugin not loading
1. Check if plugin is in `corePlugins` list in `default.nix`
2. Verify plugin config exists in `lua/plugins/`
3. Check error in `:messages`
4. Look at plugin loading results (shown on startup)
