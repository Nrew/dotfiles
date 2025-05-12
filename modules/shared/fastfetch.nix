{ config, lib, pkgs, ... }:

let
  theme = import ./theme/default.nix { inherit lib; };
  colors = theme.catppuccin;
in
{
  #──────────────────────────────────────────────────────────────────
  # Fastfetch Logo Image Management
  #──────────────────────────────────────────────────────────────────

  home.file.".config/fastfetch/tvchany.jpg" = {
    source = ../../images/logo.jpg;
  };

  #──────────────────────────────────────────────────────────────────
  # Required Packages
  #──────────────────────────────────────────────────────────────────
  home.packages = [ pkgs.fastfetch ];


  #──────────────────────────────────────────────────────────────────
  # Fastfetch Program Configuration
  #──────────────────────────────────────────────────────────────────
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "kitty";
        source = "${config.home.homeDirectory}/.config/fastfetch/tvchany.jpg";
        width = 30;
        padding = {
          top = 1;
        };
      };

      display = {
        separator = "  ";
        keyWidth = 22;
        color.keys = colors.lavender;
      };

      modules = [
        {
          type = "title";
          format = "${colors.pink}{1}${colors.text}サン @ ${colors.mauve}{2}${colors.text}";
        }
        {
          type = "separator";
          string = "⋅ ⋅ ⋅ ⋅ ⋆˙⊹°.⋆˖°.⋆˙⊹°.⋆ ⋅ ⋅ ⋅ ⋅";
          color = colors.mauve;
        }
        {
          type = "os";
          key = "オペレーティングシステム";
          keyColor = colors.pink;
          format = "{2} {9}";
        }
        {
          type = "host";
          key = "ホスト (フクロウ)";
          keyColor = colors.flamingo;
          format = "{1}";
        }
                {
          type = "kernel";
          key = "カーネル";
          keyColor = colors.rosewater;
          format = "{1} {2}";
        }
        {
          type = "uptime";
          key = " アップタイム";
          keyColor = colors.mauve;
          format = "{?1}{1} 日{?} {?2}{2} 時間{?} {?3}{3} 分{?}";
        }
        {
          type = "packages";
          key = " パッケージ";
          keyColor = colors.pink;
          format = "{} (nix)";
        }
        {
          type = "shell";
          key = " シェル";
          keyColor = colors.flamingo;
        }
        {
          type = "separator";
          string = "⋅ ⋅ ⋅ ⋅ ⋆˙⊹°.⋆˖°.⋆˙⊹°.⋆ ⋅ ⋅ ⋅ ⋅";
          color = colors.mauve;
        }
        {
          type = "cpu";
          key = "ＣＰＵ";
          keyColor = colors.rosewater;
          format = "{1} ({5}%)";
        }
         {
          type = "gpu";
          key = "ＧＰＵ";
          keyColor = colors.mauve;
          format = "{1}";
        }
        {
          type = "memory";
          key = "メモリ";
          keyColor = colors.pink;
          format = "{1} / {2} ({3})";
        }
        {
          type = "battery";
          key = "バッテリー";
          keyColor = colors.flamingo;
          format = "{1}% [{3}]";
        }
        {
          type = "separator";
          string = "⋅ ⋅ ⋅ ⋅ ⋆˙⊹°.⋆˖°.⋆˙⊹°.⋆ ⋅ ⋅ ⋅ ⋅";
          color = colors.mauve;
        }
        {
          type = "display";
          key = "ディスプレイ";
          keyColor = colors.rosewater;
          format = "{1}x{2}@{5}Hz";
        }
        {
          type = "de";
          key = "デスクトップ環境";
          keyColor = colors.mauve; 
        }
        {
          type = "wm";
          key = "ウィンドウマネージャ";
          keyColor = colors.pink;
        }
        {
          type = "terminal";
          key = " ターミナル";
          keyColor = colors.flamingo;
        }
        {
          type = "separator";
          string = "⋅ ⋅ ⋅ ⋅ ⋆˙⊹°.⋆˖°.⋆˙⊹°.⋆ ⋅ ⋅ ⋅ ⋅";
          color = colors.mauve;
        }
        {
          type = "icons";
          key = "アイコン";
          keyColor = colors.pink;
        }
        {
          type = "break";
        }
        {
          type = "colors";
          keyColor = colors.flamingo;
          block = {
            width = 2;
            height = 1;
            paddingLeft = 1;
          };
        }
      ];
    };
  };

  #──────────────────────────────────────────────────────────────────
  # Shell Aliases
  #──────────────────────────────────────────────────────────────────
  programs.zsh.shellAliases = {
    scan = "fastfetch";
    neofetch = "fastfetch";
    info = "fastfetch";
  };
}
