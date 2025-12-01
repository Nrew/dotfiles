{ config, pkgs, user, ... }:

{
  # ───────────────────────────────────────────────────────────────────────────────
  # Shared Settings
  # ───────────────────────────────────────────────────────────────────────────────

  imports = [
    ../shared.nix
  ];

  # ───────────────────────────────────────────────────────────────────────────────
  # macOS-Specific Settings
  # ───────────────────────────────────────────────────────────────────────────────

  # Enable Nix-Homebrew configuration
  nix-homebrew = {
    enable = true;
    user = user;
    autoMigrate = true;
  };

  # User configuration
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # Enable TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # ───────────────────────────────────────────────────────────────────────────────
  # macOS System Settings
  # ───────────────────────────────────────────────────────────────────────────────
  # NOTE: Some options are not supported by nix-darwin directly. Manual configuration needed:
  #   1. To avoid conflicts with neovim, disable: System Settings → Keyboard → Shortcuts →
  #      Mission Control → Disable ctrl + up/down/left/right shortcuts

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    defaults = {
      ".GlobalPreferences" = { };
      LaunchServices = {
        LSQuarantine = false;
      };
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleICUForce24HourTime = true;
        KeyRepeat = 2;
      };
      trackpad.TrackpadThreeFingerDrag = true;
      finder = {
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      dock = {
        autohide = true;
        expose-animation-duration = 0.15;
        show-recents = false;
        showhidden = true;
        tilesize = 30;
      };
      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
      screencapture = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
    };
  };

  # ────────────────────────────────────────────────────────────────
  # macOS-Specific System-Level Packages
  # ────────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [ ];

  fonts = {
    packages = with pkgs; [
      source-code-pro
    ];
  };

  # ────────────────────────────────────────────────────────────────
  # Homebrew Configuration
  # ────────────────────────────────────────────────────────────────

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "lua"
      "spicetify-cli"
      "switchaudio-osx"
      "nowplaying-cli"
    ];
    casks = [
      "anki"
      "discord"
      "obsidian"
      "raycast"
      "visual-studio-code"
      "sf-symbols"
      "homebrew/cask-fonts/font-sf-mono"
      "homebrew/cask-fonts/font-sf-pro"
      "zen"
      "barik"
      "aerospace"
    ];
    taps = [
      "mocki-toki/formulae"
      "nikitabobko/tap"
      "felixkratz/formulae"
    ];
    masApps = { };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
