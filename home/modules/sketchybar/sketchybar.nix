{pkgs, lib, config, ...}:

let
  # Helper function to create scripts
  mkScript = name: content:
    pkgs.writeShellScriptBin name content;

  # Scripts directory
  scriptsDir = ./scripts;

  # Items directory
  itemsDir = ./items;
in
{
  # Ensure sketchybar is installed
  home.packages = with pkgs; [
    sketchybar
    jq            # Required for JSON processing in scripts
    coreutils     # Required for basic utils
    gnugrep      # Required for grep
    (mkScript "sb-spaces" (builtins.readFile "${scriptsDir}/spaces.sh"))
    (mkScript "sb-battery" (builtins.readFile "${scriptsDir}/battery.sh"))
    (mkScript "sb-clock" (builtins.readFile "${scriptsDir}/clock.sh"))
    (mkScript "sb-volume" (builtins.readFile "${scriptsDir}/volume.sh"))
    (mkScript "sb-wifi" (builtins.readFile "${scriptsDir}/wifi.sh"))
    (mkScript "sb-music" (builtins.readFile "${scriptsDir}/music.sh"))
  ];

  # Ensure config directory exists
  home.file.".config/sketchybar".source = lib.mkForce (pkgs.runCommand "sketchybar-config" {} ''
    mkdir -p $out
    cp -r ${itemsDir}/* $out/
    cp -r ${scriptsDir}/* $out/
  '');

  # Main sketchybar configuration
  home.file.".config/sketchybar/sketchybarrc".text = ''
    #!/usr/bin/env bash

    # Load colors from pywal
    source "$HOME/.cache/wal/colors.sh"

    # Color Definitions
    export BAR_COLOR="0xff''${background:1}"
    export BAR_BORDER_COLOR="0xff''${color4:1}"
    export ICON_COLOR="0xff''${color4:1}"
    export LABEL_COLOR="0xff''${foreground:1}"
    export POPUP_BACKGROUND_COLOR="0xff''${background:1}"
    export POPUP_BORDER_COLOR="0xff''${color4:1}"
    export SHADOW_COLOR="0xff''${background:1}"

    # Bar Properties
    sketchybar --bar \
               height=32 \
               blur_radius=0 \
               position=top \
               sticky=on \
               padding_left=10 \
               padding_right=10 \
               color=$BAR_COLOR \
               border_width=2 \
               border_color=$BAR_BORDER_COLOR \
               shadow=off \
               topmost=window

    # Global Defaults
    sketchybar --default \
               background.color=$BAR_COLOR \
               background.border_color=$BAR_BORDER_COLOR \
               icon.color=$ICON_COLOR \
               icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
               icon.padding_left=5 \
               icon.padding_right=5 \
               label.color=$LABEL_COLOR \
               label.font="JetBrainsMono Nerd Font:Bold:13.0" \
               label.padding_left=5 \
               label.padding_right=5 \
               popup.background.color=$POPUP_BACKGROUND_COLOR \
               popup.background.border_color=$POPUP_BORDER_COLOR \
               popup.background.border_width=2 \
               popup.background.corner_radius=6 \
               popup.background.shadow.drawing=off

    # Left
    source "$HOME/.config/sketchybar/items/spaces.sh"
    
    # Center
    source "$HOME/.config/sketchybar/items/spotify.sh"
    
    # Right
    source "$HOME/.config/sketchybar/items/calendar.sh"
    source "$HOME/.config/sketchybar/items/wifi.sh"
    source "$HOME/.config/sketchybar/items/battery.sh"
    source "$HOME/.config/sketchybar/items/volume.sh"

    # Finalizing Setup
    sketchybar --update

    # Start Event Loop for Updates
    sketchybar --bar event=on
  '';

  # Create necessary wal template for sketchybar
  home.file.".config/wal/templates/colors-sketchybar.sh".text = ''
    # Sketchybar color definitions
    export BAR_COLOR="0xff{background.strip}"
    export BAR_BORDER_COLOR="0xff{color4.strip}"
    export ICON_COLOR="0xff{color4.strip}"
    export LABEL_COLOR="0xff{foreground.strip}"
    export POPUP_BACKGROUND_COLOR="0xff{background.strip}"
    export POPUP_BORDER_COLOR="0xff{color4.strip}"
    export SHADOW_COLOR="0xff{background.strip}"
  '';

  # Add helper script for reloading sketchybar
  home.packages = with pkgs; [
    (writeShellScriptBin "sketchybar-reload" ''
      #!/usr/bin/env bash
      # Source colors
      source "$HOME/.cache/wal/colors-sketchybar.sh"
      # Reload sketchybar
      sketchybar --remove '/.*/'
      source "$HOME/.config/sketchybar/sketchybarrc"
    '')
  ];
}