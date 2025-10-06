{ config, lib, pkgs, ... }:

let
  cfg = config.theme;
  
  # Import theme registry
  registry = import ./registry.nix { inherit lib; };
  
  # Theme state file
  themeStateFile = ./theme-state.json;
  
  # Read current theme selection
  themeState = 
    if builtins.pathExists themeStateFile
    then builtins.fromJSON (builtins.readFile themeStateFile)
    else { variant = "beige"; custom = null; };
  
  # Get the current palette
  currentPalette = 
    if themeState.custom != null
    then registry.mkTheme themeState.custom
    else registry.${themeState.variant};
  
  # Color extractor script
  colorExtractor = pkgs.python3.pkgs.buildPythonApplication {
    pname = "extract-colors";
    version = "1.0.0";
    format = "other";
    
    propagatedBuildInputs = with pkgs.python3.pkgs; [ pillow ];
    
    unpackPhase = "true";
    
    installPhase = ''
      mkdir -p $out/bin
      cp ${./extract-colors.py} $out/bin/extract-colors
      chmod +x $out/bin/extract-colors
    '';
  };
  
in
{
  options.theme = {
    enable = lib.mkEnableOption "unified theme system";
    
    font = {
      mono = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
      };
      sans = lib.mkOption {
        type = lib.types.str;
        default = "Inter";
      };
      size = {
        small = lib.mkOption { type = lib.types.int; default = 12; };
        normal = lib.mkOption { type = lib.types.int; default = 14; };
        large = lib.mkOption { type = lib.types.int; default = 16; };
      };
    };
    
    borderRadius = lib.mkOption { type = lib.types.int; default = 8; };
    gap = lib.mkOption { type = lib.types.int; default = 16; };
    
    wallpaperDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/dotfiles/images";
    };
  };
  
  config = lib.mkIf cfg.enable {
    _module.args.palette = currentPalette;
    
    home.sessionVariables = {
      THEME_VARIANT = themeState.variant;
      THEME_IS_CUSTOM = if themeState.custom != null then "true" else "false";
    };
    
    xdg.configFile = {
      "theme/palette.json".text = builtins.toJSON {
        variant = themeState.variant;
        isCustom = themeState.custom != null;
        colors = currentPalette;
        font = cfg.font;
        spacing = { borderRadius = cfg.borderRadius; gap = cfg.gap; };
      };
      
      "theme/palette.sh".text = ''
        export THEME_VARIANT="${themeState.variant}"
        export THEME_BACKGROUND="${currentPalette.background}"
        export THEME_SURFACE="${currentPalette.surface}"
        export THEME_OVERLAY="${currentPalette.overlay}"
        export THEME_TEXT="${currentPalette.text}"
        export THEME_SUBTEXT="${currentPalette.subtext}"
        export THEME_MUTED="${currentPalette.muted}"
        export THEME_PRIMARY="${currentPalette.primary}"
        export THEME_SECONDARY="${currentPalette.secondary}"
        export THEME_SUCCESS="${currentPalette.success}"
        export THEME_WARNING="${currentPalette.warning}"
        export THEME_ERROR="${currentPalette.error}"
        export THEME_INFO="${currentPalette.info}"
      '';
      
      "theme/palette.css".text = ''
        :root {
          --bg: ${currentPalette.background};
          --surface: ${currentPalette.surface};
          --overlay: ${currentPalette.overlay};
          --text: ${currentPalette.text};
          --subtext: ${currentPalette.subtext};
          --muted: ${currentPalette.muted};
          --primary: ${currentPalette.primary};
          --secondary: ${currentPalette.secondary};
          --success: ${currentPalette.success};
          --warning: ${currentPalette.warning};
          --error: ${currentPalette.error};
          --info: ${currentPalette.info};
        }
      '';
    };
    
    home.packages = [
      colorExtractor
      
      (pkgs.writeShellScriptBin "theme-switch" ''
        #!/usr/bin/env bash
        set -e
        
        DOTFILES="$HOME/.config/dotfiles"
        STATE_FILE="$DOTFILES/modules/shared/theme/theme-state.json"
        VARIANT="$1"
        
        if [ -z "$VARIANT" ]; then
          echo "Usage: theme-switch <variant>"
          echo ""
          echo "Available themes:"
          ${lib.concatMapStrings (t: "echo \"  ${t}\"\n") registry.available}
          exit 1
        fi
        
        VALID_THEMES=(${lib.concatStringsSep " " registry.available})
        if [[ ! " ''${VALID_THEMES[@]} " =~ " ''${VARIANT} " ]]; then
          echo "❌ Unknown theme: $VARIANT"
          exit 1
        fi
        
        echo "🎨 Switching to: $VARIANT"
        
        mkdir -p "$(dirname "$STATE_FILE")"
        cat > "$STATE_FILE" <<EOF
{
  "variant": "$VARIANT",
  "custom": null
}
EOF
        
        echo "📦 Rebuilding..."
        cd "$DOTFILES"
        darwin-rebuild switch --flake .#owl
        
        echo "🔄 Reloading..."
        killall -SIGUSR1 kitty 2>/dev/null || true
        tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true
        
        echo "✅ Theme: $VARIANT"
      '')
      
      (pkgs.writeShellScriptBin "theme-from-wallpaper" ''
        #!/usr/bin/env bash
        set -e
        
        DOTFILES="$HOME/.config/dotfiles"
        STATE_FILE="$DOTFILES/modules/shared/theme/theme-state.json"
        WALLPAPER="$1"
        
        if [ -z "$WALLPAPER" ]; then
          CURRENT_LINK="$HOME/.local/state/current-wallpaper"
          if [ -L "$CURRENT_LINK" ]; then
            WALLPAPER=$(readlink "$CURRENT_LINK")
          else
            echo "Usage: theme-from-wallpaper <image>"
            exit 1
          fi
        fi
        
        if [ ! -f "$WALLPAPER" ]; then
          echo "❌ Image not found: $WALLPAPER"
          exit 1
        fi
        
        echo "🎨 Extracting colors from: $(basename "$WALLPAPER")"
        
        THEME_DATA=$(extract-colors "$WALLPAPER" "wallpaper" 2>/dev/null) || {
          echo "❌ Color extraction failed"
          exit 1
        }
        
        mkdir -p "$(dirname "$STATE_FILE")"
        echo "{\"variant\": \"wallpaper\", \"custom\": $THEME_DATA}" > "$STATE_FILE"
        
        echo "📦 Rebuilding..."
        cd "$DOTFILES"
        darwin-rebuild switch --flake .#owl
        
        echo "🔄 Reloading..."
        killall -SIGUSR1 kitty 2>/dev/null || true
        
        echo "✅ Theme generated from wallpaper!"
      '')
      
      (pkgs.writeShellScriptBin "theme-list" ''
        #!/usr/bin/env bash
        
        echo "╔════════════════════════════════════════╗"
        echo "║       Available Themes                 ║"
        echo "╚════════════════════════════════════════╝"
        echo ""
        echo "Beige Family:"
        echo "  • beige"
        echo "  • beige-dark"
        echo ""
        echo "Rose Pine Family:"
        echo "  • rose-pine"
        echo "  • rose-pine-moon"
        echo "  • rose-pine-dawn"
        echo ""
        echo "Catppuccin Family:"
        echo "  • catppuccin-latte"
        echo "  • catppuccin-frappe"
        echo "  • catppuccin-macchiato"
        echo "  • catppuccin-mocha"
        echo ""
        echo "Minimal:"
        echo "  • minimal-light"
        echo "  • minimal-dark"
        echo ""
        echo "Accessibility:"
        echo "  • high-contrast"
        echo ""
        echo "Usage:"
        echo "  theme-switch <n>          # Switch theme"
        echo "  theme-from-wallpaper [img]   # From image"
        echo "  theme-info                   # Current info"
      '')
      
      (pkgs.writeShellScriptBin "theme-info" ''
        #!/usr/bin/env bash
        
        if [ ! -f ~/.config/theme/palette.json ]; then
          echo "Theme not initialized"
          exit 1
        fi
        
        echo "╔════════════════════════════════════════╗"
        echo "║          Current Theme                 ║"
        echo "╚════════════════════════════════════════╝"
        echo ""
        
        ${pkgs.jq}/bin/jq -r '
          "Variant:     \(.variant)",
          "Custom:      \(if .isCustom then "Yes (from wallpaper)" else "No" end)",
          "",
          "Colors:",
          "  Background:  \(.colors.background)",
          "  Surface:     \(.colors.surface)",
          "  Text:        \(.colors.text)",
          "  Primary:     \(.colors.primary)",
          "  Secondary:   \(.colors.secondary)",
          "",
          "Typography:",
          "  Mono:        \(.font.mono)",
          "  Sans:        \(.font.sans)",
          "  Size:        \(.font.size.normal)px"
        ' ~/.config/theme/palette.json
      '')
    ];
  };
}
