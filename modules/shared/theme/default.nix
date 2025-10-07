{ pkgs, config, lib, ... }:

let
  cfg = config.theme;
  
  # Import theme utilities and registry
  utils = import ./utils.nix { inherit lib; };
  registry = import ./registry.nix { inherit lib; };
  
  # Default to beige theme if no runtime theme is set
  defaultVariant = "beige";
  
  # Runtime theme file that can be changed without rebuilds
  runtimeThemeFile = "${config.xdg.configHome}/theme/current.json";
  
  # Function to read runtime theme or use default
  getRuntimeTheme = 
    let
      themeFile = runtimeThemeFile;
      hasRuntimeTheme = builtins.pathExists themeFile;
    in
    if hasRuntimeTheme
    then builtins.fromJSON (builtins.readFile themeFile)
    else { variant = defaultVariant; custom = null; };
  
  # Get the current palette (either from registry or custom)
  currentPalette = 
    let
      runtimeTheme = getRuntimeTheme;
    in
    if runtimeTheme.custom != null
    then registry.mkTheme runtimeTheme.custom
    else registry.${runtimeTheme.variant or defaultVariant};

  # Use utility function for JSON-safe palette
  paletteForJSON = utils.toJsonSafe currentPalette;
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
      default = "${config.home.homeDirectory}/.config/dotfiles/images/wallpapers";
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
        variant = getRuntimeTheme.variant or defaultVariant;
        isCustom = (getRuntimeTheme.custom or null) != null;
        colors = paletteForJSON;
        font = cfg.font;
        spacing = { borderRadius = cfg.borderRadius; gap = cfg.gap; };
      };
      
      "theme/palette.sh".text = ''
        export THEME_VARIANT="${getRuntimeTheme.variant or defaultVariant}"
        export THEME_BASE="${currentPalette.base}"
        export THEME_SURFACE="${currentPalette.surface}"
        export THEME_OVERLAY="${currentPalette.overlay}"
        export THEME_TEXT="${currentPalette.text}"
        export THEME_SUBTEXT="${currentPalette.subtext}"
        export THEME_MUTED="${currentPalette.muted}"
        export THEME_PRIMARY="${currentPalette.primary}"
        export THEME_SECONDARY="${currentPalette.secondary}"
        export THEME_LOVE="${currentPalette.love}"
        export THEME_GOLD="${currentPalette.gold}"
        export THEME_FOAM="${currentPalette.foam}"
        export THEME_PINE="${currentPalette.pine}"
        
        # Backward compatibility
        export THEME_BACKGROUND="${currentPalette.background}"
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
      # Live theme switching - no rebuild required
      (pkgs.writeShellScriptBin "theme-switch" ''
        #!/usr/bin/env bash
        set -e
        
        CONFIG_DIR="${config.xdg.configHome}"
        THEME_DIR="$CONFIG_DIR/theme"
        THEME_FILE="$THEME_DIR/current.json"
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
        
        mkdir -p "$THEME_DIR"
        cat > "$THEME_FILE" <<EOF
{
  "variant": "$VARIANT",
  "custom": null
}
EOF
        
        echo "🔄 Reloading applications..."
        
        # Reload kitty
        killall -SIGUSR1 kitty 2>/dev/null || true
        
        # Reload tmux
        tmux source-file "$CONFIG_DIR/tmux/tmux.conf" 2>/dev/null || true
        
        # Reload aerospace/barik if on macOS
        pkill -SIGUSR1 barik 2>/dev/null || true
        
        echo "✅ Theme switched to: $VARIANT"
        echo "💡 Some applications may require a restart to fully apply the theme"
      '')
       # Live wallpaper-based theme generation
      (pkgs.writeShellScriptBin "theme-from-wallpaper" ''
        #!/usr/bin/env bash
        set -euo pipefail
        
        CONFIG_DIR="${config.xdg.configHome}"
        THEME_DIR="$CONFIG_DIR/theme"
        THEME_FILE="$THEME_DIR/current.json"
        WALLPAPER_DIR="${cfg.wallpaperDir}"
        
        # Colors for UX
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[1;33m'
        BLUE='\033[0;34m'
        NC='\033[0m'
        
        # Validate wallpaper directory exists
        if [ ! -d "$WALLPAPER_DIR" ]; then
          echo -e "''${RED}Error: Wallpaper directory not found: $WALLPAPER_DIR''${NC}" >&2
          echo -e "''${YELLOW}Please create the directory or update theme.wallpaperDir''${NC}" >&2
          exit 1
        fi
        
        # If no arguments, use fzf to select wallpaper
        if [ $# -eq 0 ]; then
          cd "$WALLPAPER_DIR"
          
          IMAGES=$(${pkgs.findutils}/bin/find . -type f \
            \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null)
          
          if [ -z "$IMAGES" ]; then
            echo -e "''${YELLOW}No images found in $WALLPAPER_DIR''${NC}"
            exit 0
          fi
          
          SELECTED=$(echo "$IMAGES" | sed 's|^./||' | ${pkgs.fzf}/bin/fzf \
            --height=100% \
            --border=rounded \
            --prompt="🖼️  Select wallpaper: " \
            --preview="${pkgs.imagemagick}/bin/identify -verbose {} | head -20" \
            --preview-window=right:50%) || exit 0
          
          if [ -z "$SELECTED" ]; then
            exit 0
          fi
          
          WALLPAPER="$WALLPAPER_DIR/$SELECTED"
        else
          WALLPAPER="$1"
          if [ ! -f "$WALLPAPER" ]; then
            echo -e "''${RED}Error: Wallpaper not found: $WALLPAPER''${NC}" >&2
            exit 1
          fi
        fi
        
        echo -e "''${BLUE}🎨 Extracting theme from wallpaper...''${NC}"
        
        # Use gowall to extract theme and set wallpaper
        ${pkgs.gowall}/bin/gowall "$WALLPAPER"
        
        # TODO: Extract colors from gowall output and create custom theme
        # For now, we'll use a default theme
        # In the future, gowall should output JSON with extracted colors
        
        echo -e "''${GREEN}✅ Wallpaper and theme applied''${NC}"
        echo -e "''${YELLOW}💡 Color extraction from gowall will be implemented in the future''${NC}"
        
        # Reload applications
        killall -SIGUSR1 kitty 2>/dev/null || true
        tmux source-file "$CONFIG_DIR/tmux/tmux.conf" 2>/dev/null || true
        pkill -SIGUSR1 barik 2>/dev/null || true
      '')
      
      (pkgs.writeShellScriptBin "theme-list" ''
        #!/usr/bin/env bash
        
        echo "╔════════════════════════════════════════╗"
        echo "║       Available Themes                 ║"
        echo "╚════════════════════════════════════════╝"
        echo ""
        ${lib.concatMapStrings (t: "echo \" * ${t}\"\n") registry.available}
        echo ""
        echo "Usage:"
        echo "  theme-switch <name>          # Switch theme"
        echo "  theme-from-wallpaper [img]   # Generate from wallpaper"
        echo "  theme-info                   # Show current theme"
      '')
      
      (pkgs.writeShellScriptBin "theme-info" ''
        #!/usr/bin/env bash
        
        THEME_FILE="${config.xdg.configHome}/theme/palette.json"
        
        if [ ! -f "$THEME_FILE" ]; then
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
        ' "$THEME_FILE"
      '')
    ];
    
    # Shell aliases for convenience
    home.shellAliases = {
      wp = "theme-from-wallpaper";
      wallpaper = "theme-from-wallpaper";
    };
  };
}
