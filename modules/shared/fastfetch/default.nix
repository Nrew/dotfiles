{ config, pkgs, self, ... }:
{
  home.file.".config/fastfetch/logo/tvchany.png" = {
    source = "${self}/images/tvchany.png";
    recursive = true;
  };

  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        type = "kitty-icat";
        source = "${config.xdg.configHome}/fastfetch/logo/tvchany.png";
        padding.top = 1;
      };

      display = {
        separator = "  ";
        key.width = 24;
        color = {
          keys = "38;2;153;148;130";
          output = "38;2;202;196;173";
        };
      };

      modules = [
        {
          type = "title";
          format = "[ {1}@{2} ]";
          color = {
            user = "38;2;205;102;77";
            at = "38;2;88;84;112";
            host = "38;2;205;102;77";
          };
        }
        {
          type = "separator";
          string = "─────────────────────────────────────────";
        }
        {
          type = "os";
          key = "󰒋 オペレーティングシステム";
          format = "{2} {9}";
        }
        {
          type = "host";
          key = " ホスト";
          format = "{1}";
        }
        {
          type = "kernel";
          key = "❯ カーネル";
          format = "{1} {2}";
        }
        {
          type = "uptime";
          key = " アップタイム";
          format = "{?1}{1}日{?} {?2}{2}時間{?} {?3}{3}分{?}";
        }
        {
          type = "separator";
          string = "─────────────────────────────────────────";
        }
        {
          type = "shell";
          key = " シェル";
        }
        {
          type = "terminal";
          key = " ターミナル";
        }
        {
          type = "memory";
          key = " メモリ";
          format = "{1} / {2} ({3})";
        }
        {
          type = "separator";
          string = "─────────────────────────────────────────";
        }
        {
          type = "break";
        }
        {
          type = "colors";
          paddingLeft = 2;
          block = {
            width = 2;
            height = 1;
          };
        }
        {
          type = "separator";
          string = "栄光を人類に";
        }
      ];
    };
  };
}
