{ lib, ... }:

{
  imports = [
    ./theme
    ./kitty
    ./tmux
    ./zsh
    ./starship
    ./git
    ./fastfetch
    ./fzf
    ./btop
  ];
}
