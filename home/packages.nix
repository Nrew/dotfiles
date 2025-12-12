{ pkgs, lib, system, ... }:

let
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux  = lib.hasSuffix "linux"  system;
in
{
  # User-space packages (managed by home-manager)
  home.packages = with pkgs; [
    # CLI utilities
    ripgrep         # Fast grep alternative
    fd              # Fast find alternative
    bat             # Cat with syntax highlighting
    eza             # Modern ls replacement
    zoxide          # Smart cd command
    fzf             # Fuzzy finder
    jq              # JSON processor
    gh              # GitHub CLI
    wget            # File downloader
    curl            # URL transfer tool
    
    # Media and system info
    ffmpeg          # Media processing
    htop            # Process viewer
    btop            # Resource monitor
    fastfetch       # System info display
    imagemagick     # Image processing
    gowall          # Image processing
    
    # Terminal and shell
    tmux            # Terminal multiplexer
    kitty           # Terminal emulator
    starship        # Shell prompt
    
    # Development tools
    lazygit         # Git TUI
  ] ++ lib.optionals isDarwin [ m-cli ];
}
