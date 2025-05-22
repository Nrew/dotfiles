{ config, lib, pkgs, ... }:
{
	home.file.".config/sketchybar" = {
		source = ./config;
		onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
	};
	
	programs.sketchybar = {
		enable = true;
		config = {
			configPath = "${pkgs.sketchybar}/share/sketchybar/config";
		};
	};

}
