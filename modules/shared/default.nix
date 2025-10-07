{ lib, ... }:

{
  imports = [
    ./theme
    ./kitty
    ./tmux
    ./zsh
    ./starship
    ./neovim
    ./git
    ./fastfetch
    ./fzf
    ./btop
    ./zen
  ];
}
