{ config, pkgs, lib, user, home-manager, ... }:
let
    user = "nrew";
    theme = import ../modules/shared/theme/default.nix { inherit lib; };
in
{
    #──────────────────────────────────────────────────────────────────
    # Imports & Core Configuration
    #──────────────────────────────────────────────────────────────────
    imports = [ 
        # Add your module imports here
        ../modules/shared
    ];

    # Enable home-manager
    programs.home-manager.enable = true;

    # XDG Configuration
    xdg = {
        enable = true;
        configHome = "${config.home.homeDirectory}/.config";
        cacheHome = "${config.home.homeDirectory}/.cache";
        dataHome = "${config.home.homeDirectory}/.local/share";
        stateHome = "${config.home.homeDirectory}/.local/state";
    };

    #──────────────────────────────────────────────────────────────────
    # Home Configuration
    #──────────────────────────────────────────────────────────────────
    home = {
        enableNixpkgsReleaseCheck = false;
        username = user;
        homeDirectory = "/Users/${user}";

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        stateVersion = "24.11";
        
        # Theme configuration
        sessionVariables = {
            TERM = "xterm-256color";
        };
    };
    
    # Export theme for modules
    colorscheme = theme.catppuccin;
}
