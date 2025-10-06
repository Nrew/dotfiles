{ config, lib, pkgs, palette, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Theme colors from centralized palette
    colors = {
      "bg+"     = palette.overlay;
      "bg"      = palette.background;
      "spinner" = palette.primary;
      "hl"      = palette.error;
      "fg"      = palette.text;
      "header"  = palette.error;
      "info"    = palette.secondary;
      "pointer" = palette.primary;
      "marker"  = palette.primary;
      "fg+"     = palette.text;
      "prompt"  = palette.secondary;
      "hl+"     = palette.error; 
    };
    
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
