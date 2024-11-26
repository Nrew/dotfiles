{outputs, ...}: {
  imports = [
    #../modules/fastfetch.nix
    ../modules/kitty.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    #../modules/tmux.nix
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

#   pywal
#        neovim
#        git
#        tmux
#        fzf
#        starship
#        kitty
#        spotify
#        spicetify-cli
#        sshs
#    vscode

}