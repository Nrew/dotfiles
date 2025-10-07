{ config, lib, pkgs, inputs, palette, ... }:

let
  utils = inputs.nixCats.utils;

  # Core tools needed for all languages
  coreTools = with pkgs; [
    ripgrep fd curl unzip git tree-sitter
    lazygit prettierd stylua nixfmt-rfc-style
  ];

  # Essential plugins with preserved functionality
  corePlugins = with pkgs.vimPlugins; [
    # Theme & UI
    rose-pine telescope-nvim telescope-fzf-native-nvim
    lualine-nvim nvim-web-devicons bufferline-nvim
    
    # File management & navigation
    neo-tree-nvim nvim-window-picker which-key-nvim
    
    # LSP & completion
    nvim-lspconfig blink-cmp trouble-nvim
    
    # Treesitter with comprehensive parsers
    (nvim-treesitter.withPlugins (p: with p; [
      lua vim vimdoc query bash comment
      html css javascript typescript tsx
      python rust go nix c cpp make
      json json5 yaml toml markdown markdown_inline
      gitattributes gitignore
    ]))
    nvim-treesitter-context nvim-ts-autotag nvim-treesitter-textobjects
    
    # Editing enhancements
    comment-nvim nvim-surround flash-nvim mini-pairs
    yanky-nvim # Yank ring
    
    # Visual improvements
    indent-blankline-nvim noice-nvim nvim-notify dressing-nvim
    
    # Git integration
    gitsigns-nvim lazygit-nvim
    
    # Development tools
    todo-comments-nvim
    
    # Session & project management
    persistence-nvim project-nvim
    
    # File manager
    yazi-nvim
    
    # Additional useful plugins from your original config
    mini-icons stabilize-nvim vim-bbye
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

  # Dynamic theme palette loader for neovim
  # Instead of writing static colors, we create a loader that reads from the runtime theme
  themePalette = ''
    -- Dynamic theme palette loader - reads from runtime theme files
    local M = {}
    
    -- Try to load theme from runtime config first (updated by theme-switch)
    local function load_from_json()
      local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
      local theme_file = config_home .. "/theme/palette.json"
      
      local file = io.open(theme_file, "r")
      if not file then
        return nil
      end
      
      local content = file:read("*all")
      file:close()
      
      local ok, decoded = pcall(vim.json.decode, content)
      if not ok or not decoded or not decoded.colors then
        return nil
      end
      
      return decoded.colors
    end
    
    -- Fallback to build-time palette
    local function get_fallback()
      return {
        -- Base colors (4)
        base = "${palette.base}",
        mantle = "${palette.mantle}",
        surface = "${palette.surface}",
        overlay = "${palette.overlay}",
        
        -- Text colors (4)
        text = "${palette.text}",
        subtext0 = "${palette.subtext0}",
        subtext1 = "${palette.subtext1}",
        muted = "${palette.muted}",
        
        -- Accent colors (8)
        primary = "${palette.primary}",
        secondary = "${palette.secondary}",
        red = "${palette.red}",
        orange = "${palette.orange}",
        yellow = "${palette.yellow}",
        green = "${palette.green}",
        cyan = "${palette.cyan}",
        blue = "${palette.blue}",
        
        -- Backward compatibility aliases
        background = "${palette.background}",
        subtext = "${palette.subtext}",
        success = "${palette.success}",
        warning = "${palette.warning}",
        error = "${palette.error}",
        info = "${palette.info}",
        border = "${palette.border}",
        selection = "${palette.selection}",
        cursor = "${palette.cursor}",
        link = "${palette.link}",
      }
    end
    
    -- Get the current palette (runtime or fallback)
    function M.get()
      return load_from_json() or get_fallback()
    end
    
    return M
  '';

in {
  imports = [ inputs.nixCats.homeModule ];

  config = {
    # Write the theme palette directly to the neovim config directory
    home.file.".config/nvim/lua/theme/palette.lua".text = themePalette;

    nixCats = {
      enable = true;
      addOverlays = [ (utils.standardPluginOverlay inputs) ];
      packageNames = [ "nvim" ];
      luaPath = ./.;

      categoryDefinitions.replace = ({ pkgs, ... }: {
        lspsAndRuntimeDep = {
          general = coreTools;
        } // languageServers;

        startupPlugins = {
          general = corePlugins;
        };

        optionalPlugins = {};
        sharedLibraries = {};
        environmentVariables = {};
        python3.libraries = {};
        extraWrapperArgs = {};
      });

      packageDefinitions.replace = {
        nvim = { pkgs, ... }: {
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            aliases = [ "vim" ];
            hosts.python3.enable = true;
            hosts.node.enable = true;
          };

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

          extra = {
            # Provide nixpkgs path for nixd LSP
            nixdExtras.nixpkgs = ''import ${pkgs.path} { }'';
          };
        };
      };
    };
  };
}