{ pkgs, config, lib, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Language servers and tools
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nixd
      typescript-language-server
      pyright
      rust-analyzer
      gopls
      clangd

      # Formatters & Linters
      stylua
      nixfmt-rfc-style
      prettierd
      black
      ruff
      rustfmt
      eslint_d

      # Tools
      ripgrep
      fd
      lazygit
      tree-sitter
      gcc
    ];
  };

  # LazyVim configuration
  xdg.configFile."nvim" = {
    source = ./lazyvim-config;
    recursive = true;
  };
}
