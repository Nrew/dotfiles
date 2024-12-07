{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
      "--color=fg:7,bg:-1,hl:4"
      "--color=fg+:15,bg+:-1,hl+:4"
      "--color=info:2,prompt:1,pointer:5"
      "--color=marker:6,spinner:3,header:8"
    ];

    # Custom keybindings
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'exa --tree {} | head -200'"
    ];
    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];
  };

  # Create pywal template for fzf colors
  home.file.".config/wal/templates/colors-fzf.sh".text = ''
    # FZF color scheme using pywal colors
    export FZF_DEFAULT_OPTS="
      --color=bg:-1,bg+:-1
      --color=fg:{foreground},fg+:{color15}
      --color=hl:{color4},hl+:{color4}
      --color=info:{color2},prompt:{color1}
      --color=pointer:{color5},marker:{color6}
      --color=spinner:{color3},header:{color8}
      $FZF_DEFAULT_OPTS
    "
  '';

  # Source FZF colors in shell
  programs.zsh.initExtra = ''
    # Source FZF colors from pywal
    if [ -f ~/.cache/wal/colors-fzf.sh ]; then
      source ~/.cache/wal/colors-fzf.sh
    fi
  '';
}