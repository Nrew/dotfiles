{ outputs, ... }: 

{
  imports = [
    ../modules/kitty.nix
    ../modules/git.nix
    ../modules/zsh.nix
  ];

  nixpkgs = {
    # Use the overlay from flake outputs
    overlays = [
      outputs.overlays.stable-packages
    ];

    # Allow unfree packages
    config = {
      allowUnfree = true;
      # Recommended for home-manager 24.11
      allowUnfreePredicate = _: true;
    };
  };
}
