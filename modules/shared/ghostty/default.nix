{ config, pkgs, lib, ... }:

{
  home.file.".config/ghostty/config".text = ''
    #───────────────────────────────────────────────────────────────────────────────
    # Theme
    #───────────────────────────────────────────────────────────────────────────────
    theme = rose-pine

    #───────────────────────────────────────────────────────────────────────────────
    # Font
    #───────────────────────────────────────────────────────────────────────────────
    font-family = "Maple Mono NF" # Sets the primary font family.
    font-size = 14                # Sets the font size.

    #───────────────────────────────────────────────────────────────────────────────
    # Terminal Behavior
    #───────────────────────────────────────────────────────────────────────────────
    auto-update = "check"         # Configures how Ghostty handles updates ("check", "download", "off").
    confirm-close-surface = false # If true, prompts for confirmation before closing a window/tab.
    copy-on-select = "clipboard"  # Automatically copies selected text to the clipboard.
    scrollback-limit = 10000      # Maximum number of lines to keep in the scrollback buffer.
    bold-is-bright = true         # Renders bold text with bright colors.

    #───────────────────────────────────────────────────────────────────────────────
    # Key Bindings
    #───────────────────────────────────────────────────────────────────────────────
    keybind = [
      "cmd+c=copy_to_clipboard",              # Copies selected text to the clipboard.
      "cmd+v=paste_from_clipboard",           # Pastes text from the clipboard.
      "cmd+n=new_window",                     # Opens a new Ghostty window.
      "cmd+t=new_tab",                        # Opens a new tab in the current window.
      "cmd+w=close_surface",                  # Closes the current tab or window.
      "cmd+shift+right_bracket=next_tab",     # Switches to the next tab.
      "cmd+shift+left_bracket=previous_tab",  # Switches to the previous tab.
      "cmd+plus=increase_font_size",          # Increases the font size.
      "cmd+minus=decrease_font_size",         # Decreases the font size.
      "cmd+equal=reset_font_size",            # Resets the font size to the default.
      "cmd+k=clear_screen"                    # Clears the terminal screen.
    ]

    #───────────────────────────────────────────────────────────────────────────────
    # Mouse Behavior
    #───────────────────────────────────────────────────────────────────────────────
    mouse-hide-while-typing = true  # Hides the mouse cursor while typing.
    mouse-shift-capture = true      # Modifies mouse behavior when Shift is pressed (e.g., for selection).
    mouse-scroll-multiplier = 1.0   # Adjusts the mouse scroll speed.

    #───────────────────────────────────────────────────────────────────────────────
    # Advanced Settings
    #───────────────────────────────────────────────────────────────────────────────
    quit-after-last-window-closed = false # If true, Ghostty exits when the last window is closed.
    shell-integration = "detect"          # Enables shell integration features (e.g., current working directory).
    osc-color-report-format = true        # Enables OSC color reporting.
  '';
}
