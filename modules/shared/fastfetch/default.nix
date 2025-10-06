{ config, lib, pkgs, self, palette, ... }:
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
          keys  = palette.primary;
          title = palette.secondary;
        };
      };

      modules = [
        # ───────────────────────────────────────────────────────────────────────────────
        # システム識別 (System Identity)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "title";
          format = "${palette.error}{1}${palette.text}サン @ ${palette.secondary}{2}${palette.text}";
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
          color = palette.primary;
        }
        # ───────────────────────────────────────────────────────────────────────────────
        # システム情報 (System Information)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "os";
          key = "󰒋 オペレーティングシステム";
          keyColor = palette.error;
          format = "{2} {9}";
        }
        {
          type = "kernel";
          key = "❯ カーネル";
          keyColor = palette.info;   
          format = "{1} {2}";
        }
        {
          type = "host";
          key = " ホスト";
          keyColor = palette.secondary;
          format = "{1}";
        }
        {
          type = "uptime";
          key = " アップタイム";
          keyColor = palette.secondary;
          format = "{?1}{1} 日{?} {?2}{2} 時間{?} {?3}{3} 分{?}";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
          color = palette.muted;
        }

        # ───────────────────────────────────────────────────────────────────────────────
        # 環境・リソース (Environment & Resources)
        # ───────────────────────────────────────────────────────────────────────────────

        {
          type = "packages";
          key = " パッケージ";
          keyColor = palette.warning;
          format = "{} (nix)";
        }
        {
          type = "shell";
          key = " シェル";
          keyColor = palette.primary;
        }
        {
          type = "memory";
          key = "メモリ";
          keyColor = palette.error;
          format = "{1} / {2} ({3})";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
          color = palette.muted;
        }

        # ═══════════════════════════════════════════════════════════════
        # 表示環境 (Display Environment)
        # ═══════════════════════════════════════════════════════════════

        {
          type = "display";
          key = "ディスプレイ";
          keyColor = palette.secondary;
          format = "{1}x{2}@{5}Hz";
        }
        {
          type = "de";
          key = "デスクトップ環境";
          keyColor = palette.secondary;
        }
        {
          type = "wm";
          key = "ウィンドウマネージャ";
          keyColor = palette.warning;
        }
        {
          type = "terminal";
          key = " ターミナル";
          keyColor = palette.info;
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
          color = palette.primary;
        }
        # ═══════════════════════════════════════════════════════════════
        # システム状態 (System Status)
        # ═══════════════════════════════════════════════════════════════
        {
          type = "text";
          text = "${palette.muted}╔══ ${palette.info}システム状態${palette.muted}: ${palette.error}動作中 ${palette.muted}═══ ${palette.secondary}AI ノード${palette.muted}: ${palette.warning}アクティブ ${palette.muted}══╗";
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
      ];
    };
  };
}