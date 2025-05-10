{ config, pkgs, lib, ...}

{
  programs.neovim = {
    enable = true;
    
    viAlias = true;
    vimAlias = true;
  };
}
