{ config, lib, pkgs, inputs, palette, ... }:

{
  # Barik status bar configuration
  home.packages = [ inputs.barik.packages.${pkgs.system}.default ];
  
  # Barik configuration file
  home.file.".config/barik/barik.toml".text = ''
    # Barik Configuration
    # Theme colors from palette
    [appearance]
    background = "${palette.surface}"
    foreground = "${palette.text}"
    accent = "${palette.primary}"
    
    [bar]
    height = 32
    padding = 8
    
    [modules]
    # Configure modules here based on your needs
  '';
}
