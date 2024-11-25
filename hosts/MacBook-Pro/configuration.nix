{
    pkgs,
    outputs,
    userConfig,
    ...
}: 
{
    # Enable Nix-Homebrew configuration
    nix-homebrew = {
        enable = true;
        enableRosetta = true; # Enable Rosetta for compatibility with x86 Homebrew packages
        user = "${userConfig.name}"; # Homebrew installed for the current user
        autoMigrate = true; # Automatically migrate old Homebrew packages
    };

    # Nixpkgs configuration
    nixpkgs = {
        overlays = [
            outputs.overlays.stable-packages # Include any custom overlays
        ];
        config = {
            allowUnfree = true; # Allow unfree packages (e.g., proprietary fonts)
        };
    };

    # Nix settings
    nix.settings = {
        experimental-features = "nix-command flakes"; # Enable new Nix features
        auto-optimize-store = true; # Automatically optimize the Nix store
    };

    nix.package = pkgs.nix; # Set the Nix package as the default

    # Enable Nix Daemon for system-wide package management
    services.nix-daemon.enable = true;

    # User configuration
    users.users.${userConfig.name} = {
        name = "${userConfig.name}";
        home = "/Users/${userConfig.name}";
    };

    # Enable TouchID for sudo
    security.pam.enableSudoTouchIdAuth = true;

    # macOS system settings
    system.defaults = {
        ".GlobalPreferences" = {};
        NSGlobalDomain = {
            AppleInterfaceStyle = "Dark"; # Use dark mode by default
            AppleShowAllExtensions = true; # Show all file extensions
            AppleICUForce24HourTime = true; # Use 24-hour time format
            KeyRepeat = 2; # Set faster key repeat rate
        };
        trackpad.TrackpadThreeFingerDrag = true; # Enable three-finger drag gesture
        finder = {
            AppleShowAllFiles = true; # Show hidden files
            CreateDesktop = false; # Disable icons on the desktop
            FXDefaultSearchScope = "SCcf"; # Set default Finder search scope to "Current Folder"
            FXEnableExtensionChangeWarning = false; # Disable warnings for changing file extensions
            FXPreferredViewStyle = "Nlsv"; # Set default Finder view style to list view
            QuitMenuItem = true; # Allow quitting Finder via Command+Q
            ShowPathbar = true; # Show the path bar in Finder
            ShowStatusBar = true; # Show the status bar in Finder
            _FXShowPosixPathInTitle = true; # Show POSIX paths in the title bar
            _FXSortFoldersFirst = true; # Sort folders first
        };
        dock = {
            autohide = true; # Auto-hide the dock
            expose-animation-duration = 0.15; # Speed up Mission Control animation
            show-recents = false; # Disable recent apps in the dock
            showhidden = true; # Show hidden apps as translucent
            persistent-apps = [
                "/Applications/Discord.app"
                "${pkgs.kitty}/Applications/kitty.app"
            ]; # Add pinned apps
            tilesize = 30; # Set dock tile size
            wvous-bl-corner = 1; # Configure hot corners (bottom-left: Mission Control)
            wvous-br-corner = 1; # Configure hot corners (bottom-right: Mission Control)
            wvous-tl-corner = 1; # Configure hot corners (top-left: Mission Control)
            wvous-tr-corner = 1; # Configure hot corners (top-right: Mission Control)
        };
        screencapture = {
            location = "~/Pictures/Screenshots"; # Set default screenshot location
            type = "png"; # Set default screenshot format
        };
    };

    # System-level packages
    environment.systemPackages = with pkgs; [
        neovim
        docker
        kitty
        tmux
        fzf
        sshs
        git
        spicetify-cli
        jq
        starship
    ]; # Core utilities and tools

    # Enable Sketchybar
    services.sketchybar.enable = true;

    # Enable Zsh
    programs.zsh.enable = true;

    # Fonts configuration
    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # Use JetBrainsMono Nerd Font
    ];

    # Homebrew-specific settings
    homebrew = {
        enable = true;
        brews = [ "mas" ]; # Install CLI tools via Homebrew
        casks = [
            "aerospace"
            "anki"
            "raycast"
        ]; # Install GUI apps via Homebrew
        taps = [ "nikitabobko/tap" ]; # Add additional Homebrew taps
        masApps = {}; # Add any macOS App Store apps here
        onActivation.cleanup = "zap"; # Cleanup unused Homebrew packages on activation
        onActivation.autoUpdate = true; # Automatically update Homebrew packages
        onActivation.upgrade = true; # Automatically upgrade Homebrew packages
    };

    # Set Git commit hash for darwin-version
    system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility
    system.stateVersion = 5;
}
