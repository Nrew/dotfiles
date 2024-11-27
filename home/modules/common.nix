{outputs, ...}: {
  imports = [
    #../modules/fastfetch.nix
    ../modules/kitty.nix
    #../modules/fzf.nix
    #../modules/git.nix
    #../modules/lazygit.nix
<<<<<<< HEAD
    ../modules/neovim/neovim.nix
=======
    ../modules/neovim.nix
>>>>>>> de4332a3299cc6d4ec9fead92d94a5c1821e7f2c
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