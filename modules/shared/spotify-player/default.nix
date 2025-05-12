{ pkgs, ... }:
{
  programs.spotify-player = {
    enable = true;
    settings = {
      cover_img_scale = 3;
    };
  };
}
