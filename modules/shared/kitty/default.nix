{ lib, pkgs, config, palette ? null, ... }:

let
  # Fallback palette if theme system is not enabled
  # This ensures the module works independently
  defaultPalette = {
    base = "#efead8"; text = "#2d2b28"; primary = "#857a71"; secondary = "#8f857a";
    red = "#a67070"; orange = "#b8905e"; yellow = "#cbb470"; green = "#8fa670";
    cyan = "#70a6a6"; blue = "#7a92a6"; mantle = "#e5e0d0"; surface = "#cbc2b3";
    overlay = "#a69e93"; subtext0 = "#45413b"; subtext1 = "#5a554d"; muted = "#655f59";
    background = "#efead8"; subtext = "#45413b"; success = "#8fa670";
    warning = "#b8905e"; error = "#a67070"; info = "#70a6a6";
    selection = "#a69e93"; border = "#a69e93"; cursor = "#2d2b28"; link = "#857a71";
  };
  
  colors = if palette != null then palette else defaultPalette;
in
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
      # Theme colors (static - edit in theme/default.nix)
      background = colors.base;
      foreground = colors.text;
      selection_background = colors.overlay;
      selection_foreground = colors.text;
      cursor = colors.text;
      cursor_text_color = colors.base;
      url_color = colors.primary;
      
      # ANSI colors
      color0 = colors.overlay;
      color8 = colors.muted;
      color1 = colors.red;
      color9 = colors.red;
      color2 = colors.green;
      color10 = colors.green;
      color3 = colors.orange;
      color11 = colors.orange;
      color4 = colors.cyan;
      color12 = colors.cyan;
      color5 = colors.primary;
      color13 = colors.primary;
      color6 = colors.secondary;
      color14 = colors.secondary;
      color7 = colors.text;
      color15 = colors.text;
      
      # Tab colors
      active_tab_foreground = colors.text;
      active_tab_background = colors.primary;
      inactive_tab_foreground = colors.subtext0;
      inactive_tab_background = colors.surface;
      tab_bar_background = colors.base;
      
      # Border colors
      active_border_color = colors.primary;
      inactive_border_color = colors.overlay;
      
      # Non-color settings
      cursor_shape = "beam";

      tab_bar_edge = "top";
      tab_bar_style = "hidden";

      window_padding_width = toString config.theme.gap;
      window_border_width = "1pt";

      background_opacity = "0.97";

      # Smooth animations for clean minimal aesthetics
      repaint_delay = "10";
      input_delay = "3";
      sync_to_monitor = "yes";

      shell_integration = "enabled";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      enable_audio_bell = "no";

      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_show_window_title_in = "none";
      macos_titlebar_color = "background";
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
      "cmd+shift+r" = "load_config_file";
    };
  };

  # Theme is now static - change palette values in theme/default.nix and rebuild
}
