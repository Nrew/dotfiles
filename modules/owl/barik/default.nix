{ config, lib, pkgs, inputs, palette, ... }:

{
  # Barik configuration with proper aerospace integration
  # Reference: https://deepwiki.com/mocki-toki/barik/5.2-aerospace-integration

  home.file.".config/barik/barik.toml".text = ''
    # Barik Configuration
    # Aerospace-integrated status bar

    [appearance]
    background = "${palette.background}"
    foreground = "${palette.text}"
    accent = "${palette.primary}"
    border = "${palette.border}"

    [bar]
    # Reasonable bar height
    height = 28
    padding = 6
    position = "top"
    # Don't overlay on windows or wallpaper
    layer = "top"
    exclusive = true
    margin_top = 0
    margin_bottom = 0
    margin_left = 0
    margin_right = 0

    [popup]
    # Smaller, more reasonable popup sizes
    max_width = 400
    max_height = 300
    padding = 10
    border_width = 1

    # Network/WiFi module with proper configuration
    [[modules]]
    type = "network"
    format = "󰖩 {essid}"
    format_disconnected = "󰖪 Disconnected"
    interface = "en0"  # macOS default WiFi interface
    interval = 5

    # Aerospace workspace integration
    [[modules]]
    type = "aerospace"
    format = " {workspace} "
    show_empty = false

    # Battery module
    [[modules]]
    type = "battery"
    format = "{icon} {percentage}%"
    format_charging = "󰂄 {percentage}%"
    format_full = "󰁹 {percentage}%"

    # Clock module
    [[modules]]
    type = "clock"
    format = "󰥔 %H:%M"
    interval = 60
  '';

  # Aerospace integration script for barik
  home.file.".config/barik/aerospace-integration.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Aerospace workspace change handler for barik
      # Called by aerospace on workspace changes

      # Get workspace info from aerospace
      CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

      # Signal barik to update workspace display
      if command -v barik &> /dev/null; then
        pkill -SIGUSR1 barik 2>/dev/null || true
      fi
    '';
    executable = true;
  };
}
