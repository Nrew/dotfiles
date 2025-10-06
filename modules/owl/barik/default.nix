{ config, lib, pkgs, inputs, palette, ... }:

{
  # Barik status bar configuration
  home.packages = [ inputs.barik.packages.${pkgs.system}.default ];
  
  # Barik configuration file with aerospace integration
  home.file.".config/barik/barik.toml".text = ''
    # Barik Configuration
    # Theme colors from centralized palette
    [appearance]
    background = "${palette.surface}"
    foreground = "${palette.text}"
    accent = "${palette.primary}"
    
    [bar]
    height = 32
    padding = 8
    position = "top"
    
    # Aerospace workspace integration
    [[modules]]
    type = "aerospace"
    format = " {workspace} "
    
    # Additional modules can be configured here
    [[modules]]
    type = "clock"
    format = " %H:%M "
    
    [[modules]]
    type = "battery"
    format = " {percentage}% "
  '';
  
  # Aerospace integration script for barik
  home.file.".config/barik/aerospace-integration.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Aerospace workspace change handler for barik
      # This script is called by aerospace when workspace changes
      
      FOCUSED_WORKSPACE="''${AEROSPACE_FOCUSED_WORKSPACE}"
      PREV_WORKSPACE="''${AEROSPACE_PREV_WORKSPACE}"
      
      # Signal barik to update (if barik supports signals/IPC)
      # The exact implementation depends on barik's IPC mechanism
      if command -v barik &> /dev/null; then
        # Update barik display
        pkill -SIGUSR1 barik 2>/dev/null || true
      fi
    '';
    executable = true;
  };
}
