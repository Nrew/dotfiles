{ lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    # ────────────────────────────────────────────────────────────────
    # Font Configuration
    # ────────────────────────────────────────────────────────────────
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 
         if pkgs.stdenv.isDarwin
         then 14.0
         else 13;
    };

    # ────────────────────────────────────────────────────────────────
    # Core Settings
    # ────────────────────────────────────────────────────────────────

    settings = {

      # Window
      window_padding_width = "16";
      single_window_margin_width = "0";
      confirm_os_window_close = 0;


      # URLs
      detect_urls = "yes";

      # Mouse

      # Performance
      
      # Shell
      shell_integration = "enabled";
      allow_hyperlinks = "yes";

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

    # ────────────────────────────────────────────────────────────────
    # Theme Integration
    # ────────────────────────────────────────────────────────────────
    themeFile = "Catppuccin-Mocha";
  };
}
