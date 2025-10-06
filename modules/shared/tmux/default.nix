{ config, lib, pkgs, palette, ... }:
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
      # Status bar configuration
      set -g status on
      set -g status-justify left
      set -g status-style "bg=${palette.surface},fg=${palette.text}"
      set -g status-position top
      set -g status-interval 2
      set -g status-left-length 100
      set -g status-right-length 100
      
      set -g status-left "#[fg=${palette.background},bg=${palette.primary},bold] #S #[fg=${palette.primary},bg=${palette.surface},nobold]"
      set -g status-right "#[fg=${palette.overlay},bg=${palette.surface}]#[fg=${palette.text},bg=${palette.overlay}] %Y-%m-%d #[fg=${palette.primary},bg=${palette.overlay}]#[fg=${palette.background},bg=${palette.primary},bold] %H:%M "
      
      # Window status
      set -g window-status-separator ""
      set -g window-status-format "#[fg=${palette.surface},bg=${palette.overlay}]#[fg=${palette.text},bg=${palette.overlay}] #I #W #[fg=${palette.overlay},bg=${palette.surface}]"
      set -g window-status-current-format "#[fg=${palette.surface},bg=${palette.success}]#[fg=${palette.background},bg=${palette.success},bold] #I #W #[fg=${palette.success},bg=${palette.surface},nobold]"
      
      # Pane borders
      set -g pane-border-style "fg=${palette.border}"
      set -g pane-active-border-style "fg=${palette.primary}"
      
      # Message text
      set -g message-style "fg=${palette.background},bg=${palette.primary}"
      set -g mode-style "bg=${palette.primary},fg=${palette.background}"

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
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display "Config reloaded!"
      
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
