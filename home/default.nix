{ config, pkgs, user, ... }: 

{
    #──────────────────────────────────────────────────────────────────
    # Imports & Core Configuration
    #──────────────────────────────────────────────────────────────────
    imports = [ 
        # Add your module imports here
        ./modules/common.nix
        ./modules/aerospace.nix
    ];

    # Enable home-manager
    programs.home-manager.enable = true;

    #──────────────────────────────────────────────────────────────────
    # Home Configuration
    #──────────────────────────────────────────────────────────────────
    home = {
        username = user;
        homeDirectory =
            if pkgs.stdenv.isDarwin
            then "/Users/${user}"
            else "/home/${user}";

        # Path modifications
        sessionPath = 
            if pkgs.stdenv.isDarwin
            then [ 
                "/opt/homebrew/bin"
            ] 
            else [];

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        stateVersion = "24.05";
    };

    #──────────────────────────────────────────────────────────────────
    # System Specific Settings
    #──────────────────────────────────────────────────────────────────
    # Enable systemd service management on Linux only
    systemd.user.startServices = 
        if pkgs.stdenv.isDarwin
        then false
        else "sd-switch";

    # Add any other system-specific configurations here using
    # if pkgs.stdenv.isDarwin then ... else ...
}