{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true; # Enable Kitty configuration

    # Set font options
    font = {
      family = "JetBrainsMono Nerd Font";
      size = 14.0;
    };

    # Kitty settings
    settings = {
      confirm_os_window_close = 0;
      window_padding_width = 16;
    }

    # Additional Kitty settings
    extraConfig = ''
      include ${config.home.homeDirectory}/.cache/wal/colors-kitty.conf
      background_opacity 0.9
      tab_bar_style powerline
    '';
  };
}
