{ config, pkgs, lib, user, ... }:
let
    user = "nrew";
    isDarwin = pkgs.stdenv.isDarwin;
    isLinux = pkgs.stdenv.isLinux;
in
{
    #──────────────────────────────────────────────────────────────────
    # Imports & Core Configuration
    #──────────────────────────────────────────────────────────────────
    imports = [ 
        ../modules/shared
   # ] ++ lib.optionals isDarwin [
        ../modules/owl
   # ] ++ lib.optionals isLinux [
   #     ../modules/crow
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
}
