{ config, lib, pkgs, ... }:

let
  # Catppuccin Mocha colors for fzf (matching the theme)
  # These are hardcoded but will match the catppuccin theme
  colors = {
    background = "#1e1e2e";  # Catppuccin Mocha base
    overlay = "#45475a";     # Catppuccin Mocha surface2
    text = "#cdd6f4";        # Catppuccin Mocha text
    primary = "#cba6f7";     # Catppuccin Mocha mauve
    secondary = "#f5c2e7";   # Catppuccin Mocha pink
    error = "#f38ba8";       # Catppuccin Mocha red
  };
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Theme colors using Catppuccin Mocha palette
    colors = {
      "bg+"     = colors.overlay;
      "bg"      = colors.background;
      "spinner" = colors.primary;
      "hl"      = colors.error;
      "fg"      = colors.text;
      "header"  = colors.error;
      "info"    = colors.secondary;
      "pointer" = colors.primary;
      "marker"  = colors.primary;
      "fg+"     = colors.text;
      "prompt"  = colors.secondary;
      "hl+"     = colors.error; 
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
