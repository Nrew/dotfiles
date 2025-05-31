{ config, lib, pkgs, inputs, ... }:

let
  utils = inputs.nixCats.utils;
  
  # Language-specific tool collections for better organization
  languageTools = {
    core = with pkgs; [
      lazygit ripgrep fd curl unzip git tree-sitter
      stdenv.cc.cc cmake gnumake
    ];

    formatters = with pkgs; [
      prettierd shfmt stylua nixfmt-rfc-style rustfmt black
    ];

    lua = with pkgs; [ lua-language-server ];
    nix = with pkgs; [ nixd ];
    go = with pkgs; [ gopls delve golint golangci-lint gotools go-tools go ];
    rust = with pkgs; [ rust-analyzer rustfmt cargo ];
    python = with pkgs; [ pyright black flake8 isort python3Packages.pynvim ];
    typescript = with pkgs; [ typescript-language-server nodejs yarn eslint ];
    c = with pkgs; [ gcc clang cmake ];
  };

  # Core plugin collections
  corePlugins = with pkgs.vimPlugins; [
    rose-pine telescope-nvim telescope-fzf-native-nvim which-key-nvim
    lualine-nvim nvim-web-devicons bufferline-nvim neo-tree-nvim
    trouble-nvim mini-icons
  ];
  
  # UI enhancement plugins
  uiPlugins = with pkgs.vimPlugins; [
    noice-nvim nvim-notify dressing-nvim indent-blankline-nvim
  ];
  
  # LSP and completion plugins
  lspPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig blink-cmp none-ls-nvim
  ];
  
  # Treesitter configuration with essential parsers
  treesitterConfig = with pkgs.vimPlugins; (nvim-treesitter.withPlugins (p: with p; [
    # Core parsers - always needed
    lua vim vimdoc query bash comment
    # Git parsers
    gitattributes gitignore
    # Web parsers
    html css javascript typescript tsx
    # System parsers  
    python rust go nix c cpp make
    # Data parsers
    json json5 yaml toml markdown markdown_inline
  ]));
  
  # Editing enhancement plugins
  editingPlugins = with pkgs.vimPlugins; [
    mini-pairs nvim-surround comment-nvim flash-nvim yanky-nvim
    vim-tmux-navigator stabilize-nvim vim-bbye project-nvim
    nvim-spectre yazi-nvim persistence-nvim
  ];
  
  # Development tools
  devPlugins = with pkgs.vimPlugins; [
    gitsigns-nvim lazygit-nvim copilot-vim nvim-colorizer-lua
    render-markdown-nvim todo-comments-nvim
  ];
  
  # Language-specific plugin collections
  languagePlugins = {
    nix = with pkgs.vimPlugins; [ vim-nix ];
    rust = with pkgs.vimPlugins; [ rust-tools-nvim rustaceanvim ];
    typescript = with pkgs.vimPlugins; [ typescript-vim ];
  };

in {
  imports = [ inputs.nixCats.homeModule ];
  
  config = {
    nixCats = {
      enable = true;

      addOverlays = [ (utils.standardPluginOverlay inputs) ];
      packageNames = [ "nvim" ];
      luaPath = ./.;

      categoryDefinitions.replace = ({ pkgs, ... }@packageDef: {
        # Runtime dependencies organized by purpose
        lspsAndRuntimeDep = languageTools // {
          general = languageTools.core ++ languageTools.formatters;
        };

        # Startup plugins organized by functionality
        startupPlugins = {
          general = corePlugins ++ uiPlugins ++ lspPlugins ++ [ treesitterConfig ] 
                   ++ (with pkgs.vimPlugins; [ nvim-treesitter-context nvim-ts-autotag nvim-treesitter-textobjects ])
                   ++ editingPlugins ++ devPlugins;
        } // languagePlugins;

        # Unused sections kept minimal
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
          
          # Enable all language categories wanted
          categories = {
            general = true;
            lua = true;
            nix = true;
            go = true;
            rust = true;
            python = true;
            typescript = true;
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
