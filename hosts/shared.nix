{ pkgs, ... }:

let user = "nrew"; in

{
    # ────────────────────────────────────────────────────────────────
    # Import Modules
    # ────────────────────────────────────────────────────────────────

    imports = [];

    # ────────────────────────────────────────────────────────────────
    # System-Level Packages (Required for system services and daemons)
    # ────────────────────────────────────────────────────────────────

    environment.systemPackages = with pkgs; [
        # System-level services and daemons
        docker          # Requires system-level daemon
        
        # Core system utilities
        git             # Version control system
        git-lfs         # Git extension for large files
        neovim          # System editor (fallback if home-manager fails)
        
        # Build tools (system-wide for compilation)
        cmake           # Cross-platform build system generator
        cargo           # Rust package manager
        texinfo         # Needed for compiling tools like Emacs
        
        # Python environment (system-wide)
        (python3.withPackages (ps: with ps; [
            pip
            virtualenv
        ]))
    ];

    # ────────────────────────────────────────────────────────────────
    # Fonts Configuration (System-wide)
    # ────────────────────────────────────────────────────────────────

    fonts = {
        packages = with pkgs; [
            # Nix 25.05
            maple-mono.truetype         # Maple Mono font
            maple-mono.NF-unhinted      # Maple Mono Nerd Font
            nerd-fonts.symbols-only     # Symbols Nerd Font
            nerd-fonts.jetbrains-mono   # JetBrainsMono Nerd Font
            nerd-fonts.fira-code        # FiraCode Nerd Font
            nerd-fonts.iosevka          # Iosevka Nerd Font
        ];
    };

    # ────────────────────────────────────────────────────────────────
    # Environment Variables (System-wide)
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
        };

        gc = {
            automatic = true;                                  # Enable automatic garbage collection
            interval = { Weekday = 0; Hour = 2; Minute = 0; }; # Run garbage collection every Sunday at 2:00 AM
            options = "--delete-older-than 30d";               # Delete generations older than 30 days
        };

        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    # The stateVersion attribute is used to specify the version of NixOS
    # to maintain backwards compatibility with older configurations.
    # Changing this value can affect the behavior of the system.
    system.stateVersion = 4;
}
