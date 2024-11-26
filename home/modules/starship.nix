{ config, pkgs, ... }:

{
  # Enable Starship Prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Configure Starship settings
    settings = {
      add_newline = false;                # Disable newline after the prompt
      
      prompt_order = [                    # Define the order of modules in the prompt
        "directory"                       # Current directory
        "git_status"                      # Git status
        "cmd_duration"                    # Command execution time
        "line_break"                      # Break to the next line
        "character"                       # Shell prompt character
      ];

      # Use Pywal colors for prompt styling
      directory = {
        style = "$(cat ~/.cache/wal/colors.json | jq -r '.colors.color1')";
      };

      aws = {
        disabled = true;
      };

      docker_context = {
        symbol = " ";
      };

      lua = {
        symbol = " ";
      };
      package = {
        symbol = " ";
      };
      php = {
        symbol = " ";
      };
      python = {
        symbol = " ";
      };
      terraform = {
        symbol = " ";
      };

      git_status = {
        style = "$(cat ~/.cache/wal/colors.json | jq -r '.colors.color2')";
      };

      cmd_duration = {
        style = "$(cat ~/.cache/wal/colors.json | jq -r '.colors.color3')";
      };

      character = {
        success_symbol = "[➜](bold $(cat ~/.cache/wal/colors.json | jq -r '.colors.color4'))";
        error_symbol = "[✗](bold $(cat ~/.cache/wal/colors.json | jq -r '.colors.color5'))";
      };

      # Fallback colors if Pywal isn't loaded
      line_break = {
        style = "bold green";
      };
    };
  };
}
