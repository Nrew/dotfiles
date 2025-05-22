{ config, lib, pkgs, ... }:
{
	home.file.".config/sketchybar" = {
		source = ./config;
		onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
	};
}
