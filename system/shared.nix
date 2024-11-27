{ config, pkgs, ... }:

{
    # ────────────────────────────────────────────────────────────────
    # Import Modules
    # ────────────────────────────────────────────────────────────────

    imports = [];

    # ────────────────────────────────────────────────────────────────
    # Shared System Packages
    # ────────────────────────────────────────────────────────────────

    environment.systemPackages = with pkgs; [
        (python3.withPackages (ps: with ps; [
            pip
            virtualenv
        ]))
        docker          # Requires system-level daemon
        jq              # General-purpose command-line JSON processor
        texinfo         # Needed for compiling tools like Emacs
        htop            # System-wide resource monitor
        lua5_4
    ];

    # ────────────────────────────────────────────────────────────────
    # Fonts Configuration
    # ────────────────────────────────────────────────────────────────

    fonts = {
        packages = with pkgs; [
            (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })  # JetBrainsMono Nerd Font
            (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })       # FiraCode Nerd Font
        ];
    };

    # ────────────────────────────────────────────────────────────────
    # Environment Variables
    # ────────────────────────────────────────────────────────────────

    
    # Define system-wide environment variables
    environment.variables = {
        EDITOR = "nvim";                 # Default editor
        TERM = "kitty";                  # Terminal type
        LANG = "en_US.UTF-8";            # Locale settings
        LC_ALL = "en_US.UTF-8";          # Locale settings
    };

    # sessionVariables = with pkgs; {
    #    PATH = "${git}/bin:${neovim}/bin:${kitty}/bin:$PATH";
    #    MANPATH = "${man-db}/share/man:$MANPATH";
    #    INFOPATH = "${texinfo}/share/info:$INFOPATH";
    # };

    # ────────────────────────────────────────────────────────────────
    # Core Nix Settings
    # ────────────────────────────────────────────────────────────────

    nixpkgs.config.allowUnfree = true;

    nix = {
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
    };

    nix.package = pkgs.nix; # Set the Nix package as the default

    system.stateVersion = 5; # Used for backwards compatibility
}