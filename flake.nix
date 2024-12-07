{
  description = "Nrew's system configuration";

  #──────────────────────────────────────────────────────────────────
  # Inputs Configuration
  #──────────────────────────────────────────────────────────────────

  inputs = {
    # NixPKGS
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Nix Darwin (for macOS)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  #──────────────────────────────────────────────────────────────────
  # Outputs Configuration
  #──────────────────────────────────────────────────────────────────

  outputs = { self, darwin, home-manager, nix-homebrew, nixpkgs, ... } @ inputs: 
    let
      inherit (self) outputs;

      #──────────────────────────────────────────────────────────────────
      # System Configuration
      #──────────────────────────────────────────────────────────────────

      user = "nrew";
      
      systems = {
        darwin = ["aarch64-darwin"];
        linux = ["x86_64-linux" "aarch64-linux"];
      };

      forAllSystems = nixpkgs.lib.genAttrs (systems.darwin ++ systems.linux);

      #──────────────────────────────────────────────────────────────────
      # macOS (nix-darwin) Configuration
      #──────────────────────────────────────────────────────────────────

      mkDarwinConfiguration = system: hostname:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs system user;
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            
            # Enable Home Manager
            home-manager.darwinModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit user;
                };
                users.${user} = import ./home;
              };
            } 

            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
    in {
      #──────────────────────────────────────────────────────────────────
      # Outputs
      #──────────────────────────────────────────────────────────────────

      darwinConfigurations = {
        "MacBook-Pro" = mkDarwinConfiguration (builtins.head systems.darwin) "MacBook-Pro";
      };

      #──────────────────────────────────────────────────────────────────
      # Overlays Configuration
      #──────────────────────────────────────────────────────────────────

      overlays = import ./overlays { inherit inputs; };
    };
}
