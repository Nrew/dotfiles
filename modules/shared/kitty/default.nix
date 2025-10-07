{ lib, pkgs, config, palette, ... }:

let
  # Script to generate kitty theme from runtime palette
  kittyThemeReloader = pkgs.writeShellScript "kitty-theme-reload" ''
    #!/usr/bin/env bash
    
    PALETTE_FILE="${config.xdg.configHome}/theme/palette.json"
    KITTY_THEME="${config.xdg.configHome}/kitty/current-theme.conf"
    
    if [ ! -f "$PALETTE_FILE" ]; then
      exit 0
    fi
    
    # Extract colors from palette.json
    BG=$(${pkgs.jq}/bin/jq -r '.colors.background' "$PALETTE_FILE")
    FG=$(${pkgs.jq}/bin/jq -r '.colors.text' "$PALETTE_FILE")
    SEL_BG=$(${pkgs.jq}/bin/jq -r '.colors.selection' "$PALETTE_FILE")
    CURSOR=$(${pkgs.jq}/bin/jq -r '.colors.cursor' "$PALETTE_FILE")
    LINK=$(${pkgs.jq}/bin/jq -r '.colors.link' "$PALETTE_FILE")
    
    # ANSI colors
    C0=$(${pkgs.jq}/bin/jq -r '.colors.overlay' "$PALETTE_FILE")
    C8=$(${pkgs.jq}/bin/jq -r '.colors.muted' "$PALETTE_FILE")
    C1=$(${pkgs.jq}/bin/jq -r '.colors.error // .colors.red' "$PALETTE_FILE")
    C2=$(${pkgs.jq}/bin/jq -r '.colors.success // .colors.green' "$PALETTE_FILE")
    C3=$(${pkgs.jq}/bin/jq -r '.colors.warning // .colors.orange' "$PALETTE_FILE")
    C4=$(${pkgs.jq}/bin/jq -r '.colors.info // .colors.cyan' "$PALETTE_FILE")
    C5=$(${pkgs.jq}/bin/jq -r '.colors.primary' "$PALETTE_FILE")
    C6=$(${pkgs.jq}/bin/jq -r '.colors.secondary' "$PALETTE_FILE")
    C7=$(${pkgs.jq}/bin/jq -r '.colors.text' "$PALETTE_FILE")
    
    SUBTEXT=$(${pkgs.jq}/bin/jq -r '.colors.subtext0 // .colors.subtext' "$PALETTE_FILE")
    SURFACE=$(${pkgs.jq}/bin/jq -r '.colors.surface' "$PALETTE_FILE")
    BORDER=$(${pkgs.jq}/bin/jq -r '.colors.border // .colors.overlay' "$PALETTE_FILE")
    
    # Generate kitty theme
    cat > "$KITTY_THEME" <<EOF
background $BG
foreground $FG
selection_background $SEL_BG
selection_foreground $FG
cursor $CURSOR
cursor_text_color $BG
url_color $LINK

color0 $C0
color8 $C8
color1 $C1
color9 $C1
color2 $C2
color10 $C2
color3 $C3
color11 $C3
color4 $C4
color12 $C4
color5 $C5
color13 $C5
color6 $C6
color14 $C6
color7 $C7
color15 $C7

active_tab_foreground $FG
active_tab_background $C5
inactive_tab_foreground $SUBTEXT
inactive_tab_background $SURFACE
tab_bar_background $BG

active_border_color $C5
inactive_border_color $BORDER
EOF

    # Reload kitty if running
    if command -v kitty &> /dev/null; then
      kitty @ --to unix:/tmp/kitty set-colors -a "$KITTY_THEME" 2>/dev/null || true
    fi
  '';
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
      tab_bar_style = "hidden";
      active_tab_foreground = palette.text;
      active_tab_background = palette.primary;
      active_tab_font_style = "bold";
      inactive_tab_foreground = palette.subtext;
      inactive_tab_background = palette.surface;
      tab_bar_background = palette.background;

      window_padding_width = toString config.theme.gap;
      window_border_width = "1pt";
      active_border_color = palette.primary;
      inactive_border_color = palette.border;

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

  # Add the theme reloader script to home packages
  home.packages = [ (pkgs.writeShellScriptBin "kitty-reload-theme" ''
    ${kittyThemeReloader}
  '') ];

  # Create a systemd service or launchd agent to watch for theme changes
  # For now, we'll integrate with the theme-switch script
}
