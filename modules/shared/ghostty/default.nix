{ config, pkgs, lib, ... }:

let
  theme = import ../theme/default.nix { inherit lib; };
  colors = theme.theme;
  colorPalette = theme.colorPalette;
in

{
  # Install ghostty
  home.packages = [ pkgs.ghostty ];

  # Ghostty configuration
  home.file.".config/ghostty/config".text = ''
    theme = "rose-pine"
    
    # Font
    font-family = "Maple Mono NF"
    font-size = 14
    
    # Terminal behavior
    auto-update = check
    confirm-close-surface = false
    copy-on-select = clipboard
    scrollback-limit = 10000
    bold-is-bright = true
    
    # Key bindings
    keybind = cmd+c=copy_to_clipboard
    keybind = cmd+v=paste_from_clipboard
    keybind = cmd+n=new_window
    keybind = cmd+t=new_tab
    keybind = cmd+w=close_surface
    keybind = cmd+shift+right_bracket=next_tab
    keybind = cmd+shift+left_bracket=previous_tab
    keybind = cmd+plus=increase_font_size
    keybind = cmd+minus=decrease_font_size
    keybind = cmd+equal=reset_font_size
    keybind = cmd+k=clear_screen
    
    # Mouse
    mouse-hide-while-typing = true
    mouse-shift-capture = true
    mouse-scroll-multiplier = 1.0
    
    # Advanced
    quit-after-last-window-closed = false
    shell-integration = detect
    osc-color-report-format = true
  '';
}
