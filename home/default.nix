{ config, pkgs, user, ... }: 
let
    isDarwin = pkgs.stdenv.isDarwin;
in
{
    #──────────────────────────────────────────────────────────────────
    # Imports & Core Configuration
    #──────────────────────────────────────────────────────────────────
    imports = [ 
        # Add your module imports here
        ../modules/common.nix
        ../modules/aerospace.nix
        ../modules/sketchybar.nix
    ];

    # Enable home-manager
    programs.home-manager.enable = true;

    #──────────────────────────────────────────────────────────────────
    # Module Configuration
    #──────────────────────────────────────────────────────────────────

    darwin.wm.aerospace = {
        enable = true;
        settings.apps = {
            # terminal = {
            #     enable = true;
            #     package = pkgs.alacritty;
            #     app-id = "org.alacritty";
            #     workspace = 2;
            #     key = "enter";
            # };
            # browser = {
            #     enable = true;
            #     package = pkgs.brave;
            #     app-id = "com.brave.Browser";
            #     workspace = 1;
            #     key = "b";
            # };
        };
        settings.gaps = {
            inner = 6;
            outer = 6;
        };
    };

    services.sketchybar = {
        enable = true;
    }

    #──────────────────────────────────────────────────────────────────
    # Home Configuration
    #──────────────────────────────────────────────────────────────────
    home = {
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