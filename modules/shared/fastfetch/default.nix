{ config, lib, pkgs, self, ... }:

let
  theme = import ./theme/default.nix { inherit lib; };
  colors = theme.theme;
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
      logo = {
        type = "kitty-icat";
        source = "${config.home.homeDirectory}/.config/fastfetch/logo/tvchany.png";
        padding = {
          top = 1;
        };
      };

      display = {
        separator = "  ";
        key.width = 16;
        color.keys = colors.iris;
      };

      modules = [
        # ───────────────────────────────────────────────────────────────────────────────
        # システム識別 (System Identity)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "title";
          format = "${colors.love}{1}${colors.text}サン @ ${colors.iris}{2}${colors.text}";
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
          color = colors.pine;
        }
        # ───────────────────────────────────────────────────────────────────────────────
        # システム情報 (System Information)
        # ───────────────────────────────────────────────────────────────────────────────
        {
          type = "os";
          key = "󰒋 オペレーティングシステム";
          keyColor = colors.love;
          format = "{2} {9}";
        }
        {
          type = "kernel";
          key = "❯ カーネル";
          keyColor = colors.foam;
          format = "{1} {2}";
        }
        {
          type = "host";
          key = " ホスト";
          keyColor = colors.rose;
          format = "{1}";
        }
        {
          type = "uptime";
          key = " アップタイム";
          keyColor = colors.iris;
          format = "{?1}{1} 日{?} {?2}{2} 時間{?} {?3}{3} 分{?}";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
          color = colors.subtle;
        }
        
        # ───────────────────────────────────────────────────────────────────────────────
        # 環境・リソース (Environment & Resources)
        # ───────────────────────────────────────────────────────────────────────────────

        {
          type = "packages";
          key = " パッケージ";
          keyColor = colors.gold;
          format = "{} (nix)";
        }
        {
          type = "shell";
          key = " シェル";
          keyColor = colors.pine;
        }
        {
          type = "memory";
          key = "メモリ";
          keyColor = colors.love;
          format = "{1} / {2} ({3})";
        }
        {
          type = "separator";
          string = " ≫━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━≪";
          color = colors.subtle;
        }

        # ═══════════════════════════════════════════════════════════════
        # 表示環境 (Display Environment)
        # ═══════════════════════════════════════════════════════════════

        {
          type = "display";
          key = "ディスプレイ";
          keyColor = colors.iris;
          format = "{1}x{2}@{5}Hz";
        }
        {
          type = "de";
          key = "デスクトップ環境";
          keyColor = colors.iris; 
        }
        {
          type = "wm";
          key = "ウィンドウマネージャ";
          keyColor = colors.gold;
        }
        {
          type = "terminal";
          key = " ターミナル";
          keyColor = colors.foam;
        }
        {
          type = "separator";
          string = "▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼▲▼";
          color = colors.pine;
        }
        # ═══════════════════════════════════════════════════════════════
        # システム状態 (System Status)
        # ═══════════════════════════════════════════════════════════════
        {
          type = "text";
          text = "${colors.subtle}╔══ ${colors.foam}システム状態${colors.subtle}: ${colors.love}動作中 ${colors.subtle}═══ ${colors.iris}AI ノード${colors.subtle}: ${colors.gold}アクティブ ${colors.subtle}══╗";
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
