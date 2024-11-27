# modules/cli/cava.nix
{ config, lib, pkgs, ... }:

{
  # Main cava configuration
  xdg.configFile."cava/config".text = ''
    [general]
    framerate = 60
    autosens = 1
    sensitivity = 100
    bars = 0
    bar_width = 2
    bar_spacing = 1
    higher_cutoff_freq = 10000

    [input]
    method = pulse
    source = auto

    [output]
    method = ncurses
    channels = stereo
    mono_option = average
    reverse = 0
    raw_target = /dev/stdout
    data_format = binary
    bit_format = 16bit
    ascii_max_range = 1000

    [color]
    gradient = 1
    gradient_count = 8
    gradient_color_1 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color1'
    gradient_color_2 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color2'
    gradient_color_3 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color3'
    gradient_color_4 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color4'
    gradient_color_5 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color5'
    gradient_color_6 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color6'
    gradient_color_7 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color7'
    gradient_color_8 = '#${config.home.homeDirectory}/.cache/wal/colors.sh:color8'

    [smoothing]
    integral = 77
    monstercat = 1
    waves = 0
    gravity = 100

    [eq]
    1 = 1
    2 = 1
    3 = 1
    4 = 1
    5 = 1
  '';

  # Create pywal template for cava colors
  home.file.".config/wal/templates/colors-cava.conf".text = ''
    [color]
    gradient = 1
    gradient_count = 8
    gradient_color_1 = '{color1}'
    gradient_color_2 = '{color2}'
    gradient_color_3 = '{color3}'
    gradient_color_4 = '{color4}'
    gradient_color_5 = '{color5}'
    gradient_color_6 = '{color6}'
    gradient_color_7 = '{color7}'
    gradient_color_8 = '{color8}'
  '';

  # Add script to update cava colors
  home.packages = with pkgs; [
    (writeShellScriptBin "cava-reload" ''
      #!/usr/bin/env bash
      # Update cava colors from pywal
      cat ~/.config/wal/colors-cava.conf > ~/.config/cava/config
    '')
  ];
}