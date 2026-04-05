{ config, pkgs, ... }:

{
  catppuccin.tmux.enable = true;
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
      set -g status-position top
      set -g status-interval 2
      set -g status-left-length 100
      set -g status-right-length 100
      
      # Window status separator
      set -g window-status-separator ""

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

      # Continuum auto-restore on startup
      set -g @continuum-restore 'on'
    '';

    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
    ];
  };
}
