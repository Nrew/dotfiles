{ config, lib, pkgs, ... }:
let
  palette = "rose_pine";
in
{
  programs.starship = {
    enable = true;

    # Shell integration
    enableBashIntegration = true;
    enableZshIntegration = config.programs.zsh.enable;

    settings = {
      #───────────────────────────────────────────────────────────────────────────────
      # Palette
      #───────────────────────────────────────────────────────────────────────────────
      palette = palette;

      palettes.rose_pine = {
        rose = "#ebbcba";
        pine = "#31748f";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
        gold = "#f6c177";
        love = "#eb6f92";
        highlight_low = "#21202e"; # Or surface
        highlight_med = "#403d52"; # Or overlay
        highlight_high = "#524f67"; # A bit lighter than overlay
        text = "#e0def4";
        muted = "#6e6a86";
        subtle = "#908caa";
        base = "#191724";
        surface = "#1f1d2e";
        overlay = "#26233a";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Global Settings
      #───────────────────────────────────────────────────────────────────────────────
      add_newline = false;
      line_break.disabled = true; # Ensures single-line prompt

      #───────────────────────────────────────────────────────────────────────────────
      # Prompt Character
      #───────────────────────────────────────────────────────────────────────────────
      character = {
        success_symbol = "[❯](pine)"; # Using pine from Rosé Pine
        error_symbol = "[❯](love)";   # Using love from Rosé Pine
        vicmd_symbol = "[❮](iris)";   # Using iris from Rosé Pine
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Directory
      #───────────────────────────────────────────────────────────────────────────────
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold foam"; # Using foam from Rosé Pine
        read_only = " "; # Using a lock icon (ensure your font supports it)
        read_only_style = "love";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Git Configuration
      #───────────────────────────────────────────────────────────────────────────────
      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold iris"; # Using iris from Rosé Pine
        symbol = " "; # Git branch icon
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "love"; # Using love for status changes (often indicates action needed)
        conflicted = "󰅖 ";
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "󰹺 ⇡$ahead_count⇣$behind_count";
        untracked = "?$count"; # Simpler untracked symbol
        stashed = " $count"; # Stash icon
        modified = "!$count"; # Simpler modified symbol
        staged = "+$count";   # Simpler staged symbol
        renamed = "»$count";  # Simpler renamed symbol
        deleted = "✘$count";  # Simpler deleted symbol
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Programming Languages
      #───────────────────────────────────────────────────────────────────────────────
      nodejs = {
        format = "[$symbol($version )]($style)";
        style = "bold pine"; # Using pine
        symbol = "󰋘 "; # Node.js icon
      };

      python = {
        format = "[$symbol$version]($style) ";
        style = "bold gold"; # Using gold
        symbol = " "; # Python icon
      };

      rust = {
        format = "[$symbol($version )]($style)";
        style = "bold love"; # Rust often uses an orangey-red, love is close
        symbol = " "; # Rust icon
      };

      nix_shell = {
        format = "[$symbol$state( \($name\))]($style) ";
        style = "bold foam"; # Using foam
        symbol = " "; # NixOS icon
      };

      golang = {
        format = "[$symbol($version )]($style)";
        style = "bold foam"; # Using foam (Go is often blue/cyan)
        symbol = " "; # Go icon
      };

      lua = {
        format = "[$symbol($version )]($style)";
        style = "bold iris"; # Using iris
        symbol = " "; # Lua icon
      };

      package = {
        format = "[$symbol$version]($style) ";
        style = "bold gold"; # Using gold
        symbol = "󰏗 ";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Cloud Platforms
      #───────────────────────────────────────────────────────────────────────────────
      gcloud = {
        format = "[$symbol$active]($style) ";
        style = "bold pine"; # Using pine
        symbol = "󱇶 "; # GCP icon
      };

      aws = {
        format = "[$symbol$profile]($style) ";
        style = "bold gold"; # Using gold
        symbol = "󰸏 "; # AWS icon
      };

      #───────────────────────────────────────────────────────────────────────────────
      # System Information
      #───────────────────────────────────────────────────────────────────────────────
      cmd_duration = {
        format = "[took $duration]($style) "; # Changed format slightly for clarity
        style = "muted"; # Using muted for less prominent info
        min_time = 1000; # Lowered min_time to show more often, adjust as needed
        show_milliseconds = false;
      };

      time = {
        disabled = false;
        format = "[at $time]($style) "; # Changed format slightly
        style = "subtle"; # Using subtle for time
        time_format = "%R"; # %R is HH:MM in 24h, same as %H:%M
      };

      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        unknown_symbol = "󰂑 ";
        empty_symbol = "󰂎 ";
        disabled = false;
        display = [
          { threshold = 10; style = "bold love"; } # Using love for critical
          { threshold = 30; style = "bold gold"; } # Using gold for warning
          # No need for 100 threshold if the default is fine, or set it explicitly:
          { threshold = 100; style = "pine"; } # Using pine for normal/good
        ];
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Additional Components (Order in 'format' string below dictates display order)
      #───────────────────────────────────────────────────────────────────────────────
      username = {
        disabled = false;
        show_always = true; # Show always for consistency, or false if you prefer it only in SSH
        format = "[$user]($style)"; # Removed trailing space, manage spacing in main format string
        style = "bold text"; # Using text color, but bold
      };

      hostname = {
        disabled = false;
        ssh_only = true;
        format = "[@$hostname]($style)"; # Removed trailing space
        style = "bold gold"; # Using gold for hostnames
      };

      jobs = {
        symbol = ""; # Settings/gear icon for jobs
        style = "bold iris";
        number_threshold = 1;
        format = "[$symbol$number]($style)"; # Added $number to show job count
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Prompt Format
      #───────────────────────────────────────────────────────────────────────────────
      # This is where you define the order and spacing of your prompt elements.
      # Note: I've added spaces between modules for better readability.
      # You might want to remove some modules if your prompt gets too long.
      format = ''
      $username\
      $hostname\
      $directory\
      $git_branch\
      $git_status\
      $nix_shell\
      $package\
      $nodejs\
      $python\
      $rust\
      $golang\
      $lua\
      $aws\
      $gcloud\
      $jobs\
      $cmd_duration\
      $battery\
      $time\
      $character\
      ''; # Added a space before $character for visual separation
    };
  };
}
