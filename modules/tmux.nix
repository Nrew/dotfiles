{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true; # Enable Tmux configuration

    # Add custom Tmux configuration
    extraConfig = ''
      set -g mouse on
      set -g history-limit 10000
      set -g status-bg #{shell ~/.cache/wal/colors.json jq -r .special.background}
      set -g status-fg #{shell ~/.cache/wal/colors.json jq -r .special.foreground}
    '';
  };
}
