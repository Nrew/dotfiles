{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true; # Enable Neovim configuration
    viAlias = true;
    vimAlias = true;

    # Add plugins (e.g., Treesitter, Telescope)
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      telescope-nvim
      lsp-zero
    ];

    # Add Lua-based configurations
    extraConfig = ''
      -- Treesitter setup
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        highlight = { enable = true },
      }

      -- Telescope setup
      require'telescope'.setup {}
    '';
  };
}
