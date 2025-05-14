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
    
    # Fix PATH for home-manager activation (ensures defaults command is found)
    home.activation.fixPath = lib.hm.dag.entryBefore ["writeBoundary"] ''
        export PATH="/usr/bin:/usr/sbin:/bin:/sbin:$PATH"
    '';

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
        
        # Ensure macOS system tools are in PATH
        sessionPath = [
            "/usr/bin"
            "/usr/sbin"
            "/bin"
            "/sbin"
        ];
    };
}
