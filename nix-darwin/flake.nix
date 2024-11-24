{
  description = "Nrew's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [
	  neovim
	  sshs
	  mkalias
	  kitty
	  raycast
	  sketchybar
	  fzf
	  git
	  tmux
        ];      	

      # Homebrew
      homebrew = {
	enable = true;
      	brews = [
	  "mas"
	];
	casks = [
	
	];
	masApps = {

	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      # Fonts
      fonts.packages = 
       [
	 (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
       ];
      
      # Sketchybar
      services.sketchybar.enable = true;


      # MacOS Defaults
      system.defaults = {
	 dock.autohide = true;
	 dock.persistent-apps = [
	   "/System/Applications/Discord.app"
	   "/System/Applications/Calendar.app"
	 ];
	 finder.FXPreferredViewStyle = "clmv";
	 finder.AppleShowAllExtensions = true;
	 loginwindow.GuestEnabled = false;
	 NSGlobalDomain.AppleICUForce24HourTime = true;
	 NSGlobalDomain.AppleInterfaceStyle = "Dark";
	 NSGlobalDomain.KeyRepeat = 2;
	 screencapture.location = "~/Pictures/Screenshots";
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Pro
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
      	configuration
	nix-homebrew.darwinModules.nix-homebrew
	{
	  nix-homebrew = {
	    enable = true;
	    # Apple Silicon Only
	    # enableRosetta = true;
	    # User owning the Homebrew prefix
	    user = "nrew";
	  };
	}
      ];
    };
  };
}
