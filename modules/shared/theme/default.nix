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
      THEME_VARIANT = getRuntimeTheme.variant or defaultVariant;
      THEME_IS_CUSTOM = if (getRuntimeTheme.custom or null) != null then "true" else "false";
    };
    
    xdg.configFile = {
      # Generate static theme files for ALL themes
      # Each theme gets its own directory with app-specific configs
    } // (
      # For each theme in registry, generate app config files
      lib.listToAttrs (lib.flatten (map (themeName:
        let
          themeColors = registry.${themeName};
        in [
          # Kitty theme file
          {
            name = "themes/${themeName}/kitty.conf";
            value.text = ''
              # ${themeName} theme for Kitty
              background ${themeColors.base}
              foreground ${themeColors.text}
              selection_background ${themeColors.overlay}
              selection_foreground ${themeColors.text}
              cursor ${themeColors.text}
              cursor_text_color ${themeColors.base}
              url_color ${themeColors.primary}
              
              color0 ${themeColors.overlay}
              color8 ${themeColors.muted}
              color1 ${themeColors.red}
              color9 ${themeColors.red}
              color2 ${themeColors.green}
              color10 ${themeColors.green}
              color3 ${themeColors.orange}
              color11 ${themeColors.orange}
              color4 ${themeColors.cyan}
              color12 ${themeColors.cyan}
              color5 ${themeColors.primary}
              color13 ${themeColors.primary}
              color6 ${themeColors.secondary}
              color14 ${themeColors.secondary}
              color7 ${themeColors.text}
              color15 ${themeColors.text}
              
              active_tab_foreground ${themeColors.text}
              active_tab_background ${themeColors.primary}
              inactive_tab_foreground ${themeColors.subtext0}
              inactive_tab_background ${themeColors.surface}
              tab_bar_background ${themeColors.base}
              
              active_border_color ${themeColors.primary}
              inactive_border_color ${themeColors.overlay}
            '';
          }
          
          # Tmux theme file
          {
            name = "themes/${themeName}/tmux.conf";
            value.text = ''
              # ${themeName} theme for Tmux
              set -g status-style "bg=${themeColors.surface},fg=${themeColors.text}"
              set -g status-left "#[fg=${themeColors.base},bg=${themeColors.primary},bold] #S #[fg=${themeColors.primary},bg=${themeColors.surface},nobold]"
              set -g status-right "#[fg=${themeColors.overlay},bg=${themeColors.surface}]#[fg=${themeColors.text},bg=${themeColors.overlay}] %Y-%m-%d #[fg=${themeColors.primary},bg=${themeColors.overlay}]#[fg=${themeColors.base},bg=${themeColors.primary},bold] %H:%M "
              
              set -g window-status-format "#[fg=${themeColors.surface},bg=${themeColors.overlay}]#[fg=${themeColors.text},bg=${themeColors.overlay}] #I #W #[fg=${themeColors.overlay},bg=${themeColors.surface}]"
              set -g window-status-current-format "#[fg=${themeColors.surface},bg=${themeColors.green}]#[fg=${themeColors.base},bg=${themeColors.green},bold] #I #W #[fg=${themeColors.green},bg=${themeColors.surface},nobold]"
              
              set -g pane-border-style "fg=${themeColors.overlay}"
              set -g pane-active-border-style "fg=${themeColors.primary}"
              
              set -g message-style "fg=${themeColors.base},bg=${themeColors.primary}"
              set -g mode-style "bg=${themeColors.primary},fg=${themeColors.base}"
            '';
          }
          
          # Neovim palette file
          {
            name = "themes/${themeName}/nvim-palette.lua";
            value.text = ''
              -- ${themeName} theme palette for Neovim
              return {
                base = "${themeColors.base}",
                mantle = "${themeColors.mantle}",
                surface = "${themeColors.surface}",
                overlay = "${themeColors.overlay}",
                text = "${themeColors.text}",
                subtext0 = "${themeColors.subtext0}",
                subtext1 = "${themeColors.subtext1}",
                muted = "${themeColors.muted}",
                primary = "${themeColors.primary}",
                secondary = "${themeColors.secondary}",
                red = "${themeColors.red}",
                orange = "${themeColors.orange}",
                yellow = "${themeColors.yellow}",
                green = "${themeColors.green}",
                cyan = "${themeColors.cyan}",
                blue = "${themeColors.blue}",
              }
            '';
          }
        ]
      ) registry.available))
    ) // {
      # Note: current-theme symlinks are managed by theme-switch script, not home-manager
      # This avoids conflicts with mkOutOfStoreSymlink and home-manager's backup mechanism
      
      # Legacy palette.json for compatibility
      "theme/palette.json".text = builtins.toJSON {
        variant = getRuntimeTheme.variant or defaultVariant;
        isCustom = (getRuntimeTheme.custom or null) != null;
        colors = paletteForJSON;
        font = cfg.font;
        spacing = { borderRadius = cfg.borderRadius; gap = cfg.gap; };
      };
      
      # Shell environment variables for theme
      "theme/palette.sh".text = ''
        export THEME_VARIANT="${getRuntimeTheme.variant or defaultVariant}"
        # Base colors (4)
        export THEME_BASE="${currentPalette.base}"
        export THEME_MANTLE="${currentPalette.mantle}"
        export THEME_SURFACE="${currentPalette.surface}"
        export THEME_OVERLAY="${currentPalette.overlay}"
        # Text colors (4)
        export THEME_TEXT="${currentPalette.text}"
        export THEME_SUBTEXT0="${currentPalette.subtext0}"
        export THEME_SUBTEXT1="${currentPalette.subtext1}"
        export THEME_MUTED="${currentPalette.muted}"
        # Accent colors (8)
        export THEME_PRIMARY="${currentPalette.primary}"
        export THEME_SECONDARY="${currentPalette.secondary}"
        export THEME_RED="${currentPalette.red}"
        export THEME_ORANGE="${currentPalette.orange}"
        export THEME_YELLOW="${currentPalette.yellow}"
        export THEME_GREEN="${currentPalette.green}"
        export THEME_CYAN="${currentPalette.cyan}"
        export THEME_BLUE="${currentPalette.blue}"
        
        # Backward compatibility aliases
        export THEME_SUBTEXT="${currentPalette.subtext}"
        export THEME_BACKGROUND="${currentPalette.background}"
        export THEME_SUCCESS="${currentPalette.success}"
        export THEME_WARNING="${currentPalette.warning}"
        export THEME_ERROR="${currentPalette.error}"
        export THEME_INFO="${currentPalette.info}"
        export THEME_LOVE="${currentPalette.love}"
        export THEME_GOLD="${currentPalette.gold}"
        export THEME_FOAM="${currentPalette.foam}"
        export THEME_PINE="${currentPalette.pine}"
      '';
      
      "theme/palette.css".text = ''
        :root {
          /* Base colors (4) */
          --base: ${currentPalette.base};
          --mantle: ${currentPalette.mantle};
          --surface: ${currentPalette.surface};
          --overlay: ${currentPalette.overlay};
          
          /* Text colors (4) */
          --text: ${currentPalette.text};
          --subtext0: ${currentPalette.subtext0};
          --subtext1: ${currentPalette.subtext1};
          --muted: ${currentPalette.muted};
          
          /* Accent colors (8) */
          --primary: ${currentPalette.primary};
          --secondary: ${currentPalette.secondary};
          --red: ${currentPalette.red};
          --orange: ${currentPalette.orange};
          --yellow: ${currentPalette.yellow};
          --green: ${currentPalette.green};
          --cyan: ${currentPalette.cyan};
          --blue: ${currentPalette.blue};
          
          /* Backward compatibility aliases */
          --bg: ${currentPalette.background};
          --subtext: ${currentPalette.subtext};
          --success: ${currentPalette.success};
          --warning: ${currentPalette.warning};
          --error: ${currentPalette.error};
          --info: ${currentPalette.info};
        }
      '';
    };
    
    home.packages = [
      # Minimal, efficient theme switching via symlinks
      (pkgs.writeShellScriptBin "theme-switch" ''
        #!/usr/bin/env bash
        set -e
        
        THEME_DIR="${config.xdg.configHome}/themes"
        CURRENT_DIR="${config.xdg.configHome}/current-theme"
        VARIANT="$1"
        
        # Ensure current-theme directory exists
        mkdir -p "$CURRENT_DIR"
        
        if [ -z "$VARIANT" ]; then
          echo "╔════════════════════════════════════════╗"
          echo "║       Available Themes                 ║"
          echo "╚════════════════════════════════════════╝"
          echo ""
          ${lib.concatMapStrings (t: "echo \"  ${t}\"\n") registry.available}
          echo ""
          echo "Usage: theme-switch <name>"
          exit 1
        fi
        
        # Validate theme exists
        if [ ! -d "$THEME_DIR/$VARIANT" ]; then
          echo "❌ Unknown theme: $VARIANT"
          echo "Theme directory not found: $THEME_DIR/$VARIANT"
          exit 1
        fi
        
        echo "🎨 Switching to: $VARIANT"
        
        # Atomic symlink updates - instant, zero overhead
        ln -sf "$THEME_DIR/$VARIANT/kitty.conf" "$CURRENT_DIR/kitty.conf"
        ln -sf "$THEME_DIR/$VARIANT/tmux.conf" "$CURRENT_DIR/tmux.conf"
        ln -sf "$THEME_DIR/$VARIANT/nvim-palette.lua" "$CURRENT_DIR/nvim-palette.lua"
        
        # Update state file
        mkdir -p "${config.xdg.configHome}/theme"
        echo "$VARIANT" > "${config.xdg.configHome}/theme/current"
        
        # Generate palette.json from current theme
        # Extract colors from kitty.conf to create palette.json
        KITTY_CONF="$THEME_DIR/$VARIANT/kitty.conf"
        if [ -f "$KITTY_CONF" ]; then
          cat > "${config.xdg.configHome}/theme/palette.json" <<EOF
{
  "variant": "$VARIANT",
  "isCustom": false,
  "colors": {
    "base": "$(grep '^background ' "$KITTY_CONF" | awk '{print $2}')",
    "text": "$(grep '^foreground ' "$KITTY_CONF" | awk '{print $2}')",
    "primary": "$(grep '^color5 ' "$KITTY_CONF" | awk '{print $2}')",
    "secondary": "$(grep '^color6 ' "$KITTY_CONF" | awk '{print $2}')",
    "red": "$(grep '^color1 ' "$KITTY_CONF" | awk '{print $2}')",
    "orange": "$(grep '^color3 ' "$KITTY_CONF" | awk '{print $2}')",
    "green": "$(grep '^color2 ' "$KITTY_CONF" | awk '{print $2}')",
    "cyan": "$(grep '^color4 ' "$KITTY_CONF" | awk '{print $2}')",
    "overlay": "$(grep '^color0 ' "$KITTY_CONF" | awk '{print $2}')",
    "muted": "$(grep '^color8 ' "$KITTY_CONF" | awk '{print $2}')",
    "subtext0": "$(grep '^inactive_tab_foreground ' "$KITTY_CONF" | awk '{print $2}')"
  }
}
EOF
        fi
        
        # Reload applications (minimal overhead)
        if command -v kitty &> /dev/null; then
          kitty @ --to unix:/tmp/kitty set-colors -a "$CURRENT_DIR/kitty.conf" 2>/dev/null || \
          killall -SIGUSR1 kitty 2>/dev/null || true
        fi
        
        if command -v tmux &> /dev/null; then
          tmux source-file "${config.xdg.configHome}/tmux/tmux.conf" 2>/dev/null || true
        fi
        
        # Reload btop theme
        if command -v btop-reload-theme &> /dev/null; then
          btop-reload-theme 2>/dev/null || true
        fi
        
        # macOS window manager reload
        pkill -SIGUSR1 barik 2>/dev/null || true
        pkill -SIGUSR1 sketchybar 2>/dev/null || true
        
        echo "✅ Theme switched to: $VARIANT"
        echo "💡 Neovim will reload automatically"
      '')
      (pkgs.writeShellScriptBin "theme-cycle" ''
        #!/usr/bin/env bash
        
        THEMES=(${lib.concatStringsSep " " registry.available})
        CURRENT_FILE="${config.xdg.configHome}/theme/current"
        
        # Get current theme
        if [ -f "$CURRENT_FILE" ]; then
          CURRENT=$(cat "$CURRENT_FILE")
        else
          CURRENT="${defaultVariant}"
        fi
        
        # Find next theme
        FOUND=0
        NEXT=""
        for theme in "''${THEMES[@]}"; do
          if [ "$FOUND" = "1" ]; then
            NEXT="$theme"
            break
          fi
          if [ "$theme" = "$CURRENT" ]; then
            FOUND=1
          fi
        done
        
        # If we didn't find a next theme, loop back to first
        if [ -z "$NEXT" ]; then
          NEXT="''${THEMES[0]}"
        fi
        
        # Switch to next theme
        theme-switch "$NEXT"
      '')
      
      (pkgs.writeShellScriptBin "theme-info" ''
        #!/usr/bin/env bash
        
        CURRENT_FILE="${config.xdg.configHome}/theme/current"
        CURRENT_THEME_DIR="${config.xdg.configHome}/current-theme"
        
        if [ ! -f "$CURRENT_FILE" ]; then
          echo "Theme not initialized"
          exit 1
        fi
        
        VARIANT=$(cat "$CURRENT_FILE")
        
        # Function to convert hex to RGB
        hex_to_rgb() {
          local hex=$1
          hex=''${hex#\#}
          printf "%d;%d;%d" 0x''${hex:0:2} 0x''${hex:2:2} 0x''${hex:4:2}
        }
        
        # Function to extract color from kitty config
        get_color() {
          local key=$1
          grep "^$key " "$CURRENT_THEME_DIR/kitty.conf" | awk '{print $2}'
        }
        
        # Function to display a color block with text
        show_color() {
          local name=$1
          local hex=$2
          local rgb=$(hex_to_rgb "$hex")
          
          # Print color name with proper spacing
          printf "  %-12s" "$name:"
          
          # Print color block with the actual color as background
          printf "\033[48;2;''${rgb}m    \033[0m "
          
          # Print hex value in muted color
          printf "\033[2m%s\033[0m\n" "$hex"
        }
        
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║                     Current Theme                          ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo ""
        
        echo "Variant:     $VARIANT"
        echo "Location:    ~/.config/themes/$VARIANT/"
        echo ""
        
        echo "═══════════════════ Base Colors ═══════════════════"
        show_color "Base" "$(get_color 'background')"
        show_color "Surface" "$(get_color 'inactive_tab_background')"
        show_color "Overlay" "$(get_color 'color0')"
        
        echo ""
        echo "═══════════════════ Text Colors ═══════════════════"
        show_color "Text" "$(get_color 'foreground')"
        show_color "Subtext" "$(get_color 'inactive_tab_foreground')"
        show_color "Muted" "$(get_color 'color8')"
        
        echo ""
        echo "═══════════════════ Accent Colors ═════════════════"
        show_color "Primary" "$(get_color 'color5')"
        show_color "Secondary" "$(get_color 'color6')"
        show_color "Red" "$(get_color 'color1')"
        show_color "Orange" "$(get_color 'color3')"
        show_color "Green" "$(get_color 'color2')"
        show_color "Cyan" "$(get_color 'color4')"
        
        echo ""
        echo "═══════════════════ Files ═════════════════════════"
        echo "  Kitty:       $CURRENT_THEME_DIR/kitty.conf"
        echo "  Tmux:        $CURRENT_THEME_DIR/tmux.conf"
        echo "  Neovim:      $CURRENT_THEME_DIR/nvim-palette.lua"
        echo ""
      '')
    ];
    
    # Initialize theme on first activation or if missing
    home.activation.initializeTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
      THEME_DIR="${config.xdg.configHome}/themes"
      CURRENT_DIR="${config.xdg.configHome}/current-theme"
      THEME_STATE="${config.xdg.configHome}/theme"
      DEFAULT_VARIANT="${defaultVariant}"
      
      # Ensure directories exist
      $DRY_RUN_CMD mkdir -p "$CURRENT_DIR"
      $DRY_RUN_CMD mkdir -p "$THEME_STATE"
      
      # Function to create or fix symlink
      ensure_symlink() {
        local target="$1"
        local link="$2"
        local name="$3"
        
        if [ ! -e "$target" ]; then
          $VERBOSE_ECHO "Warning: Theme file not found: $target"
          return 1
        fi
        
        # Remove broken symlink or regular file
        if [ -L "$link" ] && [ ! -e "$link" ]; then
          $VERBOSE_ECHO "Removing broken symlink: $link"
          $DRY_RUN_CMD rm "$link"
        elif [ -f "$link" ] && [ ! -L "$link" ]; then
          $VERBOSE_ECHO "Backing up regular file: $link → $link.backup"
          $DRY_RUN_CMD mv "$link" "$link.backup"
        fi
        
        # Create symlink if it doesn't exist or points to wrong target
        if [ ! -L "$link" ] || [ "$(readlink "$link")" != "$target" ]; then
          $VERBOSE_ECHO "Creating symlink: $link → $target"
          $DRY_RUN_CMD ln -sf "$target" "$link"
        fi
      }
      
      # Initialize theme symlinks
      ensure_symlink "$THEME_DIR/$DEFAULT_VARIANT/kitty.conf" "$CURRENT_DIR/kitty.conf" "Kitty"
      ensure_symlink "$THEME_DIR/$DEFAULT_VARIANT/tmux.conf" "$CURRENT_DIR/tmux.conf" "Tmux"
      ensure_symlink "$THEME_DIR/$DEFAULT_VARIANT/nvim-palette.lua" "$CURRENT_DIR/nvim-palette.lua" "Neovim"
      
      # Initialize theme state file with current theme name
      if [ ! -f "$THEME_STATE/current" ]; then
        $VERBOSE_ECHO "Initializing theme state: $DEFAULT_VARIANT"
        $DRY_RUN_CMD echo "$DEFAULT_VARIANT" > "$THEME_STATE/current"
      fi
      
      $VERBOSE_ECHO "Theme initialization complete (default: $DEFAULT_VARIANT)"
    '';
    
    # Shell aliases for convenience
    home.shellAliases = {
      # Theme switching aliases removed - use 'theme-switch <name>' or 'theme-cycle' directly
    };
  };
}
