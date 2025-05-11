{ config, lib, pkgs, ... }:

let
  theme = import ../theme/default.nix { inherit lib; };
  colors = theme.theme;
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Rose Pine colors for fzf
    colors = {
      "bg+" = colors.overlay;
      "bg"  = colors.base;
      "spinner" = colors.rose;
      "hl"  = colors.love;
      "fg"  = colors.text;
      "header"  = colors.love;
      "info"    = colors.iris;
      "pointer" = colors.rose;
      "marker"  = colors.rose;
      "fg+"     = colors.text;
      "prompt"  = colors.iris;
      "hl+"     = colors.love; 
    };
  };
}
