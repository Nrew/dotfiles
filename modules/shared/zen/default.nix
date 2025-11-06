{ config, lib, pkgs, ... }:

let
  # Catppuccin Mocha colors for zen browser
  colors = {
    background = "#1e1e2e";  # Catppuccin Mocha base
    surface = "#313244";     # Catppuccin Mocha surface0
    overlay = "#45475a";     # Catppuccin Mocha surface2
    text = "#cdd6f4";        # Catppuccin Mocha text
    subtext = "#bac2de";     # Catppuccin Mocha subtext1
    muted = "#9399b2";       # Catppuccin Mocha overlay2
    primary = "#cba6f7";     # Catppuccin Mocha mauve
    secondary = "#f5c2e7";   # Catppuccin Mocha pink
    success = "#a6e3a1";     # Catppuccin Mocha green
    warning = "#f9e2af";     # Catppuccin Mocha yellow
    error = "#f38ba8";       # Catppuccin Mocha red
    info = "#89dceb";        # Catppuccin Mocha sky
    border = "#45475a";      # Catppuccin Mocha surface2
  };
in
{
  # Zen Browser configuration with Catppuccin theme
  # Theme files work cross-platform
  
  # Create userChrome.css for theme customization
  home.file.".zen/chrome/userChrome.css".text = ''
    /* Zen Browser Theme - Catppuccin Mocha */
    
    :root {
      /* Colors from Catppuccin Mocha palette */
      --zen-bg: ${colors.background};
      --zen-surface: ${colors.surface};
      --zen-overlay: ${colors.overlay};
      --zen-text: ${colors.text};
      --zen-subtext: ${colors.subtext};
      --zen-muted: ${colors.muted};
      --zen-primary: ${colors.primary};
      --zen-secondary: ${colors.secondary};
      --zen-success: ${colors.success};
      --zen-warning: ${colors.warning};
      --zen-error: ${colors.error};
      --zen-info: ${colors.info};
      --zen-border: ${colors.border};
      
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
  
  # Create user.js for preferences
  home.file.".zen/user.js".text = ''
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
}
