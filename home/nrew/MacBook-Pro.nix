{ ... }: 
{
    # Import common and darwin-specific modules
    imports = [
        ../modules/common.nix           # Shared configuration across hosts
        ../modules/darwin-areospace.nix # Darwin-specific settings for this host
    ];

    # Enable home-manager for user-level configurations
    programs.home-manager.enable = true;

    # Ensure Homebrew is in the PATH
    home.sessionPath = [
        "/opt/homebrew/bin/"
    ];

    # Reload systemd user units when configs change
    systemd.user.startServices = "sd-switch";

    # Define the state version (aligns with the NixOS release)
    home.stateVersion = "24.05";
}
