{ config, pkgs, username, ... }: 

{
  imports = [ 
    ./modules/kitty.nix 
    # Add other program configs here
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    sessionPath = [
        "/opt/homebrew/bin/"
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
}