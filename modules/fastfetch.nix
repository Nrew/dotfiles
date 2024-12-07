# modules/cli/fastfetch.nix
{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "memory",
        "cpu",
        "gpu",
        "battery",
        "locale",
        "break",
        "colors"
      ],
      
      "display": {
        "separator": "→"
      },
      
      "logo": {
        "type": "small",
        "padding": {
          "left": 2,
          "right": 1
        }
      },
      
      "title": {
        "format": "{1}@{2}",
        "key": "╭─"
      },
      
      "separator": {
        "string": "─"
      },
      
      "colors": {
        "keys": "bright-blue",
        "title": "bright-blue"
      }
    }
  '';

  # Add shell alias
  programs.zsh.shellAliases = {
    fetch = "fastfetch";
  };
}