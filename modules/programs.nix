{ pkgs, ... }:

{
    programs.kitty = {
        enable = true;
        font = {
        family = "JetBrainsMono Nerd Font";
        size = 14.0;
    };
    
    extraConfig = ''
        include ~/.cache/wal/colors-kitty.conf
        tab_bar_style powerline
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.tmux.enable = true;
}
