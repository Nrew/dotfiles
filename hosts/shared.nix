{ pkgs, ... }:

let user = "nrew"; in

{
    # ────────────────────────────────────────────────────────────────
    # Import Modules
    # ────────────────────────────────────────────────────────────────

    imports = [];

    # ────────────────────────────────────────────────────────────────
    # System Packages
    # ────────────────────────────────────────────────────────────────

    environment.systemPackages = with pkgs; [
        docker
        git
        git-lfs
        neovim
        cmake
        cargo
        texinfo

        (python3.withPackages (ps: with ps; [
            pip
            virtualenv
        ]))
    ];

    # ────────────────────────────────────────────────────────────────
    # Fonts Configuration
    # ────────────────────────────────────────────────────────────────

    fonts = {
        packages = with pkgs; [
            maple-mono.truetype
            maple-mono.NF-unhinted
            nerd-fonts.symbols-only
            nerd-fonts.jetbrains-mono
            nerd-fonts.fira-code
            nerd-fonts.iosevka
        ];
    };

    # ────────────────────────────────────────────────────────────────
    # Environment Variables
    # ────────────────────────────────────────────────────────────────

    environment.variables = {
        LANG   = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
    };

    # ────────────────────────────────────────────────────────────────
    # Nix Settings
    # ────────────────────────────────────────────────────────────────

    nixpkgs.config.allowUnfree = true;

    nix = {
      package = pkgs.nix;
	    settings = {
            trusted-users = [ "@admin" "${user}" ];
            substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
            trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
        };

        gc = {
            automatic = true;
            interval = { Weekday = 0; Hour = 2; Minute = 0; };
            options = "--delete-older-than 30d";
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
