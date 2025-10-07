{ config, lib, pkgs, ... }:

{
  home.file.".config/barik/config.toml".source = ./config/config.toml;
}
