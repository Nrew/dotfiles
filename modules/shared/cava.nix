{ config, lib, pkgs, ... }:

{
  #───────────────────────────────────────────────────────────────────────────────
  # Cava Base Configuration
  #───────────────────────────────────────────────────────────────────────────────

  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        autosens = 1;
        sensitivity = 100;
        bars = 0;
        bar_width = 2;
        bar_spacing = 1;
        higher_cutoff_freq = 10000;
      };

      input = {
        method = "pulse";
        source = "auto";
      };

      output = {
        method = "ncurses";
        channels = "stereo";
        mono_option = "average";
        reverse = 0;
        raw_target = "/dev/stdout";
        data_format = "binary";
        bit_format = "16bit";
        ascii_max_range = 1000;
      };

      smoothing = {
        integral = 77;
        monstercat = 1;
        waves = 0;
        gravity = 100;
      };

      eq = {
        "1" = 1;
        "2" = 1;
        "3" = 1;
        "4" = 1;
        "5" = 1;
      };
    };
  };

  #───────────────────────────────────────────────────────────────────────────────
  # Pywal Integration
  #───────────────────────────────────────────────────────────────────────────────

  xdg.configFile."wal/templates/colors-cava.conf".text = ''
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
}