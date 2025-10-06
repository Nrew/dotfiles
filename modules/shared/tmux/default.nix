{ config, lib, pkgs, ... }:

let
  theme = import ./theme/default.nix { inherit lib; };
  colors = theme.theme;
in

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    prefix = "C-space";

    extraConfig = ''
      # Define color scheme
      set -g @background "${colors.base}"
      set -g @foreground "${colors.text}"
      set -g @cursor "${colors.text}"
      set -g @color0 "${colors.base}"
      set -g @color1 "${colors.love}"
      set -g @color2 "${colors.foam}"
      set -g @color3 "${colors.gold}"
      set -g @color4 "${colors.pine}"
      set -g @color5 "${colors.iris}"
      set -g @color6 "${colors.foam}"
      set -g @color7 "${colors.text}"
      set -g @color8 "${colors.overlay}"
      set -g @color9 "${colors.love}"
      set -g @color10 "${colors.foam}"
      set -g @color11 "${colors.gold}"
      set -g @color12 "${colors.pine}"
      set -g @color13 "${colors.iris}"
      set -g @color14 "${colors.foam}"
      set -g @color15 "${colors.text}"

      # True color support
      set -as terminal-features ",xterm-256color:RGB"
      set -g default-terminal "tmux-256color"
      
      # Focus events (for vim etc)
      set -g focus-events on

      # Window numbering
      set -g renumber-windows on
      setw -g automatic-rename on
      
      # Status bar configuration
      set -g status-position top
      set -g status-interval 2
      set -g status-left-length 20
      set -g status-right-length 100
      
      set -g status-left "#{?client_prefix,#[bg=#{@color4}]#[fg=#{@background}],#[bg=#{@color8}]#[fg=#{@foreground}]} #S "
      set -g status-right "#[fg=#{@foreground}] %H:%M #[bg=#{@color8}]#[fg=#{@foreground}] %d-%b-%y "
      
      # Window status
      setw -g window-status-format "#[fg=#{@color8}]#[bg=#{@background}] #I #[fg=#{@color8}]#[bg=#{@background}] #W "
      setw -g window-status-current-format "#[fg=#{@background}]#[bg=#{@color4}] #I #[fg=#{@background}]#[bg=#{@color4}] #W "
      
      # Pane borders
      set -g pane-border-style "fg=#{@color8}"
      set -g pane-active-border-style "fg=#{@color4}"
      
      # Message text
      set -g message-style "fg=#{@background},bg=#{@color4}"
      
      # Key bindings
      # Split panes
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Vim-like pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2
      
      # Copy mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
      bind -T copy-mode-vi r send -X rectangle-toggle
      
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # Smart pane switching with awareness of Vim splits
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
    '';

    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
    ];
  };


}
