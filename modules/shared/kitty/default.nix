{ lib, pkgs, config, palette, ... }:

{
  programs.kitty = {
    enable = true;

    # ────────────────────────────────────────────────────────────────
    # Font Configuration
    # ────────────────────────────────────────────────────────────────
    
    font = {
      name = config.theme.font.mono;
      size = if pkgs.stdenv.isDarwin then 14.0 else 13.0;
    };

    # ────────────────────────────────────────────────────────────────
    # Core Settings
    # ────────────────────────────────────────────────────────────────
    
    settings = {
      background = palette.background;
      foreground = palette.text;
      selection_background = palette.selection;
      selection_foreground = palette.text;
      cursor = palette.cursor;
      cursor_text_color = palette.background;
      cursor_shape = "beam";
      url_color = palette.link;
      
      color0 = palette.overlay;
      color8 = palette.muted;
      color1 = palette.error;
      color9 = palette.error;
      color2 = palette.success;
      color10 = palette.success;
      color3 = palette.warning;
      color11 = palette.warning;
      color4 = palette.info;
      color12 = palette.info;
      color5 = palette.primary;
      color13 = palette.primary;
      color6 = palette.secondary;
      color14 = palette.secondary;
      color7 = palette.text;
      color15 = palette.text;
      
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_foreground = palette.background;
      active_tab_background = palette.primary;
      active_tab_font_style = "bold";
      inactive_tab_foreground = palette.subtext;
      inactive_tab_background = palette.surface;
      tab_bar_background = palette.surface;
      
      window_padding_width = toString config.theme.gap;
      window_border_width = "1pt";
      active_border_color = palette.primary;
      inactive_border_color = palette.border;
      
      background_opacity = "0.97";
      background_blur = "24";
      
      # Animation settings for smooth visual transitions
      animation_duration = "0.15";
      animation_curve = "ease-in-out";
      
      shell_integration = "enabled";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      enable_audio_bell = "no";
      
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_show_window_title_in = "none";
    };

    # Run fastfetch on new window creation
    extraConfig = ''
      exec fastfetch
    '';

    # ────────────────────────────────────────────────────────────────
    # Keybindings
    # ────────────────────────────────────────────────────────────────

    keybindings = {
      # Window management
      "cmd+enter" = "new_window_with_cwd";
      "cmd+w" = "close_window";
      "cmd+]" = "next_window";
      "cmd+[" = "previous_window";
      "cmd+f" = "move_window_forward";
      "cmd+b" = "move_window_backward";
      
      # Tab management
      "cmd+t" = "new_tab_with_cwd";
      "cmd+alt+w" = "close_tab";
      "shift+cmd+]" = "next_tab";
      "shift+cmd+[" = "previous_tab";
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      
      # Font size
      "cmd+plus" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";
      
      # Misc
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
      "cmd+k" = "clear_terminal scrollback active";
      "cmd+l" = "clear_terminal scroll active";
      "cmd+shift+r" = "load_config_file";
    };
  };
}
