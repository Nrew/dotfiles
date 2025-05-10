{ config, lib, pkgs, ... }:

let 
  inherit (config.colorscheme) colors;

  variantIcons = [
   "「ヨルハ」"
   "『ヨルハ』" 
   "【ヨルハ】"
   "［ヨルハ］"
   "〈ヨルハ〉"
   "《ヨルハ》"
 ];

in
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
        "separator": "→",
        "keyWidth": 15,
        "percentType": "bar"
      },
      
      "logo": {
        "type": "image",
        "source": "~/.config/fastfetch/waifu.png",
        "width": 35,
        "height": 35,
        "padding": {
          "left": 2,
          "right": 3
        }
      },
      
      "title": {
        "format": "{1}サン @ {2}",
        "key": "システム",
        "keyColor": "${colors.base0D}"
      },
      
      "separator": {
        "string": "──────",
        "color": "${colors.base0D}"
      },

      "battery": {
       "key": "バッテリー状態",
       "format": "【{1}%】"
     },
      
      "colors": {
        "keys": "${colors.base0D}",
        "title": "${colors.base0D}",
        "separator": "${colors.base0D}",
        "text": "${colors.base05}"
      }
    }
  '';

  # Create XDG directory and download image if it doesn't exist
  home.activation.fetchWaifu = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.config/fastfetch
    if [ ! -f ~/.config/fastfetch/waifu.png ]; then
      curl -L "https://raw.githubusercontent.com/fastfetch-cli/fastfetch/dev/data/logos/small/arch.png" -o ~/.config/fastfetch/waifu.png
    fi
  '';

  # Add shell alias
  programs.zsh.shellAliases = {
    fetch = "fastfetch";
    scan = "fastfetch";
    "pod-scan" = "fastfetch";
  };
}