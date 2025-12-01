{ pkgs, config, lib, ... }:

let
  cfg = config.theme;
in
{
  options.theme = {
    enable = lib.mkEnableOption "theme configuration options";

    # Color scheme selection
    colorScheme = lib.mkOption {
      type = lib.types.enum [ "catppuccin" "rose-pine" "nord" "gruvbox" "tokyo-night" ];
      default = "catppuccin";
      description = "Color scheme to use across all applications";
    };

    # Catppuccin flavor (when colorScheme is catppuccin)
    catppuccin.flavor = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = "mocha";
      description = "Catppuccin flavor variant";
    };

    # Rose Pine variant (when colorScheme is rose-pine)
    rosePine.variant = lib.mkOption {
      type = lib.types.enum [ "main" "moon" "dawn" ];
      default = "main";
      description = "Rose Pine variant";
    };

    # Font configuration
    font = {
      mono = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Monospace font";
      };
      sans = lib.mkOption {
        type = lib.types.str;
        default = "Inter";
        description = "Sans-serif font";
      };
      size = {
        small = lib.mkOption {
          type = lib.types.int;
          default = 12;
          description = "Small font size";
        };
        normal = lib.mkOption {
          type = lib.types.int;
          default = 14;
          description = "Normal font size";
        };
        large = lib.mkOption {
          type = lib.types.int;
          default = 16;
          description = "Large font size";
        };
      };
    };

    # Visual spacing
    borderRadius = lib.mkOption {
      type = lib.types.int;
      default = 8;
      description = "Border radius in pixels";
    };

    gap = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "Gap/padding size in pixels";
    };

    # Wallpaper
    wallpaperDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/dotfiles/images/wallpapers";
      description = "Wallpaper directory path";
    };

    # Opacity settings
    opacity = {
      terminal = lib.mkOption {
        type = lib.types.float;
        default = 0.97;
        description = "Terminal background opacity (0.0 to 1.0)";
      };
      popup = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Popup menu pseudo-transparency (0 to 100)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Export theme info for use in other modules
    home.sessionVariables = {
      THEME_COLOR_SCHEME = cfg.colorScheme;
      THEME_VARIANT = if cfg.colorScheme == "catppuccin" then cfg.catppuccin.flavor
                      else if cfg.colorScheme == "rose-pine" then cfg.rosePine.variant
                      else "default";
    };
  };
}
