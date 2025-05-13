{ config, pkgs, lib, user, home-manager, ... }:
let
    user = "nrew";
in
{
    #──────────────────────────────────────────────────────────────────
    # Imports & Core Configuration
    #──────────────────────────────────────────────────────────────────
    imports = [ 
        # Add your module imports here
        ../modules/owl
    ];

    # Enable home-manager
    programs.home-manager.enable = true;

    # XDG Configuration
    xdg = {
        enable = true;
        xdg_configHome = "${config.users.users.${user}.home}/.config";
        xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
        xdg_stateHome  = "${config.users.users.${user}.home}/.local/state";
    };

    #──────────────────────────────────────────────────────────────────
    # Home Configuration
    #──────────────────────────────────────────────────────────────────
    home = {
        enableNixpkgsReleaseCheck = false;
        username = ${user};
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
}
