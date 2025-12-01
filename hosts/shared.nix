{ pkgs, user, ... }:

{
  # ────────────────────────────────────────────────────────────────
  # Import Modules
  # ────────────────────────────────────────────────────────────────

  imports = [ ];

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
      maple-mono-NF
      nerdfonts
    ];
  };

  # ────────────────────────────────────────────────────────────────
  # Environment Variables
  # ────────────────────────────────────────────────────────────────

  environment.variables = {
    LANG = "en_US.UTF-8";
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
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # The stateVersion attribute is used to specify the version of NixOS/nix-darwin
  # to maintain backwards compatibility with older configurations.
  system.stateVersion = 4;
}
