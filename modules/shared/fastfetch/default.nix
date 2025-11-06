{ config, lib, pkgs, self, ... }:
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
      };

      modules = [
        # ───────────────────────────────────────────────────────────────────────────────
        # システム識別 (System Identity)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "title";
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
        }
        # ───────────────────────────────────────────────────────────────────────────────
        # システム情報 (System Information)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "os";
          key = "󰒋 オペレーティングシステム";
          format = "{2} {9}";
        }
        {
          type = "kernel";
          key = "❯ カーネル";
          format = "{1} {2}";
        }
        {
          type = "host";
          key = " ホスト";
          format = "{1}";
        }
        {
          type = "uptime";
          key = " アップタイム";
          format = "{?1}{1} 日{?} {?2}{2} 時間{?} {?3}{3} 分{?}";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
        }

        # ───────────────────────────────────────────────────────────────────────────────
        # 環境・リソース (Environment & Resources)
        # ───────────────────────────────────────────────────────────────────────────────

        {
          type = "packages";
          key = " パッケージ";
          format = "{} (nix)";
        }
        {
          type = "shell";
          key = " シェル";
        }
        {
          type = "memory";
          key = "メモリ";
          format = "{1} / {2} ({3})";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
        }

        # ═══════════════════════════════════════════════════════════════
        # 表示環境 (Display Environment)
        # ═══════════════════════════════════════════════════════════════

        {
          type = "display";
          key = "ディスプレイ";
          format = "{1}x{2}@{5}Hz";
        }
        {
          type = "de";
          key = "デスクトップ環境";
        }
        {
          type = "wm";
          key = "ウィンドウマネージャ";
        }
        {
          type = "terminal";
          key = " ターミナル";
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
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