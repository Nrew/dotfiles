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
      # Include the dynamic theme file (symlinked to current theme)
      include = "${config.xdg.configHome}/current-theme/kitty.conf";
      
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

  # Theme reloading is handled by the theme-switch script in theme/default.nix
  # which uses symlinks for instant theme switching without additional scripts
}
