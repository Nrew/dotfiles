# modules/kitty.nix
{ config, pkgs, username, ... }:

{
  programs.kitty = {
    enable = true;

    # ────────────────────────────────────────────────────────────────
    # Font Configuration
    # ────────────────────────────────────────────────────────────────
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14.0;
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
      shell = zsh;
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

    extraConfig = ''
      # Load pywal colors
      include ${config.home.homeDirectory}/.cache/wal/colors-kitty.conf
      
      # Additional styling
      active_tab_foreground   #${config.home.homeDirectory}/.cache/wal/colors-kitty.conf:color15}
      active_tab_background   #${config.home.homeDirectory}/.cache/wal/colors-kitty.conf:color4}
      inactive_tab_foreground #${config.home.homeDirectory}/.cache/wal/colors-kitty.conf:color7}
      inactive_tab_background #${config.home.homeDirectory}/.cache/wal/colors-kitty.conf:color0}
      
      # URL handling
      url_color #${config.home.homeDirectory}/.cache/wal/colors-kitty.conf:color4}
      
      # Selection
      selection_foreground none
      selection_background #${config.home.homeDirectory}/.cache/wal/colors-kitty.conf:color4}
    '';
  };

  
  # Ensure pywal templates for kitty are properly set up
  home.file.".config/wal/templates/colors-kitty.conf".text = ''
    # Base colors
    foreground           {foreground}
    background           {background}
    selection_foreground {background}
    selection_background {foreground}
    
    # Cursor colors
    cursor            {cursor}
    cursor_text_color {background}
    
    # URL underline color when hovering with mouse
    url_color {color4}
    
    # Window border colors
    active_border_color   {color4}
    inactive_border_color {color8}
    bell_border_color     {color1}
    
    # Tab bar colors
    active_tab_foreground   {background}
    active_tab_background   {color4}
    inactive_tab_foreground {foreground}
    inactive_tab_background {background}
    
    # The 16 terminal colors
    color0  {color0}
    color1  {color1}
    color2  {color2}
    color3  {color3}
    color4  {color4}
    color5  {color5}
    color6  {color6}
    color7  {color7}
    color8  {color8}
    color9  {color9}
    color10 {color10}
    color11 {color11}
    color12 {color12}
    color13 {color13}
    color14 {color14}
    color15 {color15}
  '';

  # Add helper script for reloading kitty configuration
  home.packages = with pkgs; [
    (writeShellScriptBin "kitty-reload" ''
      #!/usr/bin/env bash
      # Reload kitty configuration
      kill -SIGUSR1 $(pgrep -a kitty)
    '')
  ];
}