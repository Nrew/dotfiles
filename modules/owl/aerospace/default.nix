{ config, lib, pkgs, ... }:

{
  home.file.".config/aerospace/aerospace.toml".source = ./config/aerospace.toml;
}
