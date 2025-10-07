{ config, lib, pkgs, palette, ... }:

{
  # Raycast configuration and integration
  # Note: Raycast is configured mainly through its UI, but we can set some
  # preferences via plist files on macOS

  # Create a color theme export for Raycast
  home.file.".config/raycast/theme.json".text = builtins.toJSON {
    name = "System Theme";
    colors = {
      background = palette.background;
      text = palette.text;
      primary = palette.primary;
      secondary = palette.secondary;
      accent = palette.primary;
    };
  };

  # Shell script to help with Raycast integration
  home.packages = [
    (pkgs.writeShellScriptBin "raycast-theme" ''
      #!/usr/bin/env bash
      # Apply current theme colors to Raycast
      
      THEME_FILE="${config.xdg.configHome}/raycast/theme.json"
      
      if [ -f "$THEME_FILE" ]; then
        echo "Raycast theme configuration available at: $THEME_FILE"
        echo "Note: Raycast themes are configured through the app's Settings > Appearance"
        echo ""
        echo "Theme colors:"
        ${pkgs.jq}/bin/jq -r '.colors | to_entries[] | "  \(.key): \(.value)"' "$THEME_FILE"
      else
        echo "Theme file not found"
        exit 1
      fi
    '')
  ];

  # Add shell aliases for common Raycast operations
  home.shellAliases = {
    rc = "open -a Raycast";
  };
}
