{ pkgs, inputs, ... }:

let
  utils = inputs.nixCats.utils;

  # Core tools needed for all languages
  coreTools = with pkgs; [
    ripgrep fd curl unzip git tree-sitter
    lazygit prettierd stylua nixfmt-rfc-style
    yazi
  ];

  # Plugins
  corePlugins = with pkgs.vimPlugins; [
    lze lzextras
    # Theme & UI
    telescope-nvim telescope-fzf-native-nvim
    lualine-nvim nvim-web-devicons bufferline-nvim
    
    # File management & navigation
    neo-tree-nvim nvim-window-picker which-key-nvim
    
    # LSP & completion
    blink-cmp trouble-nvim
    luasnip friendly-snippets

    # Treesitter with all grammars
    nvim-treesitter.withAllGrammars
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
    
    # Theme
    catppuccin-nvim
    
    # Utils
    plenary-nvim nui-nvim mini-icons
    stabilize-nvim
    snacks-nvim
    vim-sleuth
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

in {

  imports = [
    inputs.nixCats.homeModule
  ];

  config = {
    
    # Enable Catppuccin theme for neovim
    # Colors are automatically applied by the catppuccin module
    catppuccin.nvim.enable = true;

    nixCats = {
      enable = true;
      addOverlays = [ (utils.standardPluginOverlay inputs) ];
      packageNames = [ "nvim" ];
      luaPath = ./.;

      categoryDefinitions.replace = ({ pkgs, ... }: {
        lspsAndRuntimeDeps = {
          general = coreTools;
        } // languageServers;

        startupPlugins = {
          general = corePlugins;
        };

        optionalPlugins = {};
        sharedLibraries = { general = with pkgs; []; };
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
            go = false;
            c = true;
          };
          extra = {
            nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };
    };
  };
}
