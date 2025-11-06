{ config, lib, pkgs, ... }:

{
  xdg.configFile."barik/config.toml".source = ./config/config.toml;
}
