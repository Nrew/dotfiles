{ config, lib, pkgs, palette, ... }:

{
  # Zen Browser configuration with centralized theme
  # Zen is installed via Homebrew cask on macOS
  
  # Create userChrome.css for theme customization
  home.file.".zen/chrome/userChrome.css" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
      /* Zen Browser Theme - Generated from centralized palette */
      
      :root {
        /* Colors from theme palette */
        --zen-bg: ${palette.background};
        --zen-surface: ${palette.surface};
        --zen-overlay: ${palette.overlay};
        --zen-text: ${palette.text};
        --zen-subtext: ${palette.subtext};
        --zen-muted: ${palette.muted};
        --zen-primary: ${palette.primary};
        --zen-secondary: ${palette.secondary};
        --zen-success: ${palette.success};
        --zen-warning: ${palette.warning};
        --zen-error: ${palette.error};
        --zen-info: ${palette.info};
        --zen-border: ${palette.border};
        
        /* Apply theme colors */
        --zen-colors-primary: var(--zen-primary) !important;
        --zen-colors-secondary: var(--zen-secondary) !important;
        --zen-colors-tertiary: var(--zen-overlay) !important;
        --toolbarbutton-icon-fill: var(--zen-text) !important;
        --lwt-text-color: var(--zen-text) !important;
        --toolbar-bgcolor: var(--zen-surface) !important;
        --lwt-accent-color: var(--zen-bg) !important;
        --urlbar-box-bgcolor: var(--zen-overlay) !important;
      }
      
      /* Smooth animations */
      * {
        transition: background-color 0.2s ease, color 0.2s ease, border-color 0.2s ease !important;
      }
      
      /* Custom tab styling */
      .tabbrowser-tab {
        background: var(--zen-surface) !important;
        border-radius: 8px !important;
        margin: 2px !important;
      }
      
      .tabbrowser-tab[selected] {
        background: var(--zen-primary) !important;
        color: var(--zen-bg) !important;
      }
      
      /* Sidebar styling */
      #sidebar-box {
        background: var(--zen-surface) !important;
        border-right: 1px solid var(--zen-border) !important;
      }
    '';
  };
  
  # Create user.js for preferences
  home.file.".zen/user.js" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
      // Zen Browser preferences
      // Enable userChrome.css
      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      
      // Performance optimizations
      user_pref("gfx.webrender.all", true);
      user_pref("layers.acceleration.force-enabled", true);
      
      // Smooth scrolling
      user_pref("general.smoothScroll", true);
      user_pref("general.smoothScroll.lines.durationMaxMS", 150);
      user_pref("general.smoothScroll.lines.durationMinMS", 150);
      user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
      user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
      user_pref("general.smoothScroll.pages.durationMaxMS", 150);
      user_pref("general.smoothScroll.pages.durationMinMS", 150);
      
      // Privacy enhancements
      user_pref("privacy.donottrackheader.enabled", true);
      user_pref("privacy.trackingprotection.enabled", true);
    '';
  };
}
