{ config, lib, pkgs, ... }:

let
  theme = import ./theme/default.nix { inherit lib; };
  colors = theme.theme;
in
{
  home.packages = [ pkgs.fastfetch ];

  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      
      "modules": [
        {
          "type": "title",
          "format": "{1}@{2}"
        },
        {
          "type": "separator",
          "string": "─────────────────────────────────"
        },
        {
          "type": "os",
          "key": "OS",
          "format": "{2} {9}"
        },
        {
          "type": "host",
          "key": "Host",
          "format": "{1}"
        },
        {
          "type": "kernel",
          "key": "Kernel",
          "format": "{1} {2}"
        },
        {
          "type": "uptime",
          "key": "Uptime",
          "format": "{?1}{1} days{?} {?2}{2} hours{?} {?3}{3} min{?}"
        },
        {
          "type": "packages",
          "key": "Packages",
          "format": "{1}"
        },
        {
          "type": "shell",
          "key": "Shell"
        },
        {
          "type": "separator",
          "string": "─────────────────────────────────"
        },
        {
          "type": "cpu",
          "key": "CPU",
          "format": "{1}"
        },
        {
          "type": "gpu",
          "key": "GPU",
          "format": "{1}"
        },
        {
          "type": "memory",
          "key": "Memory",
          "format": "{1} / {2} ({3})"
        },
        {
          "type": "battery",
          "key": "Battery",
          "format": "{1}% [{3}]"
        },
        {
          "type": "separator",
          "string": "─────────────────────────────────"
        },
        {
          "type": "display",
          "key": "Display",
          "format": "{1}x{2}@{5}Hz"
        },
        {
          "type": "de",
          "key": "DE"
        },
        {
          "type": "wm",
          "key": "WM"
        },
        {
          "type": "terminal",
          "key": "Terminal"
        },
        {
          "type": "separator",
          "string": "─────────────────────────────────"
        },
        {
          "type": "locale",
          "key": "Locale"
        },
        {
          "type": "theme",
          "key": "Theme"
        },
        {
          "type": "icons",
          "key": "Icons"
        },
        {
          "type": "break"
        },
        {
          "type": "colors",
          "block": {
            "width": 2,
            "height": 1,
            "paddingLeft": 1
          }
        }
      ],
      
      "display": {
        "separator": " ",
        "keyWidth": 10,
        "percentType": "hiding"
      },
      
      "logo": {
        "type": "builtin",
        "source": "apple",
        "width": 30,
        "height": 30,
        "padding": {
          "top": 1,
          "left": 2,
          "right": 3
        },
        "color": {
          "1": "${colors.base}",
          "2": "${colors.pine}"
        }
      }
    }
  '';

  # Add shell aliases
  programs.zsh.shellAliases = {
    scan = "fastfetch";
    neofetch = "fastfetch";
    info = "fastfetch";
  };
}
