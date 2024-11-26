{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      # Formatters and linters
      black            # Python formatter
      isort            # Python import sorter
      ruff             # Python linter
      stylua           # Lua formatter
      nodePackages.prettier # Correctly reference Prettier from Node.js packages
      shellcheck       # Shell script linter
      shfmt            # Shell script formatter

      # Language servers
      pyright          # Python LSP
      gopls            # Go LSP
      terraform-ls     # Terraform LSP
      vscode-langservers-extracted # General VSCode LSP support
      yaml-language-server # YAML LSP
    ];

    configure = ''
      -- Use packer.nvim for plugin management
      vim.cmd [[packadd packer.nvim]]

      require('packer').startup(function()
        use 'wbthomason/packer.nvim'                     -- Plugin manager
        use 'neovim/nvim-lspconfig'                     -- Built-in LSP client
        use 'VonHeikemen/lsp-zero.nvim'                 -- Simplified LSP setup
        use 'nvim-treesitter/nvim-treesitter'           -- Better syntax highlighting
        use 'nvim-telescope/telescope.nvim'            -- Fuzzy finder
        use 'dylanaraps/wal.vim'                        -- Pywal color scheme
      end)

      -- Set up LSP servers
      local lspconfig = require('lspconfig')
      lspconfig.pyright.setup {}
      lspconfig.gopls.setup {}
      lspconfig.terraformls.setup {}
      lspconfig.yamlls.setup {}

      -- Treesitter configuration
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "lua", "python", "go", "yaml", "json" },
        highlight = { enable = true },
      }

      -- Telescope configuration
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" },
        },
      }

      -- Pywal colorscheme
      vim.cmd [[
        silent! colorscheme wal
        if !filereadable(expand("~/.cache/wal/colors-wal.vim"))
          echoerr "Pywal colors not found. Run `wal -i <wallpaper>` to generate."
        endif
      ]]

      -- General Neovim settings
      vim.opt.number = true           -- Show line numbers
      vim.opt.relativenumber = true   -- Show relative numbers
      vim.opt.tabstop = 4             -- Tab width
      vim.opt.shiftwidth = 4          -- Indent width
      vim.opt.expandtab = true        -- Use spaces instead of tabs
      vim.opt.clipboard = "unnamedplus" -- Use system clipboard
    '';
  };
}
