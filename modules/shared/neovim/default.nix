{ config, lib, pkgs, inputs, ... }:

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
    
    # Visual improvements
    indent-blankline-nvim noice-nvim nvim-notify dressing-nvim
    
    # Git integration
    gitsigns-nvim lazygit-nvim
    
    # Development tools
    todo-comments-nvim
    
    # Additional useful plugins from your original config
    mini-icons stabilize-nvim vim-bbye
  ];

  # Language servers organized by category
  languageServers = {
    lua = [ pkgs.lua-language-server ];
    nix = [ pkgs.nixd ];
    typescript = [ pkgs.typescript-language-server pkgs.nodejs pkgs.eslint ];
    python = [ pkgs.pyright pkgs.black pkgs.flake8 pkgs.isort ];
    rust = [ pkgs.rust-analyzer pkgs.rustfmt pkgs.cargo ];
    go = [ pkgs.gopls pkgs.delve pkgs.golint pkgs.golangci-lint pkgs.gotools pkgs.go-tools pkgs.go ];
    c = [ pkgs.clang pkgs.gcc pkgs.cmake ];
  };

in {
  imports = [ inputs.nixCats.homeModule ];

  config = {
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
            nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };
    };
  };
}