{ config, lib, pkgs, ... }:
let
  theme = import ../theme/default.nix { inherit lib; };
  colors = theme.theme;
in
{
  programs.starship = {
    enable = true;

    #───────────────────────────────────────────────────────────────────────────────
    # Starship Configuration
    #───────────────────────────────────────────────────────────────────────────────

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {

      #───────────────────────────────────────────────────────────────────────────────
      # Schema Configuration
      #───────────────────────────────────────────────────────────────────────────────

      "$schema" = "https://starship.rs/config-schema.json";

      palette = "rose-pine";
      overlay = colors.overlay;
      love    = colors.love;
      gold    = colors.gold;
      rose    = colors.rose;
      pine    = colors.pine;
      foam    = colors.foam;
      iris    = colors.iris;

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
        format = "[](fg:overlay)[ $path ]($style)[](fg:overlay) ";
        style = "bg:overlay fg:pine";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Fill
      #───────────────────────────────────────────────────────────────────────────────
      fill = {
        style = "fg:overlay";
        symbol = " ";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Git Configuration
      #───────────────────────────────────────────────────────────────────────────────
      git_branch = {
        format = "[](fg:overlay)[ $symbol $branch ]($style)[](fg:overlay) ";
        style = "bg:overlay fg:foam";
        symbol = "";
      };

      git_status = {
        disabled = false;
        style = "bg:overlay fg:love";
        format = "[](fg:overlay)([$all_status$ahead_behind]($style))[](fg:overlay) ";
        up_to_date = "[ ✓ ](bg:overlay fg:iris)";
        untracked = "[?\($count\)](bg:overlay fg:gold)";
        stashed = "[\$](bg:overlay fg:iris)";
        modified = "[!\($count\)](bg:overlay fg:gold)";
        renamed = "[»\($count\)](bg:overlay fg:iris)";
        deleted = "[✘\($count\)](style)";
        staged = "[++\($count\)](bg:overlay fg:gold)";
        ahead = "[⇡\($count\)](bg:overlay fg:foam)";
        diverged = "⇕[\[](bg:overlay fg:iris)[⇡\($ahead_count\)](bg:overlay fg:foam)[⇣\($behind_count\)](bg:overlay fg:rose)[\]](bg:overlay fg:iris)";
        behind = "[⇣\($count\)](bg:overlay fg:rose)";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Time
      #───────────────────────────────────────────────────────────────────────────────
      time = {
        disabled = false;
        format = " [](fg:overlay)[ $time 󰴈 ]($style)[](fg:overlay)";
        style = "bg:overlay fg:rose";
        time_format = "%I:%M%P";
        use_12hr = true;
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Username
      #───────────────────────────────────────────────────────────────────────────────
      username = {
        disabled = false;
        format = "[](fg:overlay)[ 󰧱 $user ]($style)[](fg:overlay) ";
        show_always = true;
        style_root = "bg:overlay fg:iris";
        style_user = "bg:overlay fg:iris";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Programming Languages
      #───────────────────────────────────────────────────────────────────────────────

      c = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      elixir = { 
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      elm = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      golang = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      haskell = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      java = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "󰈤 ";
      };

      julia = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "󰌈 ";
      };

      nodejs = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "󰋘 ";
      };

      nim = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "󰈙 ";
      };

      rust = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      scala = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "󰚧 ";
      };

      python = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      conda = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$environment ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "🅒  ";
      };

      nix = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      lua = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
        disabled = false;
        symbol = " ";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # Cloud Platforms
      #───────────────────────────────────────────────────────────────────────────────
      gcloud = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$active ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "󱇶 ";
      };

      aws = {
        style = "bg:overlay fg:pine";
        format = " [](fg:overlay)[ $symbol$active ]($style)[](fg:overlay)";
        disabled = false;
        symbol = "󰸏 ";
      };

      #───────────────────────────────────────────────────────────────────────────────
      # System Information
      #───────────────────────────────────────────────────────────────────────────────
      cmd_duration = {
        disabled = false;
        format = "[](fg:overlay)[ $symbol$duration ]($style)[](fg:overlay) ";
        style = "bg:overlay fg:rose";
        min_time = 1000;
        show_milliseconds = false;
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

      hostname = {
        disabled = false;
        ssh_only = true;
        format = "[@$hostname]($style)"; # Removed trailing space
        style = "bold gold"; # Using gold for hostnames
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
      $fill\
      $c\
      $elixir\
      $elm\
      $golang\
      $haskell\
      $java\
      $julia\
      $nodejs\
      $nim\
      $rust\
      $scala\
      $python\
      $conda\
      $nix\
      $lua\
      $gcloud\
      $aws\
      $jobs\
      $cmd_duration\
      $battery\
      $time\n  \
      [󱞪](fg:iris) \
      '';
    };
  };
}
