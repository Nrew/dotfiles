{ homeManagerConfig, config, ... }:
{
    home.file.".config/aerospace.toml".source =
        homeManagerConfig.linkHostApp config "aerospace.toml";
}