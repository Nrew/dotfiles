{ config, pkgs, ... }:

let user = "%USER%"; in

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
        wget        # Command-line file downloader
        curl        # Command-line URL transfer tool
        
        jq          # A lightweight and flexible command-line JSON processor
        texinfo     # Needed for compiling tools like Emacs
        htop        # System-wide resource monitor
        neovim      # Modern text editor
        cava        # Visualizer for audio output
        git         # Version control system
        git-lfs     # Git extension for large files
        tmux        # Terminal multiplexer
        starship    # Cross-shell prompt
        kitty       # Modern terminal emulator
        fastfetch   # Fast system information tool
        fzf         # Fuzzy finder for the terminal
    ];

    # ────────────────────────────────────────────────────────────────
    # Fonts Configuration
    # ────────────────────────────────────────────────────────────────

    fonts = {
        packages = with pkgs; [
            material-design-icons       # Material Design Icons
            font-awesome                # Font Awesome

            nerd-fonts.symbols-only     # Symbols Nerd Font
            nerd-fonts.jetbrains-mono   # JetBrainsMono Nerd Font
            nerd-fonts.fira-code        # FiraCode Nerd Font
            nerd-fonts.iosevka          # Iosevka Nerd Font
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
        # Set the Nix package as the default to ensure Nix commands are available system-wide
        package = pkgs.nix;
        settings = {
            trusted-users = [ "@admin" "${user}" ];
            substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
            trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
            experimental-features = [ "nix-command" "flakes" ];
            optimize-store = "automatic";
        };
        gc = {
            user = "root";    # Run garbage collection as the root user
            automatic = true; # Enable automatic garbage collection
            interval = { Weekday = 0; Hour = 2; Minute = 0; }; # Run garbage collection every Sunday at 2:00 AM
            options = "--delete-older-than 30d"; # Delete generations older than 30 days
        };
    };

    # The stateVersion attribute is used to specify the version of NixOS
    # to maintain backwards compatibility with older configurations.
    # Changing this value can affect the behavior of the system.
    system.stateVersion = 5;
}