{
  description = "Nrew's nix-darwin system flake";

  # ────────────────────────────────────────────────────────────────
  # Inputs Configuration
  # ────────────────────────────────────────────────────────────────

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    #home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # Nix Darwin (for macOS)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  # ────────────────────────────────────────────────────────────────
  # Outputs Configuration
  # ────────────────────────────────────────────────────────────────

  outputs = {
    self,
    darwin,
    home-manager,
    nix-homebrew,
    nixpkgs,
    ...
  } @ inputs let
    inherit (self) outputs;

    # ────────────────────────────────────────────────────────────────
    # User Configuration
    # ────────────────────────────────────────────────────────────────

    users = {
      nrew = {
        name = "Nrew";
        editor = "nvim";
      };
    };

    # ────────────────────────────────────────────────────────────────
    # macOS (nix-darwin) Configuration
    # ────────────────────────────────────────────────────────────────

    mkDarwinConfiguration = hostname: username:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";                 # macOS on Apple Silicon
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};          # Specific user configuration
        };
        modules = [
          ./hosts/shared.nix                       # Abstract configuration
          ./hosts/${hostname}/configuration.nix    # Host-specific configuration
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

    # ────────────────────────────────────────────────────────────────
    # Home Manager Configuration
    # ────────────────────────────────────────────────────────────────

    # mkHomeConfiguration = system: username: hostname:
    #  home-manager.lib.homeManagerConfiguration {
    #    pkgs = import nixpkgs { inherit system; }; # Use system-specific nixpkgs
    #    extraSpecialArgs = {
    #      inherit inputs outputs;
    #      userConfig = users.${username};           # Specific user configuration
    #    };
    #    modules = [
    #      ./users/${username}/${hostname}.nix       # User+host-specific configuration
    #    ];
    #  };

    # ────────────────────────────────────────────────────────────────
    # Outputs
    # ────────────────────────────────────────────────────────────────

    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro
      darwinConfigurations = {
        # macOS configuration for this machine
        "MacBook-Pro" = mkDarwinConfiguration "MacBook-Pro" "nrew";
      };

    #  # Home Manager configuration for "username" on "system"
    #  homeConfigurations = {
    #    # Home Manager configuration for the user on the host
    #    "nrew-macbook" = mkHomeConfiguration "aarch64-darwin" "nrew" "MacBook-Pro";
    #  };

      overlays = import ./overlays { inherit inputs; };
    };
}
