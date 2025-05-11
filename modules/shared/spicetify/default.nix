{ config, pkgs, lib, ... }:

let
  spicetifyPkgs = pkgs.spicetify-cli.overrideAttrs(old: rec {
      src = pkgs.fetchFromGitHub {
        owner  = "khanhas";
        repo   = "spicetify-cli";
        rev    = "2.27.1";
        hash   = "sha256-lU80OASlsrOr3xRXrIgJNI7gP9xXQZI86mOWLgXZBGA=";
      };
  });

  theme = import ../theme/default.nix { inherit lib; };
  colors = theme.theme;
in

{
  # Install spicetify-cli
  home.packages = [ spicetifyPkgs ];

  # Spicetify configuration
  home.file.".config/spicetify/config-xpui.ini".text = ''
    [Setting]
    spotify_path                = ${pkgs.spotify}/Applications/Spotify.app
    prefs_path                  = ${config.home.homeDirectory}/Library/Application Support/Spotify/prefs
    current_theme               = RosePine
    color_scheme                = dark
    inject_css                  = 1
    inject_theme_js             = 1
    replace_colors              = 1
    overwrite_assets            = 0
    spotify_launch_flags        = 
    check_spicetify_upgrade     = 0
    version                     = 2.27.1

    ; DO NOT CHANGE!
    [Preprocesses]
    
    [AdditionalOptions]
    extensions                  = shuffle+.js|playlistIcons.js
    custom_apps                 = 
    disable_upgrade_check       = 1
    custom_code                 = 
  '';

  # Custom Rose Pine theme
  home.file.".config/spicetify/Themes/RosePine/theme.js".text = ''
// Rose Pine Theme for Spicetify
(function rosePine() {
  if (!Spicetify || !Spicetify.Platform) {
    setTimeout(rosePine, 100);
    return;
  }

  // Custom styling
  Spicetify.injectCSS(`
    .Root__main-view {
      background-color: ${colors.base};
    }
    
    /* Custom scrollbar */
    ::-webkit-scrollbar {
      width: 8px;
    }
    
    ::-webkit-scrollbar-track {
      background: ${colors.surface};
    }
    
    ::-webkit-scrollbar-thumb {
      background: ${colors.overlay};
      border-radius: 4px;
    }
    
    ::-webkit-scrollbar-thumb:hover {
      background: ${colors.muted};
    }
    
    /* Play button styling */
    .control-button-wrapper .progress-bar {
      height: 4px;
    }
    
    /* Card hover effects */
    .main-card-card {
      transition: all 0.3s ease;
    }
    
    .main-card-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }
    
    /* Glass effect for main view */
    .Root__main-view {
      backdrop-filter: blur(10px);
    }
  `);
})();
  '';

  # Rose Pine color scheme
  home.file.".config/spicetify/Themes/RosePine/color.ini".text = ''
[dark]
main               = ${colors.base}
sidebar            = ${colors.surface}
player             = ${colors.base}
subtext            = ${colors.subtle}
navbar             = ${colors.surface}
main-secondary     = ${colors.surface}
sidebar-secondary  = ${colors.overlay}
player-secondary   = ${colors.surface}
main-elevated      = ${colors.overlay}
highlight-elevated = ${colors.foam}
highlight          = ${colors.pine}
accent             = ${colors.iris}
accent-secondary   = ${colors.rose}
text               = ${colors.text}
selected-row       = ${colors.overlay}
button             = ${colors.iris}
button-secondary   = ${colors.surface}
button-disabled    = ${colors.muted}
warning            = ${colors.gold}
error              = ${colors.love}
success            = ${colors.foam}
playlist           = ${colors.pine}
card               = ${colors.surface}
  '';

  # Install script
  home.file.".config/spicetify/install.sh".text = ''
    #!/bin/bash
    
    # Apply spicetify theme
    spicetify backup apply
    
    # Enable theme
    spicetify config current_theme RosePine
    spicetify config color_scheme dark
    
    # Install extensions
    spicetify config extensions shuffle+.js playlistIcons.js
    
    # Apply changes
    spicetify apply
  '';

  # Make install script executable
  home.activation.makeSpicetifyExecutable = lib.hm.dag.entryAfter ["writeBoundary"] ''
    chmod +x ${config.home.homeDirectory}/.config/spicetify/install.sh
  '';
}
