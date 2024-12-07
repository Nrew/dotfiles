{outputs, ...}: {
  imports = [
    #../modules/fastfetch.nix
    ../modules/kitty.nix
    #../modules/fzf.nix
    ../modules/git.nix
    #../modules/lazygit.nix
    #../modules/tmux.nix
    #../modules/starship.nix
    ../modules/zsh.nix
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };
}