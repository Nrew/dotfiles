{ config, lib, pkgs, palette, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Rose Pine colors for fzf
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
  };
}
