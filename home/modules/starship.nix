# modules/cli/starship.nix
{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    
    settings = {
      add_newline = false;
      
      # Character prompt
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold green)";
      };

      # Directory
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      # Git settings
      git_branch = {
        format = "[$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "⚔️";
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        untracked = "?$count";
        stashed = "📦";
        modified = "!$count";
        staged = "+$count";
        renamed = "»$count";
        deleted = "✘$count";
      };

      # Languages and tools
      nodejs = {
        format = "[$symbol($version )]($style)";
        style = "bold green";
      };

      python = {
        format = "[$symbol$version]($style) ";
        style = "bold yellow";
      };

      rust = {
        format = "[$symbol($version )]($style)";
        style = "bold red";
      };

      nix_shell = {
        format = "[$symbol$state( \($name\))]($style) ";
        style = "bold blue";
      };

      golang = {
        format = "[$symbol($version )]($style)";
        style = "bold cyan";
      };

      lua = {
        format = "[$symbol($version )]($style)";
        style = "bold blue";
      };

      package = {
        format = "[$symbol$version]($style) ";
        style = "bold 208";
      };

      # Cloud platforms
      gcloud = {
        format = "[$symbol$active]($style) ";
        style = "bold blue";
      };

      aws = {
        format = "[$symbol$profile]($style) ";
        style = "bold yellow";
      };

      # Command duration
      cmd_duration = {
        format = "took [$duration]($style) ";
        style = "bold yellow";
        min_time = 2000;
        show_milliseconds = false;
      };

      # Time
      time = {
        disabled = false;
        format = "at [$time]($style) ";
        style = "bold dimmed";
        time_format = "%H:%M";
      };

      # Battery
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "💀";
        disabled = false;
        display = [
          {threshold = 10; style = "bold red";}
          {threshold = 30; style = "bold yellow";}
          {threshold = 100; style = "bold green";}
        ];
      };

      # Module arrangement
      format = """
        $username\
        $hostname\
        $directory\
        $git_branch\
        $git_status\
        $nodejs\
        $python\
        $rust\
        $golang\
        $lua\
        $nix_shell\
        $aws\
        $gcloud\
        $cmd_duration\
        $time\
        $line_break\
        $jobs\
        $battery\
        $character\
      """;

      # Individual component disabling
      username = {
        disabled = false;
        show_always = false;
      };

      hostname = {
        disabled = false;
        ssh_only = true;
      };

      jobs = {
        symbol = "⚙️";
        style = "bold blue";
        number_threshold = 1;
        format = "[$symbol]($style)";
      };

      line_break = {
        disabled = false;
      };
    };

    # Enable shell integration
    enableZshIntegration = true;
  };
}