{ self, config, pkgs, ... }:

{
    # ────────────────────────────────────────────────────────────────
    # Import Modules
    # ────────────────────────────────────────────────────────────────

    imports = [
        ../modules/kitty.nix
        ../modules/neovim.nix
        ../modules/tmux.nix
        ../modules/starship.nix
        ../modules/spicetify.nix
    ];

    # ────────────────────────────────────────────────────────────────
    # Shared System Packages
    # ────────────────────────────────────────────────────────────────

    environment.systemPackages = with pkgs; [
        (python3.withPackages (ps: with ps; [
            pip
            virtualenv
        ]))
        wal
        feh
        pywal
        neovim
        docker
        git
        tmux
        fzf
        starship
        kitty
        htop
        spotify
        spicetify-cli
        jq
        sshs
        vscode
    ];

    # ────────────────────────────────────────────────────────────────
    # Fonts Configuration
    # ────────────────────────────────────────────────────────────────

    fonts.packages = with pkgs; [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })  # JetBrainsMono Nerd Font
        (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })      # FiraCode Nerd Font
    ];

    fonts.fontconfig.defaultFonts = {
        monospace = [ "JetBrainsMono" ];
        sans = [ "FiraCode" ];
    };

    # ────────────────────────────────────────────────────────────────
    # Environment Variables
    # ────────────────────────────────────────────────────────────────

    home.environmentVariables = {
        EDITOR = "nvim";                 # Default editor
        TERM = "kitty";                  # Terminal type
        SHELL = pkgs.zsh;                # Default shell
        LANG = "en_US.UTF-8";            # Locale settings
        LC_ALL = "en_US.UTF-8";          # Locale settings
    };

    home.sessionVariables = {
        PATH = "${pkgs.git}/bin:${pkgs.neovim}/bin:${pkgs.kitty}/bin:$PATH";
        MANPATH = "${pkgs.man-db}/share/man:$MANPATH";
        INFOPATH = "${pkgs.info}/share/info:$INFOPATH";
    };

    # ────────────────────────────────────────────────────────────────
    # Zsh Configuration
    # ────────────────────────────────────────────────────────────────

    programs.zsh = {
        enable = true;                   # Enable Zsh as the default shell
        shellAliases = {
            ll = "ls -la";               # List files in long format
            gs = "git status";           # Git status shortcut
            vim = "nvim";                # Alias Vim to Neovim
        };
    };

    # ────────────────────────────────────────────────────────────────
    # Core Nix Settings
    # ────────────────────────────────────────────────────────────────

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
        experimental-features = "nix-command flakes"; # Enable new Nix features
        auto-optimize-store = true;                   # Automatically optimize the Nix store
    };

    nix.package = pkgs.nix; # Set the Nix package as the default

    system.configurationRevision = self.rev or self.dirtyRev or null;
    system.stateVersion = 5; # Used for backwards compatibility
}