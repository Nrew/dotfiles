{ config, pkgs, lib, ... }:

{
  programs.btop = {
    enable = true;
    
    # Enable Catppuccin theme
    catppuccin.enable = true;
    
    settings = {
      theme_background = false;
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_tree = true;
      rounded_corners = true;
      shown_boxes = "cpu mem net proc";
      vim_keys = true;
    };
  };
}
