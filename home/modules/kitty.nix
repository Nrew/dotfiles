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
      window_padding_width = "16 24";
      window_margin_width = "0";
      single_window_margin_width = "0";
      window_border_width = "0";
      draw_minimal_borders = "yes";
      placement_strategy = "center";
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      resize_in_steps = "yes";
      enabled_layouts = "tall,stack,fat,grid,splits,horizontal,vertical";

      # Tabs
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{index}: {title}";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      tab_activity_symbol = "󰘳";

      # Cursor
      cursor_shape = "beam";
      cursor_beam_thickness = "1.5";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "0";

      # URLs
      url_style = "double";
      open_url_with = "default";
      url_prefixes = "http https file ftp gemini irc gopher mailto news git";
      detect_urls = "yes";

      # Mouse
      mouse_hide_wait = "3.0";
      click_interval = "0.5";
      focus_follows_mouse = "yes";
      pointer_shape_when_grabbed = "beam";

      # Performance
      repaint_delay = "10";
      input_delay = "3";
      sync_to_monitor = "yes";
      
      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      window_alert_on_bell = "yes";
      bell_on_tab = "󰂜 ";

      # Advanced
      shell_integration = "enabled";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      update_check_interval = "0";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      allow_hyperlinks = "yes";

      # Theme settings
      background_opacity = "0.95";
      dynamic_background_opacity = "yes";
      dim_opacity = "0.75";
    };

    # ────────────────────────────────────────────────────────────────
    # Keybindings
    # ────────────────────────────────────────────────────────────────

    keybindings = {
      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";

      # Windows
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+q" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";

      # Layout
      "ctrl+shift+space" = "next_layout";
      "ctrl+shift+z" = "toggle_layout stack";

      # Font size
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";

      # Copy/Paste with clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };

    # ────────────────────────────────────────────────────────────────
    # Theme Integration
    # ────────────────────────────────────────────────────────────────

    extraConfig = ''
      # Import pywal colors
      include ${config.home.homeDirectory}/.cache/wal/colors-kitty.conf

      # Advanced cursor settings
      cursor_blink_interval -1
      cursor_stop_blinking_after 15.0

      # Mark terminal command output
      scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER
      scrollback_lines 10000
      wheel_scroll_multiplier 5.0

      # Rectangle selection
      rectangle_select_modifiers ctrl+alt
      terminal_select_modifiers shift

      # Shell integration features
      shell_integration enabled
      
      # Disable annoying features
      copy_on_select no
      focus_follows_mouse yes
      enable_audio_bell no
    '';
  };
}