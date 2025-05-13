{ config, lib, pkgs, inputs, ... }:
let
  utils = inputs.nixCats.utils;
in
{
  #──────────────────────────────────────────────────────────────────
  # Imports
  #──────────────────────────────────────────────────────────────────

  imports = [
    inputs.nixCats.homeModule
  ];
  
  #──────────────────────────────────────────────────────────────────
  # NixCats Configuration
  #──────────────────────────────────────────────────────────────────

  config = {
    nixCats = {
      enable = true;
      
      addOverlays = /* (import ./overlays inputs) ++ */ [
        (utils.standardPluginOverlay inputs)
      ];

      packageNames = [ "nvim" ];

      luaPath = ./.;

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = ({pkgs, ...}@packageDef: {
        # to define and use a new category, simply add a new list to a set here,
        # and later, you will include categoryname = true; in the set you
        # provide when you build the package using this builder function.
        # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

        
        # lspsAndRuntimeDep:
        # this section is for dependencies that should be available
        # at RUN TIME for plugins. Will be available to PATH within neovim terminal
        # this includes LSPs
        lspsAndRuntimeDep = {
          general = with pkgs; [
            # Core tools
            lazygit
            ripgrep
            fd
            curl
            unzip
            git
            tree-sitter

            # Formatters
            prettierd
            shfmt
            stylua
            nixfmt-rfc-style
            rustfmt
            black

            # Build tools
            stdenv.cc.cc
            cmake
            gnumake
          ];
          
          # Language-specific tools
          lua = with pkgs; [
            lua-language-server
          ];

          nix = with pkgs; [
            nixd
          ];

          go = with pkgs; [
            gopls
            delve
            golint
            golangci-lint
            gotools
            go-tools
            go
          ];

          rust = with pkgs; [
            rust-analyzer
            rustfmt
            cargo
          ];

          python = with pkgs; [
            pyright
            black
            flake8
            isort
            python3Packages.pynvim
          ];

          typescript = with pkgs; [
            typescript-language-server
            nodejs
            yarn
            eslint
          ];

          c = with pkgs; [
            gcc
            clang
            cmake
          ];
        };

        # This is for plugins that will load at startup without using packadd:
        startupPlugins = {
          general = with pkgs.vimPlugins; [
            # Theme
            rose-pine

            # UI
            telescope-nvim
            telescope-fzf-native-nvim
            which-key-nvim
            lualine-nvim
            nvim-web-devicons
            bufferline-nvim
            neo-tree-nvim
            trouble-nvim
            mini-icons

            # Notifications and UI enchancements
            noice-nvim
            nvim-notify
            dressing-nvim
            indent-blankline-nvim

            # LSP and completion
            nvim-lspconfig
            blink-cmp
            none-ls-nvim

            # Treesitter
            (nvim-treesitter.withPlugins (p: with p; [
              # Core Languages
              lua
              vim
              vimdoc
              query
              bash
              comment

              # Git
              gitattributes
              gitignore

              # Web technologies
              html
              css
              javascript
              typescript
              tsx

              # Other Languages
              python
              rust
              go
              nix
              c
              cpp
              make
              json
              json5
              yaml
              toml
              markdown
              markdown_inline
            ]))
            nvim-treesitter-context
            nvim-ts-autotag

            # Git integration
            gitsigns-nvim
            lazygit-nvim

            # Editing Enhancements
            mini-pairs
            nvim-surround
            comment-nvim
            flash-nvim
            yanky-nvim


            # Utilities
            vim-tmux-navigator 
            stabilize-nvim
            vim-bbye
            project-nvim
            nvim-spectre
            yazi-nvim

            # Session and persistence
            persistence-nvim 

            # AI/Copilot
            copilot-vim

            # Other
            nvim-colorizer-lua
            render-markdown-nvim
            todo-comments-nvim
          ];

          lua = with pkgs.vimPlugins; [
            # Lua specific plugins
          ];

          nix = with pkgs.vimPlugins; [
            # Nix specific plugins
            vim-nix
          ];

          go = with pkgs.vimPlugins; [
            # Go specific plugins
          ];

          rust = with pkgs.vimPlugins; [
            # Rust specific plugins
            rust-tools-nvim
            rustaceanvim
          ];

          python = with pkgs.vimPlugins; [
            # Python specific plugins  
          ];

          typescript = with pkgs.vimPlugins; [
            # Typescript specific plugins
            typescript-vim
          ];

          c = with pkgs.vimPlugins; [
            # C specific plugins
          ];
        };

        # not loaded automatically at startup.
        # use with packadd and an autocommand in config to achieve lazy loading
        optionalPlugins = { };
        
        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = { };

        # environmentVariables:
        # this section is for environmentVariables that should be available
        # at RUN TIME for plugins. Will be available to path within neovim terminal
        environmentVariables = {
          # test = {
          #   CATTESTVAR = "It worked!";
          # };
        };

        # categories of the function you would have passed to withPackages
        python3.libraries = {
          # test = [ (_:[]) ];
        };

        # If you know what these are, you can provide custom ones by category here.
        # If you dont, check this link out:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        extraWrapperArgs = {
          # test = [
          #   '' --set CATTESTVAR2 "It worked again!"''
          # ];
        };
      });
      
      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim = { pkgs, ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = [ "vim" ];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            hosts.python3.enable = true;
            hosts.node.enable = true;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
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
          # anything else to pass and grab in lua with 'nixCats.extra'
          extra = { 
          };
        };
      };
    };
  };
}
