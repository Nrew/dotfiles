{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    
    # Shell integration
    enableBashIntegration = true;
    enableZshIntegration = config.programs.zsh.enable;

    settings = {
      #───────────────────────────────────────────────────────────────────────────────
      # Global Settings
      #───────────────────────────────────────────────────────────────────────────────
      add_newline = false;
      line_break.disabled = true;

      #───────────────────────────────────────────────────────────────────────────────
      # Prompt Character
      #───────────────────────────────────────────────────────────────────────────────
      character = {
        success_symbol = "[ ](green)";
        error_symbol = "[ ](bold red)";
        vicmd_symbol = "[ ](bold green)";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Directory
      #───────────────────────────────────────────────────────────────────────────────
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
        read_only = " ";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Git Configuration
      #───────────────────────────────────────────────────────────────────────────────
      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
        symbol = " ";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "󰅖 ";
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "󰹺 ⇡$ahead_count⇣$behind_count";
        untracked = " $count";
        stashed = " ";
        modified = " $count";
        staged = " $count";
        renamed = "󰑕 $count";
        deleted = " $count";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Programming Languages
      #───────────────────────────────────────────────────────────────────────────────
      nodejs = {
        format = "[$symbol($version )]($style)";
        style = "bold green";
        symbol = " ";
      };

      python = {
        format = "[$symbol$version]($style) ";
        style = "bold yellow";
        symbol = " ";
      };

      rust = {
        format = "[$symbol($version )]($style)";
        style = "bold red";
        symbol = " ";
      };

      nix_shell = {
        format = "[$symbol$state( \($name\))]($style) ";
        style = "bold blue";
        symbol = " ";
      };

      golang = {
        format = "[$symbol($version )]($style)";
        style = "bold cyan";
        symbol = " ";
      };

      lua = {
        format = "[$symbol($version )]($style)";
        style = "bold blue";
        symbol = " ";
      };

      package = {
        format = "[$symbol$version]($style) ";
        style = "bold 208";
        symbol = "󰏗 ";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Cloud Platforms
      #───────────────────────────────────────────────────────────────────────────────
      gcloud = {
        format = "[$symbol$active]($style) ";
        style = "bold blue";
        symbol = " ";
      };

      aws = {
        format = "[$symbol$profile]($style) ";
        style = "bold yellow";
        symbol = " ";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # System Information
      #───────────────────────────────────────────────────────────────────────────────
      cmd_duration = {
        format = "[ $duration]($style) ";
        style = "bold yellow";
        min_time = 2000;
        show_milliseconds = false;
      };

      time = {
        disabled = false;
        format = "[ $time]($style) ";
        style = "bold dimmed";
        time_format = "%H:%M";
      };

      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        disabled = false;
        display = [
          {threshold = 10; style = "bold red";}
          {threshold = 30; style = "bold yellow";}
          {threshold = 100; style = "bold green";}
        ];
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Prompt Format
      #───────────────────────────────────────────────────────────────────────────────
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

      #───────────────────────────────────────────────────────────────────────────────
      # Additional Components
      #───────────────────────────────────────────────────────────────────────────────
      username = {
        disabled = false;
        show_always = false;
        format = "[$user]($style) ";
        style = "bold blue";
      };

      hostname = {
        disabled = false;
        ssh_only = true;
        format = "[@$hostname]($style) ";
        style = "bold green";
      };

      jobs = {
        symbol = "󱜯 ";
        style = "bold blue";
        number_threshold = 1;
        format = "[$symbol]($style)";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Palette
      #───────────────────────────────────────────────────────────────────────────────
      palette = "rose_pine";

      palettes.rose_pine = {
        base = "#191724";
        surface = "#1f1d2e";
        overlay = "#26233a";
        muted = "#6e6a86";
        subtle = "#908caa";
        text = "#e0def4";
        love = "#eb6f92";
        gold = "#f6c177";
        rose = "#ebbcba";
        pine = "#31748f";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
      };

    };
  };
}
