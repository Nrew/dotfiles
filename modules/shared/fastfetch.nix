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
          "format": "{1}サン @ {2}"
        },
        {
          "type": "separator",
          "string": "──────────────────────────────────"
        },
        {
          "type": "os",
          "key": "オペレーティングシステム",
          "format": "{2} {9}"
        },
        {
          "type": "host",
          "key": "ホスト",
          "format": "{1}"
        },
        {
          "type": "kernel",
          "key": "カーネル",
          "format": "{1} {2}"
        },
        {
          "type": "uptime",
          "key": "アップタイム",
          "format": "{?1}{1} 日{?} {?2}{2} 時間{?} {?3}{3} 分{?}"
        },
        {
          "type": "packages",
          "key": "パッケージ",
          "format": "{1}"
        },
        {
          "type": "shell",
          "key": "シェル"
        },
        {
          "type": "separator",
          "string": "──────────────────────────────────"
        },
        {
          "type": "cpu",
          "key": "ＣＰＵ",
          "format": "{1}"
        },
        {
          "type": "gpu",
          "key": "ＧＰＵ",
          "format": "{1}"
        },
        {
          "type": "memory",
          "key": "メモリ",
          "format": "{1} / {2} ({3})"
        },
        {
          "type": "battery",
          "key": "バッテリー",
          "format": "{1}% [{3}]"
        },
        {
          "type": "separator",
          "string": "──────────────────────────────────"
        },
        {
          "type": "display",
          "key": "ディスプレイ",
          "format": "{1}x{2}@{5}Hz"
        },
        {
          "type": "de",
          "key": "デスクトップ環境"
        },
        {
          "type": "wm",
          "key": "ウィンドウマネージャ"
        },
        {
          "type": "terminal",
          "key": "ターミナル"
        },
        {
          "type": "separator",
          "string": "──────────────────────────────────"
        },
        {
          "type": "locale",
          "key": "ロケール"
        },
        {
          "type": "theme",
          "key": "テーマ"
        },
        {
          "type": "icons",
          "key": "アイコン"
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
        "keyWidth": 15,
        "percentType": "hiding"
      },
      
      "logo": {
        "type": "file",
        "source": "~/.config/fastfetch/tuchany.png",
        "width": 35,
        "height": 35,
        "padding": {
          "top": 1,
          "left": 2,
          "right": 3
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

  # Create XDG directory for tuchany image
  home.activation.setupTuchanyImage = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.config/fastfetch
    # You should place your tuchany.png image at ~/.config/fastfetch/tuchany.png
    if [ ! -f ~/.config/fastfetch/tuchany.png ]; then
      echo "Please copy your tuchany.png image to ~/.config/fastfetch/tuchany.png" > ~/.config/fastfetch/README_TUCHANY.txt
    fi
  '';
}
