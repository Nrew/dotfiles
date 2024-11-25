{
  description = "Nrew's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin ( for MacOS )
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nix-homebrew,
    nixpkgs,
    ... 
  } @ inputs 
  let inherit (self) outputs;

    # Define user-specific configuration
    users = {
      nrew ={
        name = "Nrew";
        editor = "nvim"
      }
    }

    # Function to generate macOS (nix-darwin) configuration
    mkDarwinConfiguration = hostname: username:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";                 # macOs on Apple Silicon
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};          # Specific user configuration
        };
        modules = [
          ./hosts/${hostname}/configuration.nix    # Host-specific configuration
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };
    
    # Function to generate Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; }; # Use system-specific nixpkgs
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username}           # Specific user configuration
        };
        modules = {
          ./home/${username}/${hostname}.nix       # User+host-specific configuration
        }
      }
    
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro
      darwinConfigurations = {
        # macOS configuration for this machine
        "MacBook-Pro" = mkDarwinConfiguration "MacBook-Pro" "nrew";
      };

      # Home Manager configuration for "username" on "system"
      homeConfigurations = {
        # Home Manager configuration for the user on the host
        "nrew-macbook" = mkHomeConfiguration "aarch64-darwin" "nrew" "MacBook-Pro";
      };

      overlays = import ./overlays {inherit inputs;};
    };
}