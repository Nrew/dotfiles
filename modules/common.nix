{ outputs, ... }: 

{
  imports = [
    ../modules/kitty.nix
    ../modules/git.nix
    ../modules/zsh.nix
    ../modules/pywal.nix
  ];

  nixpkgs = {
    # Use the overlay from flake outputs
    overlays = [
      outputs.overlays.stable-packages # Use the stable packages overlay
    ];


    config = {
      allowUnfree = true;             # Allow all unfree packages
      allowUnfreePredicate = _: true; # Predicate for allowing unfree packages
    };
  };

  options.pywal = {
    enable = true;
    backend = "wal";
    wallpaper = null;
    reloadServices = [
      "sketchybar"
      "kitty"
      "tmux"
      ];
  };
}
