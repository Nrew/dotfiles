{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;  # Use unwrapped Neovim for flexibility
    defaultEditor = true;

    # Enable additional runtime dependencies
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # Extra packages for formatting and LSP
    extraPackages = with pkgs; [
      # Formatters and linters
      black
      isort
      ruff
      stylua
      nodePackages.prettier
      shellcheck
      shfmt

      # Language servers
      pyright
      gopls
      terraform-ls
      vscode-langservers-extracted
      yaml-language-server
    ];

    # Use Neovim `extraConfig` to define plugins and settings
    extraConfig = ''
      -- Auto-install packer.nvim if not present
      local fn = vim.fn
      local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
      if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
      end

      -- Plugin management with packer.nvim
      require('packer').startup(function()
        use 'wbthomason/packer.nvim'                     -- Plugin manager
        use 'neovim/nvim-lspconfig'                     -- Built-in LSP client
        use 'VonHeikemen/lsp-zero.nvim'                 -- Simplified LSP setup
        use 'nvim-treesitter/nvim-treesitter'           -- Better syntax highlighting
        use 'nvim-telescope/telescope.nvim'            -- Fuzzy finder
        use 'dylanaraps/wal.vim'                        -- Pywal color scheme
      end)

      -- Configure LSP with lsp-zero
      local lsp = require('lsp-zero')
      lsp.preset('recommended')
      lsp.setup_servers({ 'pyright', 'gopls', 'terraformls', 'yamlls' })
      lsp.setup()

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

      -- Pywal colorscheme with fallback
      vim.cmd [[
        silent! colorscheme wal
        if !filereadable(expand("~/.cache/wal/colors-wal.vim"))
          echoerr "Pywal colors not found. Run `wal -i <wallpaper>` to generate."
        endif
      ]]

      -- General Neovim settings
      vim.opt.number = true                 -- Show line numbers
      vim.opt.relativenumber = true         -- Show relative numbers
      vim.opt.tabstop = 4                   -- Tab width
      vim.opt.shiftwidth = 4                -- Indent width
      vim.opt.expandtab = true              -- Use spaces instead of tabs
      vim.opt.clipboard = "unnamedplus"     -- Use system clipboard
    '';
  };
}
