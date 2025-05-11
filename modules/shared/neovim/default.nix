{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    
    plugins = with pkgs.vimPlugins; [
      # Theme
      rose-pine
      
      # UI
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      which-key-nvim
      lualine-nvim
      nvim-web-devicons
      bufferline-nvim
      neo-tree-nvim
      trouble-nvim
      noice-nvim
      notify-nvim
      dressing-nvim
      indent-blankline-nvim
      nvim-ufo
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      
      # LSP
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      typescript-tools-nvim
      rust-tools-nvim
      null-ls-nvim
      
      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-vim
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-python
        p.tree-sitter-rust
        p.tree-sitter-json
        p.tree-sitter-javascript
        p.tree-sitter-typescript
        p.tree-sitter-tsx
        p.tree-sitter-html
        p.tree-sitter-css
        p.tree-sitter-go
        p.tree-sitter-yaml
        p.tree-sitter-toml
        p.tree-sitter-markdown
        p.tree-sitter-c
        p.tree-sitter-cpp
      ]))
      nvim-treesitter-context
      nvim-ts-autotag
      
      # Git
      gitsigns-nvim
      lazygit-nvim
      vim-fugitive
      
      # Editing
      nvim-autopairs
      nvim-surround
      comment-nvim
      vim-tmux-navigator
      yanky-nvim
      flash-nvim
      
      # Utility
      plenary-nvim
      nui-nvim
      nvim-notify
      nvim-colorizer-lua
      guess-indent-nvim
      stabilize-nvim
      vim-bbye
      project-nvim
      nvim-spectre
      
      # AI/Copilot
      copilot-vim
      
      # Language specific
      vim-nix
      markdown-preview-nvim
      
      # Sessions
      persistence-nvim
    ];
  };

  # Link the neovim config directory
  home.file.".config/nvim".source = ./config;
}
