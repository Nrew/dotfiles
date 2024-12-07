# modules/rice/spicetify.nix
{ config, lib, pkgs, ... }:

let
  spicePkgs = pkgs.spicetify-cli.override {
    spotify-unwrapped = pkgs.spotify;
  };
in
{
  # Install spicetify and spotify
  home.packages = with pkgs; [
    spotify
    spicePkgs
  ];

  # Spicetify configuration
  home.file.".config/spicetify/config-xpui.ini".text = ''
    [Setting]
    spotify_path            = ${pkgs.spotify}/share/spotify
    prefs_path             = ${config.home.homeDirectory}/Library/Application Support/Spotify/prefs
    current_theme          = pywal
    color_scheme          = pywal
    inject_css            = 1
    replace_colors        = 1
    overwrite_assets      = 0
    spotify_launch_flags  = 
    check_spicetify_upgrade = 0

    [Preprocesses]
    disable_sentry        = 1
    disable_ui_logging    = 1
    remove_rtl_rule      = 1
    expose_apis          = 1

    [AdditionalOptions]
    extensions           = 
    custom_apps         = 
    sidebar_config      = 1
    home_config        = 1

    [Patch]

    [Enhancement]
    minimal_ui          = 0
    remove_connect_bar = 0
    
    ; DO NOT CHANGE!
    [Backup]
    version = 
    with    = 2.24.2
  '';

  # Create pywal theme for spicetify
  home.file.".config/spicetify/Themes/pywal/color.ini".text = ''
    [pywal]
    text               = {foreground}
    subtext           = {color7}
    sidebar-text      = {foreground}
    main              = {background}
    sidebar          = {background}
    player           = {background}
    card             = {color0}
    shadow           = {color0}
    selected-row     = {color4}
    button           = {color4}
    button-active    = {color6}
    button-disabled  = {color8}
    tab-active       = {color4}
    notification     = {color3}
    notification-error = {color1}
    misc             = {color2}
  '';

  # Create custom CSS for spicetify
  home.file.".config/spicetify/Themes/pywal/user.css".text = ''
    :root {
      --spice-text: var(--spice-main-fg);
      --spice-subtext: var(--spice-sidebar-text);
      --spice-main: var(--spice-main-bg);
      --spice-sidebar: var(--spice-sidebar-bg);
      --spice-player: var(--spice-player-bg);
      --spice-card: var(--spice-card-bg);
      --spice-shadow: var(--spice-shadow-bg);
      --spice-selected-row: var(--spice-selected-row-bg);
      --spice-button: var(--spice-button-bg);
      --spice-button-active: var(--spice-button-active-bg);
      --spice-button-disabled: var(--spice-button-disabled-bg);
      --spice-tab-active: var(--spice-tab-active-bg);
      --spice-notification: var(--spice-notification-bg);
      --spice-notification-error: var(--spice-notification-error-bg);
      --spice-misc: var(--spice-misc-bg);
    }

    /* Custom scrollbar */
    ::-webkit-scrollbar {
      width: 8px;
    }

    ::-webkit-scrollbar-track {
      background-color: transparent;
    }

    ::-webkit-scrollbar-thumb {
      background-color: var(--spice-button);
      border-radius: 4px;
    }

    /* Main player modifications */
    .main-nowPlayingWidget-nowPlaying {
      background-color: var(--spice-card);
      border-radius: 8px;
      padding: 8px;
    }

    .main-topBar-background {
      background-color: var(--spice-main) !important;
    }

    /* Card modifications */
    .main-card-card {
      background-color: var(--spice-card);
      border-radius: 8px;
    }

    .main-card-card:hover {
      background-color: var(--spice-shadow);
    }

    /* Playlist modifications */
    .main-rootlist-rootlistItem {
      padding: 0 8px;
    }

    .main-rootlist-rootlistItem:hover {
      background-color: var(--spice-shadow);
    }

    /* Button modifications */
    .main-playButton-PlayButton {
      background-color: var(--spice-button);
    }

    .main-playButton-PlayButton:hover {
      background-color: var(--spice-button-active);
      transform: scale(1.04);
    }
  '';

  # Add script to apply spicetify theme
  home.packages = with pkgs; [
    (writeShellScriptBin "spicetify-apply" ''
      #!/usr/bin/env bash
      # Apply spicetify theme
      spicetify backup apply
      spicetify update
    '')
  ];

  # Add to pywal post script to update Spotify theme
  home.file.".config/wal/templates/colors-spicetify.ini".text = ''
    [Base]
    main_fg                               = {foreground}
    secondary_fg                          = {color7}
    main_bg                              = {background}
    sidebar_and_player_bg                = {background}
    cover_overlay_and_shadow             = {color0}
    indicator_fg_and_button_bg           = {color4}
    pressing_fg                          = {color6}
    slider_bg                            = {color8}
    sidebar_indicator_and_hover_button_bg = {color4}
    scrollbar_fg_and_selected_row_bg     = {color4}
    pressing_button_fg                   = {color6}
    pressing_button_bg                   = {color8}
    selected_button                      = {color4}
    miscellaneous_bg                     = {color2}
    miscellaneous_hover_bg               = {color3}
    preserve_1                           = {color1}
  '';
}