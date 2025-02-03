{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wallust;
in
{
  options.services.wallust = {
    ...existing code...

    backend = mkOption {
      type = types.enum [ "full" "resized" "wal" "thumb" "fastresize" "kmeans" ];
      default = "wal";
      description = "Image parsing backend to get colors. Options are: full (original size), resized, wal, thumb, fastresize, or kmeans";
    };

    colorSpace = mkOption {
      type = types.enum [ "lab" "labmixed" "lch" "lchmixed" ];
      default = "labmixed";
      description = "Color space used to produce and select the most prominent colors";
    };

    palette = mkOption {
      type = types.enum [
        "dark" "dark16" "harddark" "harddark16" 
        "light" "light16" "softdark" "softdark16"
        "softlight" "softlight16"
      ];
      default = "dark16";
      description = ''
        Color scheme to use for arranging prominent colors:
        dark - 8 dark colors, dark background and light contrast
        dark16 - Same as dark but uses 16 colors trick
        harddark - Same as dark with hard hue colors
        harddark16 - Harddark with 16 color variation
        light - Light bg, dark fg
        light16 - Same as light but uses 16 color trick
        softdark - Variant of softlight with dark background
        softdark16 - softdark with 16 color variation
        softlight - Light with soft pastel colors
        softlight16 - softlight with 16 color variation
      '';
    };

    threshold = mkOption {
      type = types.int;
      default = 11;
      description = ''
        Difference threshold between similar colors:
        1: Not perceptible by human eyes
        1-2: Perceptible through close observation
        2-10: Perceptible at a glance
        11-49: Colors are more similar than opposite
        100: Colors are exact opposite
      '';
    };
  };
}