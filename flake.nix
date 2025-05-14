{
  description = "Owl NixOS Configuration";

  #──────────────────────────────────────────────────────────────────
  # Inputs Configuration
  #──────────────────────────────────────────────────────────────────

  inputs = {
    # NixPKGS
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Nix Darwin (for macOS)
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin
    catppuccin.url = "github:catppuccin/nix";

    # NixCats
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # Textfox
    textfox.url = "github:adriankarlen/textfox";
    
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
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
      inherit (self) inputs;

      user = "nrew";
      linuxSystems = ["x86_64-linux"];
      darwinSystems = ["aarch64-darwin"];
      
      forAllSystems = f: nixpkgs.lib.genAttrs (darwinSystems ++ linuxSystems) f;

      #──────────────────────────────────────────────────────────────────
      # Nixpkgs Configuration
      #──────────────────────────────────────────────────────────────────
      
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };

      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };
      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "install" = mkApp "install" system;
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "rollback" = mkApp "rollback" system;
      };

      #──────────────────────────────────────────────────────────────────
      # macOS (nix-darwin) Configuration
      #──────────────────────────────────────────────────────────────────

      mkDarwinConfiguration = system: hostname:
        let
          sharedSpecialArgs = {
            inherit inputs self user;
          };
        in 
          darwin.lib.darwinSystem { 
            inherit system;
            specialArgs = sharedSpecialArgs;
            modules = [
              (./. + "/hosts/${hostname}")

              home-manager.darwinModules.home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = sharedSpecialArgs;
                  users.${user} = import ./home;
                };
              } 

            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
    
      #──────────────────────────────────────────────────────────────────
      #  Configuration
      #──────────────────────────────────────────────────────────────────
      
      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );


    in {
      inherit legacyPackages;
      devShells = forAllSystems devShell;

      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      #──────────────────────────────────────────────────────────────────
      # Outputs
      #──────────────────────────────────────────────────────────────────

      darwinConfigurations = {
        owl = mkDarwinConfiguration (builtins.head darwinSystems) "owl";
      };

      #──────────────────────────────────────────────────────────────────
      # Overlays Configuration
      #──────────────────────────────────────────────────────────────────

      overlays = import ./overlays { inherit inputs; };
    };
}
