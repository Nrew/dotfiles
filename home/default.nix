{ config, pkgs, lib, home-manager, ... }:
let
    user = "%USER%";
    isDarwin = pkgs.stdenv.isDarwin;
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

    #──────────────────────────────────────────────────────────────────
    # Home Configuration
    #──────────────────────────────────────────────────────────────────
    home = {
        enableNixpkgsReleaseCheck = false;
        username = user;
        homeDirectory =
            if isDarwin
            then "/Users/${user}"
            else "/home/${user}";

        # Path modifications
        sessionPath = 
        [ 
            "/opt/homebrew/bin"
        ];

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        stateVersion = "24.11";
    };
}