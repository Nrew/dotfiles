{ lib, ... }:

{
  imports = [
    ./fastfetch.nix
    ./tmux.nix
    ./zsh.nix
    ./fzf
    ./git
    ./kitty
    ./neovim
    ./starship
    ./spicetify
    ./raycast
    ./ghostty
    ./btop
  ];
}
