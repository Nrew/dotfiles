{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.bloom;
    colorScheme = "custom";
    customColorScheme = {
      text               = "dad4bb";
      subtext            = "999482";
      main               = "1e1e2e";
      sidebar            = "181825";
      player             = "1e1e2e";
      card               = "2a2a3e";
      shadow             = "11111b";
      selected-row       = "d3cba8";
      button             = "cd664d";
      button-active      = "b25540";
      button-disabled    = "585470";
      tab-active         = "cd664d";
      notification       = "cd664d";
      notification-error = "cd664d";
      misc               = "cac4ad";
      highlight-elevated = "d3cba8";
    };
  };
}
