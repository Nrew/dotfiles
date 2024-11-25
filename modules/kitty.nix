{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true; # Enable Kitty configuration

    # Set font options
    font = {
      family = "JetBrainsMono Nerd Font";
      size = 14.0;
    };

    # Additional Kitty settings
    extraConfig = ''
      include ~/.cache/wal/colors-kitty.conf
      background_opacity 0.9
      tab_bar_style powerline
    '';
  };
}
