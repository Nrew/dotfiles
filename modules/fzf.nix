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
}