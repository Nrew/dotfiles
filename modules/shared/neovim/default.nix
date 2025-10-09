{ config, lib, pkgs, palette, ... }:

let
  # Core tools needed for all languages
  coreTools = with pkgs; [
    ripgrep fd curl unzip git tree-sitter
    lazygit prettierd stylua nixfmt-rfc-style
    yazi
  ];



  # Language servers organized by category
  languageServers = {
    lua = [ pkgs.lua-language-server ];
    nix = [ pkgs.nixd pkgs.nixfmt-rfc-style ];
    typescript = [ pkgs.typescript-language-server pkgs.nodejs pkgs.eslint_d ];
    python = [ pkgs.pyright pkgs.black pkgs.ruff ];
    rust = [ pkgs.rust-analyzer pkgs.rustfmt ];
    go = [ pkgs.gopls pkgs.delve pkgs.gotools pkgs.go-tools ];
    c = [ pkgs.clang-tools pkgs.clang ];
  };

  themePalette = ''
    -- Dynamic theme palette loader - reads from symlinked theme file
    local M = {}
    
    -- Fallback palette built into the config
    local fallback_palette = {
      base = "${palette.base}",
      mantle = "${palette.mantle}",
      surface = "${palette.surface}",
      overlay = "${palette.overlay}",
      text = "${palette.text}",
      subtext0 = "${palette.subtext0}",
      subtext1 = "${palette.subtext1}",
      muted = "${palette.muted}",
      primary = "${palette.primary}",
      secondary = "${palette.secondary}",
      red = "${palette.red}",
      orange = "${palette.orange}",
      yellow = "${palette.yellow}",
      green = "${palette.green}",
      cyan = "${palette.cyan}",
      blue = "${palette.blue}",
    }
    
    -- Load palette from the current theme symlink or fallback
    function M.get()
      local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
      local palette_file = config_home .. "/current-theme/nvim-palette.lua"
      
      -- Check if file exists before trying to load it
      local file = io.open(palette_file, "r")
      if not file then
        return fallback_palette
      end
      file:close()
      
      -- Clear any cached version
      package.loaded[palette_file] = nil
      
      local ok, palette = pcall(dofile, palette_file)
      if not ok or not palette then
        return fallback_palette
      end
      
      return palette
    end
    
    return M
  '';

  # Define all plugins for lazy.nvim
  plugins = with pkgs.vimPlugins; [
    # Theme & UI
    telescope-nvim telescope-fzf-native-nvim
    lualine-nvim nvim-web-devicons bufferline-nvim
    
    # File management & navigation
    neo-tree-nvim nvim-window-picker which-key-nvim
    
    # LSP & completion
    nvim-lspconfig blink-cmp trouble-nvim
    luasnip
    friendly-snippets

    # Treesitter with comprehensive parsers
    (nvim-treesitter.withPlugins (p: with p; [
      lua vim vimdoc query bash comment regex
      html css javascript typescript tsx
      python rust go nix c cpp make
      json json5 yaml toml markdown markdown_inline
      gitattributes gitignore
    ]))
    nvim-treesitter-context nvim-ts-autotag nvim-treesitter-textobjects
    
    # Editing enhancements
    comment-nvim nvim-surround flash-nvim mini-pairs
    yanky-nvim
    
    # Visual improvements
    indent-blankline-nvim noice-nvim nvim-notify dressing-nvim
    
    # Git integration
    gitsigns-nvim lazygit-nvim
    
    # Development tools
    todo-comments-nvim
    
    # Session & project management
    persistence-nvim project-nvim
    
    # File browser
    yazi-nvim
    
    # Utils
    plenary-nvim nui-nvim mini-icons
    stabilize-nvim
  ];

  # Helper function to create lazy.nvim plugin entries with dir
  mkEntryFromDrv = drv:
    if lib.isDerivation drv then
      { name = "${lib.getName drv}"; path = drv; }
    else
      drv;

  # Convert plugins to lazy.nvim format with paths
  lazyPath = p: "{ dir = '${mkEntryFromDrv p.path}' }";

in {
  config = {
    # Install Neovim with lazy.nvim support
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      
      extraPackages = coreTools ++ 
        (lib.flatten (lib.attrValues languageServers));
      
      plugins = with pkgs.vimPlugins; [
        # Install lazy.nvim
        lazy-nvim
      ] ++ plugins;

      extraLuaConfig = 
        let
          pluginEntries = map mkEntryFromDrv plugins;
          mkLazySpec = entry: "  { dir = '${entry.path}', name = '${entry.name}' },";
          lazySpecs = lib.concatStringsSep "\n" (map mkLazySpec pluginEntries);
        in
        ''
          -- Lazy.nvim plugin specs generated from Nix
          local lazy_plugins = {
          ${lazySpecs}
          }
          
          -- Load user init.lua which will use these plugins
          vim.g.nix_lazy_plugins = lazy_plugins
        '';
    };
    # Write the theme palette to the correct Neovim config location
    xdg.configFile."nvim/lua/theme/palette.lua".text = themePalette;
    
    # Also generate a custom colorscheme that uses the palette
    xdg.configFile."nvim/colors/dynamic.lua".text = ''
      -- Dynamic colorscheme generated from Nix theme system
      -- This file is auto-generated - do not edit manually
      
      vim.cmd('hi clear')
      if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
      end
      
      vim.g.colors_name = 'dynamic'
      vim.o.background = 'dark'
      
      -- Load palette from the theme system
      local ok, palette_module = pcall(require, 'theme.palette')
      if not ok then
        vim.notify('Failed to load theme palette', vim.log.levels.ERROR)
        return
      end
      
      local palette = palette_module.get()
      
      -- UI Elements
      vim.api.nvim_set_hl(0, 'Normal', { fg = palette.text, bg = palette.base })
      vim.api.nvim_set_hl(0, 'NormalFloat', { fg = palette.text, bg = palette.surface })
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = palette.overlay, bg = palette.surface })
      vim.api.nvim_set_hl(0, 'FloatTitle', { fg = palette.primary, bg = palette.surface, bold = true })
      
      vim.api.nvim_set_hl(0, 'Cursor', { fg = palette.base, bg = palette.text })
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = palette.primary, bold = true })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = palette.muted })
      vim.api.nvim_set_hl(0, 'SignColumn', { fg = palette.text, bg = palette.base })
      
      vim.api.nvim_set_hl(0, 'Visual', { bg = palette.overlay })
      vim.api.nvim_set_hl(0, 'VisualNOS', { bg = palette.overlay })
      
      vim.api.nvim_set_hl(0, 'Search', { fg = palette.base, bg = palette.yellow, bold = true })
      vim.api.nvim_set_hl(0, 'IncSearch', { fg = palette.base, bg = palette.orange, bold = true })
      vim.api.nvim_set_hl(0, 'CurSearch', { fg = palette.base, bg = palette.primary, bold = true })
      
      vim.api.nvim_set_hl(0, 'VertSplit', { fg = palette.overlay })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = palette.overlay })
      
      vim.api.nvim_set_hl(0, 'StatusLine', { fg = palette.text, bg = palette.surface })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = palette.muted, bg = palette.mantle })
      
      vim.api.nvim_set_hl(0, 'TabLine', { fg = palette.muted, bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'TabLineFill', { bg = palette.base })
      vim.api.nvim_set_hl(0, 'TabLineSel', { fg = palette.text, bg = palette.surface })
      
      vim.api.nvim_set_hl(0, 'Pmenu', { fg = palette.text, bg = palette.surface })
      vim.api.nvim_set_hl(0, 'PmenuSel', { fg = palette.base, bg = palette.primary, bold = true })
      vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = palette.overlay })
      
      vim.api.nvim_set_hl(0, 'Folded', { fg = palette.subtext0, bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'FoldColumn', { fg = palette.muted, bg = palette.base })
      
      -- Syntax Highlighting
      vim.api.nvim_set_hl(0, 'Comment', { fg = palette.muted, italic = true })
      vim.api.nvim_set_hl(0, 'Constant', { fg = palette.orange })
      vim.api.nvim_set_hl(0, 'String', { fg = palette.green })
      vim.api.nvim_set_hl(0, 'Character', { fg = palette.green })
      vim.api.nvim_set_hl(0, 'Number', { fg = palette.orange })
      vim.api.nvim_set_hl(0, 'Boolean', { fg = palette.orange })
      vim.api.nvim_set_hl(0, 'Float', { fg = palette.orange })
      
      vim.api.nvim_set_hl(0, 'Identifier', { fg = palette.text })
      vim.api.nvim_set_hl(0, 'Function', { fg = palette.secondary })
      
      vim.api.nvim_set_hl(0, 'Statement', { fg = palette.primary })
      vim.api.nvim_set_hl(0, 'Conditional', { fg = palette.primary })
      vim.api.nvim_set_hl(0, 'Repeat', { fg = palette.primary })
      vim.api.nvim_set_hl(0, 'Label', { fg = palette.primary })
      vim.api.nvim_set_hl(0, 'Operator', { fg = palette.subtext0 })
      vim.api.nvim_set_hl(0, 'Keyword', { fg = palette.primary })
      vim.api.nvim_set_hl(0, 'Exception', { fg = palette.red })
      
      vim.api.nvim_set_hl(0, 'PreProc', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'Include', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'Define', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'Macro', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'PreCondit', { fg = palette.cyan })
      
      vim.api.nvim_set_hl(0, 'Type', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'StorageClass', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'Structure', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'Typedef', { fg = palette.cyan })
      
      vim.api.nvim_set_hl(0, 'Special', { fg = palette.blue })
      vim.api.nvim_set_hl(0, 'SpecialChar', { fg = palette.blue })
      vim.api.nvim_set_hl(0, 'Tag', { fg = palette.primary })
      vim.api.nvim_set_hl(0, 'Delimiter', { fg = palette.subtext1 })
      vim.api.nvim_set_hl(0, 'SpecialComment', { fg = palette.subtext0, italic = true })
      vim.api.nvim_set_hl(0, 'Debug', { fg = palette.red })
      
      vim.api.nvim_set_hl(0, 'Underlined', { underline = true })
      vim.api.nvim_set_hl(0, 'Error', { fg = palette.red })
      vim.api.nvim_set_hl(0, 'Todo', { fg = palette.yellow, bold = true })
      
      -- Treesitter
      vim.api.nvim_set_hl(0, '@variable', { fg = palette.text })
      vim.api.nvim_set_hl(0, '@variable.builtin', { fg = palette.red })
      vim.api.nvim_set_hl(0, '@variable.parameter', { fg = palette.text })
      vim.api.nvim_set_hl(0, '@variable.member', { fg = palette.text })
      
      vim.api.nvim_set_hl(0, '@constant', { fg = palette.orange })
      vim.api.nvim_set_hl(0, '@constant.builtin', { fg = palette.orange })
      vim.api.nvim_set_hl(0, '@constant.macro', { fg = palette.orange })
      
      vim.api.nvim_set_hl(0, '@string', { fg = palette.green })
      vim.api.nvim_set_hl(0, '@string.escape', { fg = palette.blue })
      vim.api.nvim_set_hl(0, '@string.special', { fg = palette.blue })
      
      vim.api.nvim_set_hl(0, '@character', { fg = palette.green })
      vim.api.nvim_set_hl(0, '@number', { fg = palette.orange })
      vim.api.nvim_set_hl(0, '@boolean', { fg = palette.orange })
      vim.api.nvim_set_hl(0, '@float', { fg = palette.orange })
      
      vim.api.nvim_set_hl(0, '@function', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@function.builtin', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@function.macro', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@function.call', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@method', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@method.call', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@constructor', { fg = palette.cyan })
      
      vim.api.nvim_set_hl(0, '@keyword', { fg = palette.primary })
      vim.api.nvim_set_hl(0, '@keyword.function', { fg = palette.primary })
      vim.api.nvim_set_hl(0, '@keyword.operator', { fg = palette.primary })
      vim.api.nvim_set_hl(0, '@keyword.return', { fg = palette.primary })
      
      vim.api.nvim_set_hl(0, '@conditional', { fg = palette.primary })
      vim.api.nvim_set_hl(0, '@repeat', { fg = palette.primary })
      vim.api.nvim_set_hl(0, '@label', { fg = palette.primary })
      vim.api.nvim_set_hl(0, '@operator', { fg = palette.subtext0 })
      vim.api.nvim_set_hl(0, '@exception', { fg = palette.red })
      
      vim.api.nvim_set_hl(0, '@type', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@type.builtin', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@type.qualifier', { fg = palette.primary })
      
      vim.api.nvim_set_hl(0, '@property', { fg = palette.text })
      vim.api.nvim_set_hl(0, '@field', { fg = palette.text })
      
      vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = palette.subtext1 })
      vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = palette.subtext0 })
      vim.api.nvim_set_hl(0, '@punctuation.special', { fg = palette.blue })
      
      vim.api.nvim_set_hl(0, '@comment', { fg = palette.muted, italic = true })
      
      vim.api.nvim_set_hl(0, '@tag', { fg = palette.primary })
      vim.api.nvim_set_hl(0, '@tag.attribute', { fg = palette.text })
      vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = palette.subtext1 })
      
      -- LSP Semantic Tokens
      vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@lsp.type.decorator', { fg = palette.blue })
      vim.api.nvim_set_hl(0, '@lsp.type.enum', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@lsp.type.enumMember', { fg = palette.orange })
      vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@lsp.type.interface', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@lsp.type.macro', { fg = palette.orange })
      vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = palette.secondary })
      vim.api.nvim_set_hl(0, '@lsp.type.namespace', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = palette.text })
      vim.api.nvim_set_hl(0, '@lsp.type.property', { fg = palette.text })
      vim.api.nvim_set_hl(0, '@lsp.type.struct', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@lsp.type.type', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, '@lsp.type.variable', { fg = palette.text })
      
      -- Diagnostics
      vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = palette.red })
      vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = palette.yellow })
      vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = palette.cyan })
      vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = palette.blue })
      
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = palette.red, bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = palette.yellow, bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = palette.cyan, bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = palette.blue, bg = palette.mantle })
      
      vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { sp = palette.red, undercurl = true })
      vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { sp = palette.yellow, undercurl = true })
      vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { sp = palette.cyan, undercurl = true })
      vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { sp = palette.blue, undercurl = true })
      
      -- Git signs
      vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = palette.green })
      vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = palette.yellow })
      vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = palette.red })
      
      -- Telescope
      vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = palette.overlay, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopeNormal', { fg = palette.text, bg = palette.base })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = palette.overlay, bg = palette.surface })
      vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { fg = palette.text, bg = palette.surface })
      vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = palette.text, bg = palette.overlay, bold = true })
      vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = palette.primary, bold = true })
      
      -- Neo-tree
      vim.api.nvim_set_hl(0, 'NeoTreeNormal', { fg = palette.text, bg = palette.base })
      vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { fg = palette.text, bg = palette.base })
      vim.api.nvim_set_hl(0, 'NeoTreeDirectoryIcon', { fg = palette.primary })
      vim.api.nvim_set_hl(0, 'NeoTreeRootName', { fg = palette.primary, bold = true })
      vim.api.nvim_set_hl(0, 'NeoTreeGitModified', { fg = palette.yellow })
      vim.api.nvim_set_hl(0, 'NeoTreeGitAdded', { fg = palette.green })
      vim.api.nvim_set_hl(0, 'NeoTreeGitDeleted', { fg = palette.red })
    '';
    
    # Copy the Lua configuration to Neovim config directory
    xdg.configFile."nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    
    # Copy init.lua
    xdg.configFile."nvim/init.lua".source = ./init.lua;
  };
}
