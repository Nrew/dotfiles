{ config, lib, pkgs, ... }:
{
	home.file.".config/sketchybar".source = ./config;
}