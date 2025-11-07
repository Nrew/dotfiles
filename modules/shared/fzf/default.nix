{ config, lib, pkgs, ... }:

{
  # Enable Catppuccin theme
  catppuccin.fzf.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    
    # Default options for better UX
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border=rounded"
      "--margin=1"
      "--padding=1"
      "--info=inline"
      "--prompt='❯ '"
      "--pointer='▶'"
      "--marker='✓'"
      "--ansi"
      # Smooth animations
      "--bind='ctrl-/:toggle-preview'"
      "--bind='ctrl-u:preview-page-up'"
      "--bind='ctrl-d:preview-page-down'"
    ];
  };
}
