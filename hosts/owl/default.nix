{ config, pkgs, ... }:

let user = "nrew"; in

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
        user = user;                                # Homebrew installed for the current user
        autoMigrate = true;                         # Automatically migrate old Homebrew packages
    };

    # User configuration
    users.users.${user} = {
        name        = user;
        home        = "/Users/${user}";
        isHidden    = false;
        shell       = pkgs.zsh;
    };

    # Enable TouchID for sudo
    security.pam.services.sudo_local.touchIdAuth = true;

    # ───────────────────────────────────────────────────────────────────────────────
    # macOS System Settings
    # NOTE: Some options are not supported by nix-darwin directly, manually configure
    #   1. To avoid conflicts with neovim, disable ctrl + up/down/left/right 
    # ───────────────────────────────────────────────────────────────────────────────

    system = {
        checks.verifyNixPath = false;
        primaryUser = user;
        defaults = {
            ".GlobalPreferences" = { };
            LaunchServices = {
                LSQuarantine = false;                  # Disable quarantine for downloaded files
            };
            NSGlobalDomain = {
                _HIHideMenuBar = true;                  # Hide the menu bar  
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
                # persistent-apps = [                     # Add pinned apps
                #     "/Applications/Discord.app"
                #     "${pkgs.kitty}/Applications/kitty.app"
                # ];
                tilesize = 30;                          # Set dock tile size

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
    };

    # ────────────────────────────────────────────────────────────────
    # macOS-Specific System-Level Packages
    # ────────────────────────────────────────────────────────────────

    environment.systemPackages = with pkgs; [
    ];

    fonts = {
        packages = with pkgs; [
            sketchybar-app-font
            source-code-pro
        ];
    };

    # ────────────────────────────────────────────────────────────────
    # Homebrew-Specific Settings
    # ────────────────────────────────────────────────────────────────
    # @see:
    #   - https://github.com/ryan4yin/nix-config
    #
    #  NOTE: Your can find all available options in:
    #    https://daiderd.com/nix-darwin/manual/index.html
    #
    #  NOTE：To remove the uninstalled APPs icon from Launchpad:
    #    1. `sudo nix store gc --debug` & `sudo nix-collect-garbage --delete-old`
    #    2. click on the uninstalled APP's icon in Launchpad, it will show a question mark
    #    3. if the app starts normally:
    #        1. right click on the running app's icon in Dock, select "Options" -> "Show in Finder" and delete it
    #    4. hold down the Option key, a `x` button will appear on the icon, click it to remove the icon
    # ────────────────────────────────────────────────────────────────

    homebrew = {
        enable = true;
        brews = [                                   # Install CLI tools via Homebrew
            # `brew install`
            "mas"
	          "lua"
            "spicetify-cli"
            "gowall"
	          "switchaudio-osx"
            "nowplaying-cli"
	          "sketchybar"
        ];
        casks = [                                   # Install GUI apps via Homebrew
            # `brew install --cask`
            "aerospace"
            "anki"
            "discord"
            "obsidian"
            "raycast"
            "visual-studio-code"
            "ghostty"
            "sf-symbols"
            "homebrew/cask-fonts/font-sf-mono"
            "homebrew/cask-fonts/font-sf-pro"
	          "zen"
        ]; 
        taps = [                                    # Add additional Homebrew taps
            "nikitabobko/tap"                       # Aerospace tap
            "felixkratz/formulae"                   # Sketchybar tap
        ];               
        masApps = {};                               # Add any macOS App Store apps here
        onActivation = {
            cleanup = "zap";                        # Cleanup unused Homebrew packages on activation
            autoUpdate = true;                      # Automatically update Homebrew packages
            upgrade = true;                         # Automatically upgrade Homebrew packages
        };
    };

    services.sketchybar.enable = true;
}
