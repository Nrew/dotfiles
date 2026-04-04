{ pkgs, config, lib, ... }:
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
      nixfmt-rfc-style

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

  # Symlink only the lua/ subtree so programs.neovim can still own init.lua.
  # The generated init.lua sources our entry point via extraLuaConfig below.
  xdg.configFile."nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "/Users/nrew/.config/dotfiles/modules/shared/neovim/config/lua";

  # Load our LazyVim entry-point.  programs.neovim wraps this in its own
  # generated init.lua, so we just need to call the lazy bootstrap.
  programs.neovim.extraLuaConfig = ''
    require("config.lazy")
  '';
}
