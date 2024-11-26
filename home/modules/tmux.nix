{ config, pkgs, lib, ... }:

let
  # Script to dynamically generate Tmux colors
  generateTmuxColorsScript = ''
    # Check if Pywal colors exist
    if [ -f "$HOME/.cache/wal/colors.json" ]; then
      # Extract colors from Pywal
      BG_COLOR=$(${pkgs.jq}/bin/jq -r '.colors.color0' "$HOME/.cache/wal/colors.json")
      FG_COLOR=$(${pkgs.jq}/bin/jq -r '.colors.color7' "$HOME/.cache/wal/colors.json")
      ACCENT_COLOR=$(${pkgs.jq}/bin/jq -r '.colors.color4' "$HOME/.cache/wal/colors.json")

      # Write the Tmux colors to a configuration file
      mkdir -p "$HOME/.config/tmux"
      cat > "$HOME/.config/tmux/colors.conf" <<EOF
      set-option -g status-bg "$BG_COLOR"
      set-option -g status-fg "$FG_COLOR"
      set-option -g window-status-current-style "bg=$ACCENT_COLOR"
      EOF
    else
      echo "Pywal colors.json not found. Run 'wal -i <wallpaper>' to generate."
    fi
  '';
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;              # Start windows at 1
    escapeTime = 0;            # No delay for escape key
    terminal = "screen-256color";

    # Main Tmux configuration
    extraConfig = ''
      # General Settings
      set-option -g mouse on
      set-option -g history-limit 10000
      set-option -g focus-events on

      # Better window splitting
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Easy config reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Source dynamically generated colors
      if-shell "[ -f ~/.config/tmux/colors.conf ]" "source-file ~/.config/tmux/colors.conf"
    '';
  };

  # Create the activation script
  home.activation = {
    generateTmuxColors = lib.hm.dag.entryAfter ["writeBoundary"] generateTmuxColorsScript;
  };
}