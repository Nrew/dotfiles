{ config, pkgs, lib, ... }:

let
  theme = import ../theme/default.nix { inherit lib; };
  colors = theme.theme;
  alpha20 = colors.alpha."20";
in

{
  # Install Raycast
  home.packages = with pkgs; [
    raycast
  ];

  # Raycast settings
  home.file.".config/raycast/settings.json".text = ''
    {
      "appearance": {
        "theme": "custom",
        "colors": {
          "backgroundColor": "${colors.base}",
          "secondaryBackgroundColor": "${colors.surface}",
          "textColor": "${colors.text}",
          "secondaryTextColor": "${colors.subtle}",
          "accentColor": "${colors.iris}",
          "separatorColor": "${colors.overlay}",
          "selectedItemColor": "${colors.pine}${alpha20}",
          "titleColor": "${colors.text}",
          "subtitleColor": "${colors.subtle}",
          "iconColor": "${colors.iris}",
          "primaryIconColor": "${colors.iris}",
          "backgroundOpacity": 98
        },
        "borderRadius": 8,
        "animationSpeed": "default"
      },
      "general": {
        "hotkey": {
          "key": "space",
          "modifiers": ["command"]
        },
        "showMenuBarIcon": true,
        "openAtLogin": true,
        "closeWindowAfterAction": true,
        "defaultSearchChoice": "raycast"
      },
      "search": {
        "categoryOrder": [
          "applications",
          "clipboard",
          "files",
          "calculator",
          "commands"
        ],
        "showRecentApplications": true,
        "showRecentFiles": true,
        "maxRecentItems": 10
      },
      "shortcuts": {
        "clipboard": {
          "key": "c",
          "modifiers": ["cmd", "shift"]
        },
        "snippets": {
          "key": "s",
          "modifiers": ["cmd", "shift"]
        },
        "window": {
          "key": "w",
          "modifiers": ["cmd", "shift"]
        }
      },
      "extensions": {
        "autoUpdate": true,
        "disabledExtensions": ["spotlight"]
      },
      "ai": {
        "enabled": true,
        "provider": "anthropic",
        "model": "claude-3-sonnet"
      }
    }
  '';

  # Custom Raycast theme
  home.file.".config/raycast/themes/rose-pine.json".text = ''
    {
      "name": "Rose Pine",
      "appearance": "dark",
      "author": "Nrew",
      "description": "Rose Pine inspired theme for Raycast",
      "colors": {
        "background": "${colors.base}",
        "backgroundSecondary": "${colors.surface}",
        "backgroundSecondarySelected": "${colors.overlay}",
        "backgroundSelected": "${colors.pine}${alpha20}",
        "backgroundTertiary": "${colors.overlay}",
        "border": "${colors.muted}",
        "borderLight": "${colors.overlay}",
        "borderSelected": "${colors.iris}",
        "heading": "${colors.text}",
        "link": "${colors.pine}",
        "placeholder": "${colors.subtle}",
        "subtitle": "${colors.subtle}",
        "tag": {
          "blue": "${colors.pine}",
          "green": "${colors.foam}",
          "orange": "${colors.gold}",
          "pink": "${colors.rose}",
          "purple": "${colors.iris}",
          "red": "${colors.love}",
          "yellow": "${colors.gold}"
        },
        "text": "${colors.text}",
        "textMuted": "${colors.subtle}",
        "textSecondary": "${colors.subtle}",
        "tint": "${colors.iris}",
        "transparent": "transparent"
      }
    }
  '';

  # Raycast snippets for Japanese/NieR-style text
  home.file.".config/raycast/snippets/nier.json".text = ''
    {
      "name": "NieR Snippets",
      "snippets": [
        {
          "name": "ヨルハ部隊",
          "keyword": "yorha",
          "text": "《ヨルハ自動歩兵部隊》"
        },
        {
          "name": "2B",
          "keyword": "2b",
          "text": "『ヨルハ二号Ｂ型』"
        },
        {
          "name": "9S",
          "keyword": "9s",
          "text": "【ヨルハ九号Ｓ型】"
        },
        {
          "name": "A2",
          "keyword": "a2",
          "text": "［ヨルハＡ二号］"
        },
        {
          "name": "機体認証",
          "keyword": "auth",
          "text": "『機体認証完了。ミッション開始。』"
        },
        {
          "name": "日本語セクション",
          "keyword": "section",
          "text": "【━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━】"
        }
      ]
    }
  '';

  # Disable Spotlight via defaults - Raycast will handle search
  home.activation.disableSpotlight = lib.hm.dag.entryAfter ["writeBoundary"] ''
    defaults write com.apple.spotlight orderedItems -array \
      '{"enabled" = 0;"name" = "APPLICATIONS";}' \
      '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
      '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
      '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
      '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
      '{"enabled" = 0;"name" = "SYSTEM_PREFS";}' \
      '{"enabled" = 0;"name" = "DOCUMENTS";}' \
      '{"enabled" = 0;"name" = "DIRECTORIES";}' \
      '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
      '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
      '{"enabled" = 0;"name" = "PDF";}' \
      '{"enabled" = 0;"name" = "MESSAGES";}' \
      '{"enabled" = 0;"name" = "CONTACT";}' \
      '{"enabled" = 0;"name" = "EVENT_TODO";}' \
      '{"enabled" = 0;"name" = "IMAGES";}' \
      '{"enabled" = 0;"name" = "BOOKMARKS";}' \
      '{"enabled" = 0;"name" = "MUSIC";}' \
      '{"enabled" = 0;"name" = "MOVIES";}' \
      '{"enabled" = 0;"name" = "FONTS";}' \
      '{"enabled" = 0;"name" = "MENU_OTHER";}' \
      '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}'
  '';
}
