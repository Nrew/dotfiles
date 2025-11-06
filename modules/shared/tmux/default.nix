{ config, lib, pkgs, palette ? null, ... }:

let
  # Fallback palette if theme system is not enabled
  defaultPalette = {
    base = "#efead8"; text = "#2d2b28"; primary = "#857a71"; secondary = "#8f857a";
    red = "#a67070"; green = "#8fa670"; surface = "#cbc2b3"; overlay = "#a69e93";
    muted = "#655f59"; subtext0 = "#45413b"; subtext1 = "#5a554d";
  };
  
  colors = if palette != null then palette else defaultPalette;
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
      # Theme colors (static - edit in theme/default.nix)
      set -g status-style "bg=${colors.surface},fg=${colors.text}"
      set -g status-left "#[fg=${colors.base},bg=${colors.primary},bold] #S #[fg=${colors.primary},bg=${colors.surface},nobold]"
      set -g status-right "#[fg=${colors.overlay},bg=${colors.surface}]#[fg=${colors.text},bg=${colors.overlay}] %Y-%m-%d #[fg=${colors.primary},bg=${colors.overlay}]#[fg=${colors.base},bg=${colors.primary},bold] %H:%M "
      
      set -g window-status-format "#[fg=${colors.surface},bg=${colors.overlay}]#[fg=${colors.text},bg=${colors.overlay}] #I #W #[fg=${colors.overlay},bg=${colors.surface}]"
      set -g window-status-current-format "#[fg=${colors.surface},bg=${colors.green}]#[fg=${colors.base},bg=${colors.green},bold] #I #W #[fg=${colors.green},bg=${colors.surface},nobold]"
      
      set -g pane-border-style "fg=${colors.overlay}"
      set -g pane-active-border-style "fg=${colors.primary}"
      
      set -g message-style "fg=${colors.base},bg=${colors.primary}"
      set -g mode-style "bg=${colors.primary},fg=${colors.base}"
      
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
