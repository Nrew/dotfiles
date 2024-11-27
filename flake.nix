{
  description = "Nrew's system configuration";

  # ────────────────────────────────────────────────────────────────
  # Inputs Configuration
  # ────────────────────────────────────────────────────────────────

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  } @ inputs: 
  let
    inherit (self) outputs;

    # ────────────────────────────────────────────────────────────────
    # System Configuration
    # ────────────────────────────────────────────────────────────────

    username = "nrew";

    # Supported Systems
    darwinSystem = "aarch64-darwin";

    # ────────────────────────────────────────────────────────────────
    # macOS (nix-darwin) Configuration
    # ────────────────────────────────────────────────────────────────

    mkDarwinConfiguration = hostname:
      darwin.lib.darwinSystem {
        system = darwinSystem;                     # macOS on Apple Silicon
        specialArgs = {
          inherit inputs outputs hostname username;
        };
        modules = [
          ./system/${hostname}/configuration.nix   # Host-specific configuration

          home-manager.darwinModules.home-manager  # Enable Home Manager
          nix-homebrew.darwinModules.nix-homebrew  # Enable Homebrew
        ];
      };

    # ────────────────────────────────────────────────────────────────
    # Home Manager Configuration
    # ────────────────────────────────────────────────────────────────

    mkHomeConfiguration = system: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; }; # Use system-specific nixpkgs
        extraSpecialArgs = {
          inherit inputs outputs username;           # Specific user configuration
        };
        modules = [
          ./home/default.nix       # User+host-specific configuration
        ];
    };

    # ────────────────────────────────────────────────────────────────
    # Outputs
    # ────────────────────────────────────────────────────────────────

    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro
      darwinConfigurations = {
        # macOS configuration for this machine
        "MacBook-Pro" = mkDarwinConfiguration "MacBook-Pro";
      };

      # Home Manager configuration for "username" on "system"
      homeConfigurations = {
       # Home Manager configuration for the user on the host
       "nrew" = mkHomeConfiguration "aarch64-darwin" "MacBook-Pro";
      };

      overlays = import ./overlays { inherit inputs; };
    };
}
