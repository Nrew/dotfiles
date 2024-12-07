{ config, pkgs, inputs, outputs, system, user, ... }:

{
    # ───────────────────────────────────────────────────────────────────────────────
    # Shared-Specific Settings
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
        enableRosetta = true;                       # Enable Rosetta for compatibility with x86 Homebrew packages
        user = "${user}";                           # Homebrew installed for the current user
        autoMigrate = true;                         # Automatically migrate old Homebrew packages
    };

    # Enable Nix Daemon for system-wide package management
    services.nix-daemon.enable = true;

    # User configuration
    users.users.${user} = {
        name = "${user}";
        home = "/Users/${user}";
    };

    # Enable TouchID for sudo
    security.pam.enableSudoTouchIdAuth = true;

    # ───────────────────────────────────────────────────────────────────────────────
    # macOS System Settings
    # ───────────────────────────────────────────────────────────────────────────────

    system.defaults = {
        ".GlobalPreferences" = { };
        NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";           # Use dark mode by default
            AppleShowAllExtensions = true;          # Show all file extensions
            AppleICUForce24HourTime = true;         # Use 24-hour time format
            KeyRepeat = 2;                          # Set faster key repeat rate
        };
        trackpad.TrackpadThreeFingerDrag = true;    # Enable three-finger drag gesture
        finder = {
            AppleShowAllFiles = true;               # Show hidden files
            CreateDesktop = false;                  # Disable icons on the desktop
            FXDefaultSearchScope = "SCcf";          # Set default Finder search scope to "Current Folder"
            FXEnableExtensionChangeWarning = false; # Disable warnings for changing file extensions
            FXPreferredViewStyle = "Nlsv";          # Set default Finder view style to list view
            QuitMenuItem = true;                    # Allow quitting Finder via Command+Q
            ShowPathbar = true;                     # Show the path bar in Finder
            ShowStatusBar = true;                   # Show the status bar in Finder
            _FXShowPosixPathInTitle = true;         # Show POSIX paths in the title bar
            _FXSortFoldersFirst = true;             # Sort folders first
        };
        dock = {
            autohide = true;                        # Auto-hide the dock
            expose-animation-duration = 0.15;       # Speed up Mission Control animation
            show-recents = false;                   # Disable recent apps in the dock
            showhidden = true;                      # Show hidden apps as translucent
            persistent-apps = [                     # Add pinned apps
                "/Applications/Discord.app"
                "${pkgs.kitty}/Applications/kitty.app"
            ];                                      
            tilesize = 30;                          # Set dock tile size
            
            wvous-all-corner = 1;                   # Instead of individual settings
            
            # wvous-bl-corner = 1;                  # Configure hot corners (bottom-left: Mission Control)
            # wvous-br-corner = 1;                  # Configure hot corners (bottom-right: Mission Control)
            # wvous-tl-corner = 1;                  # Configure hot corners (top-left: Mission Control)
            # wvous-tr-corner = 1;                  # Configure hot corners (top-right: Mission Control)
        };
        CustomUserPreferences = {
            "com.apple.desktopservices" = {
                DSDontWriteNetworkStores = true;    # Disable .DS_Store files on network volumes
                DSDontWriteUSBStores = true;        # Disable .DS_Store files on USB drives
            };
        };
        screencapture = {
            location = "~/Pictures/Screenshots";    # Set default screenshot location
            type = "png";                           # Set default screenshot format
        };
    };

    # ────────────────────────────────────────────────────────────────
    # macOS-Specific System-Level Packages
    # ────────────────────────────────────────────────────────────────

    environment.systemPackages = with pkgs; [];

    # ────────────────────────────────────────────────────────────────
    # Homebrew-Specific Settings
    # ────────────────────────────────────────────────────────────────

    homebrew = {
        enable = true;
        brews = [ "mas" ];                          # Install CLI tools via Homebrew
        casks = [                                   # Install GUI apps via Homebrew
            "anki"
            "raycast"
            "aerospace"
        ]; 
        taps = [ "nikitabobko/tap" ];               # Add additional Homebrew taps
        masApps = {};                               # Add any macOS App Store apps here
        onActivation = {
            cleanup = "zap";                        # Cleanup unused Homebrew packages on activation
            autoUpdate = true;                      # Automatically update Homebrew packages
            upgrade = true;                         # Automatically upgrade Homebrew packages
        };
    };
}