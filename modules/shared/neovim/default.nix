{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    extraPackages = with pkgs; [
      # Lua
      lua-language-server
      stylua

      # Nix
      nixd
      nixfmt

      # TypeScript / JS
      typescript-language-server
      nodejs
      eslint_d
      prettierd

      # Python
      pyright
      ruff
      black

      # Rust
      rust-analyzer
      rustfmt

      # C / Makefile (clangd)
      clang-tools

      # Tools required by LazyVim and plugins
      ripgrep
      fd
      lazygit
      tree-sitter
    ];
  };

  xdg.configFile."nvim/lua".source = ./config/lua;
  xdg.configFile."nvim/colors".source = ./config/colors;

  programs.neovim.initLua = ''
    require("config.lazy")
  '';
}
