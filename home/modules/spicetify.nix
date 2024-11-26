{ config, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [
    # Spicetify
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # ────────────────────────────────────────────────────────────────
  # Spicetify Theme Integration with Pywal
  # ────────────────────────────────────────────────────────────────

  programs.spicetify = {
    text = ''
      # Generate Spicetify theme based on Pywal colors
      if [ -f ~/.cache/wal/colors.json ]; then
        BG_COLOR=$(jq -r '.colors.color0' ~/.cache/wal/colors.json)
        FG_COLOR=$(jq -r '.colors.color7' ~/.cache/wal/colors.json)
        ACCENT_COLOR=$(jq -r '.colors.color4' ~/.cache/wal/colors.json)

        # Apply colors to Spicetify
        spicetify config color_scheme custom
        spicetify config current_theme Pywal
        spicetify config custom_apps Zlink

        # Create the Pywal color scheme for Spicetify
        mkdir -p ~/.config/spicetify/Themes/Pywal
        cat > ~/.config/spicetify/Themes/Pywal/color.ini <<EOF
        [Base]
        main_bg = $BG_COLOR
        sidebar_and_player_bg = $BG_COLOR
        main_fg = $FG_COLOR
        primary = $ACCENT_COLOR
        EOF

        # Apply the theme
        spicetify apply
      else
        echo "Warning: Pywal colors.json not found. Run 'wal -i /path/to/wallpaper'."
      fi
    '';
  };
}
