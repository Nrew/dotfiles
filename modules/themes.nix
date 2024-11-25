{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [ wal jq ];

    environment.shellInit = ''
        export WALLPAPER=$HOME/Pictures/Wallpapers/nier_automata.jpg
        wal -i $WALLPAPER
    '';
}
