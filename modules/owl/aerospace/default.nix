{ homeManagerConfig, config, ... }:
{
    home.file.".config/aerospace/aerospace.toml".source =
        homeManagerConfig.linkHostApp config "aerospace";
}