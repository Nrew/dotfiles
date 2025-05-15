{ lib, pkgs, ... }:

let
  theme = import ../theme/default.nix { inherit lib; };
  colors = theme.theme;
  palette = theme.colorPalette;
in

{
  programs.kitty = {
    enable = true;

    # ────────────────────────────────────────────────────────────────
    # Font Configuration
    # ────────────────────────────────────────────────────────────────
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = if pkgs.stdenv.isDarwin then 14.0 else 13;
    };

    # ────────────────────────────────────────────────────────────────
    # Core Settings
    # ────────────────────────────────────────────────────────────────

    settings = {
      # Colors
      background = colors.base;
      foreground = colors.text;
      
      # Terminal colors
      color0 = palette.black;
      color1 = palette.red;
      color2 = palette.green;
      color3 = palette.yellow;
      color4 = palette.blue;
      color5 = palette.magenta;
      color6 = palette.cyan;
      color7 = palette.white;
      color8 = palette.brightBlack;
      color9 = palette.brightRed;
      color10 = palette.brightGreen;
      color11 = palette.brightYellow;
      color12 = palette.brightBlue;
      color13 = palette.brightMagenta;
      color14 = palette.brightCyan;
      color15 = palette.brightWhite;
      
      # Cursor colors
      cursor = colors.text;
      cursor_text_color = colors.base;

      # Window
      window_padding_width = "16";
      single_window_margin_width = "0";
      confirm_os_window_close = 0;

      # URLs
      detect_urls = "yes";
      
      # Shell
      shell_integration = "enabled";
      allow_hyperlinks = "yes";
      allow_remote_control = "yes";

      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      window_alert_on_bell = "yes";
      bell_on_tab = "󰂜 ";

      # Theme settings
      dynamic_background_opacity = "yes";
    };

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
    };
  };
}
