{ pkgs, ... }:
{
  home.packages = with pkgs; [
    beatprints
  ];

  programs.spotify-player = {
    enable = true;
    settings = {
      cover_img_scale = 3;
    };
  };
}