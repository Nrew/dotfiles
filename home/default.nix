{ config, pkgs, lib, user, system, ... }:
let
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = lib.hasSuffix "linux" system;
in
{
  #──────────────────────────────────────────────────────────────────
  # Imports & Core Configuration
  #──────────────────────────────────────────────────────────────────
  imports = [
    ./packages.nix
    ../modules/shared
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    ../modules/owl
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ../modules/crow
  ];

  #──────────────────────────────────────────────────────────────────
  # Theme Configuration
  #──────────────────────────────────────────────────────────────────
  # Change colorScheme to switch themes globally
  # Options: "catppuccin", "rose-pine", "nord", "gruvbox", "tokyo-night"
  theme = {
    enable = true;
    colorScheme = "catppuccin";
    catppuccin.flavor = "mocha"; # mocha, macchiato, frappe, latte
    rosePine.variant = "main"; # main, moon, dawn
    font = {
      mono = "JetBrainsMono Nerd Font";
      sans = "Inter";
      size = {
        small = 12;
        normal = 14;
        large = 16;
      };
    };
    borderRadius = 8;
    gap = 16;
    opacity = {
      terminal = 0.97;
      popup = 10;
    };
  };

  # Catppuccin integration (only enabled when theme is catppuccin)
  catppuccin = {
    enable = (config.theme.colorScheme == "catppuccin");
    flavor = config.theme.catppuccin.flavor;
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  #──────────────────────────────────────────────────────────────────
  # XDG Base Directory
  #──────────────────────────────────────────────────────────────────
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  #──────────────────────────────────────────────────────────────────
  # Home Configuration
  #──────────────────────────────────────────────────────────────────
  home = {
    enableNixpkgsReleaseCheck = false;
    username = user;
    homeDirectory = if isDarwin then "/Users/${user}" else "/home/${user}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    stateVersion = "24.11";

    # Environment Variables
    sessionVariables = {
      TERM = "xterm-256color";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Shell Aliases
    shellAliases = {
      # Modern replacements
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      cat = "bat --style=plain";

      # Git shortcuts
      g = "git";

      # Quick navigation
      conf = "cd ~/.config/dotfiles && nvim";
      sys = "fastfetch";
    };
  };
}
