{ config, lib, pkgs, inputs, palette, ... }:

{
  # Barik configuration with proper aerospace integration
  # Barik is a macOS status bar from mocki-toki/barik

  home.file.".config/barik/barik.toml".text = ''
    # Barik Configuration
    # Aerospace-integrated status bar

    [appearance]
    background = "${palette.background}"
    foreground = "${palette.text}"
    accent = "${palette.primary}"

    [bar]
    height = 32
    padding = 8
    position = "top"
    layer = "top"
    exclusive = true

    # Workspace indicator
    [[modules]]
    type = "workspace"
    format = " {workspace} "

    # Network/WiFi module
    [[modules]]
    type = "network"
    format = "󰖩 {essid}"
    format_disconnected = "󰖪"
    interface = "en0"

    # Battery module
    [[modules]]
    type = "battery"
    format = "{icon} {percentage}%"
    format_charging = "󰂄 {percentage}%"
    format_full = "󰁹"

    # Clock module
    [[modules]]
    type = "clock"
    format = "󰥔 %H:%M"
  '';
}
