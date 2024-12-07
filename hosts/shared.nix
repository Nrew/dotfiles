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
        docker      # Requires system-level daemon
        jq          # General-purpose command-line JSON processor
        texinfo     # Needed for compiling tools like Emacs
        htop        # System-wide resource monitor
    ];

    # ────────────────────────────────────────────────────────────────
    # Fonts Configuration
    # ────────────────────────────────────────────────────────────────

    fonts = {
        packages = with pkgs; [
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })  # JetBrainsMono Nerd Font
            (nerdfonts.override { fonts = [ "FiraCode" ]; })       # FiraCode Nerd Font
        ];
    };

    # ────────────────────────────────────────────────────────────────
    # Environment Variables
    # ────────────────────────────────────────────────────────────────

    # Define system-wide environment variables
    environment.variables = {
        LANG   = "en_US.UTF-8";  # Set the default system language
        LC_ALL = "en_US.UTF-8";  # Set the default locale
    };

    # ────────────────────────────────────────────────────────────────
    # Core Nix Settings
    # ────────────────────────────────────────────────────────────────

    nixpkgs.config.allowUnfree = true; # Allow unfree packages to be installed

    nix = {
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
            auto-optimise-store = true;
        };
        gc = {
            automatic = true;
            dates = "weekly";
            randomizedDelaySec = "14m";
            # Keep the last 5 generations
            options = "--delete-older-than +5";
        };
  };

    # Set the Nix package as the default to ensure Nix commands are available system-wide
    nix.package = pkgs.nix; 

    # The stateVersion attribute is used to specify the version of NixOS
    # to maintain backwards compatibility with older configurations.
    # Changing this value can affect the behavior of the system.
    system.stateVersion = 5;
}