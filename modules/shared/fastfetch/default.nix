{ config, lib, pkgs, self, palette ? null, ... }:

let
  # Fallback palette if theme system is not enabled
  defaultPalette = {
    primary = "#857a71"; secondary = "#8f857a"; red = "#a67070"; error = "#a67070"; info = "#70a6a6";
  };
  
  colors = if palette != null then palette else defaultPalette;
in
{
  #──────────────────────────────────────────────────────────────────
  # Fastfetch Logo Image Management
  #──────────────────────────────────────────────────────────────────

  home.file.".config/fastfetch/logo/tvchany.png" = {
    source = "${self}/images/tvchany.png";
    recursive = true;
  };

  #──────────────────────────────────────────────────────────────────
  # Fastfetch Program Configuration
  #──────────────────────────────────────────────────────────────────
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
        key.width = 16;
        color = {
          keys  = colors.primary;
          title = colors.secondary;
        };
      };

      modules = [
        # ───────────────────────────────────────────────────────────────────────────────
        # システム識別 (System Identity)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "title";
          keyColor = colors.primary;
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
          color = colors.primary;
        }
        # ───────────────────────────────────────────────────────────────────────────────
        # システム情報 (System Information)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "os";
          key = "󰒋 オペレーティングシステム";
          keyColor = colors.error;
          format = "{2} {9}";
        }
        {
          type = "kernel";
          key = "❯ カーネル";
          keyColor = colors.info;   
          format = "{1} {2}";
        }
        {
          type = "host";
          key = " ホスト";
          keyColor = colors.secondary;
          format = "{1}";
        }
        {
          type = "uptime";
          key = " アップタイム";
          keyColor = colors.secondary;
          format = "{?1}{1} 日{?} {?2}{2} 時間{?} {?3}{3} 分{?}";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
          color = colors.muted;
        }

        # ───────────────────────────────────────────────────────────────────────────────
        # 環境・リソース (Environment & Resources)
        # ───────────────────────────────────────────────────────────────────────────────

        {
          type = "packages";
          key = " パッケージ";
          keyColor = colors.warning;
          format = "{} (nix)";
        }
        {
          type = "shell";
          key = " シェル";
          keyColor = colors.primary;
        }
        {
          type = "memory";
          key = "メモリ";
          keyColor = colors.error;
          format = "{1} / {2} ({3})";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
          color = colors.muted;
        }

        # ═══════════════════════════════════════════════════════════════
        # 表示環境 (Display Environment)
        # ═══════════════════════════════════════════════════════════════

        {
          type = "display";
          key = "ディスプレイ";
          keyColor = colors.secondary;
          format = "{1}x{2}@{5}Hz";
        }
        {
          type = "de";
          key = "デスクトップ環境";
          keyColor = colors.secondary;
        }
        {
          type = "wm";
          key = "ウィンドウマネージャ";
          keyColor = colors.warning;
        }
        {
          type = "terminal";
          key = " ターミナル";
          keyColor = colors.info;
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
          color = colors.primary;
        }
        # ═══════════════════════════════════════════════════════════════
        # システム状態 (System Status)
        # ═══════════════════════════════════════════════════════════════
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
      ];
    };
  };
}