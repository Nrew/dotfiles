{ config, pkgs, lib, palette ? null, ... }:

let
  # Fallback palette if theme system is not enabled
  defaultPalette = {
    base = "#efead8"; text = "#2d2b28"; primary = "#857a71"; green = "#8fa670";
    orange = "#b8905e"; cyan = "#70a6a6"; overlay = "#a69e93"; muted = "#655f59";
    subtext0 = "#45413b"; secondary = "#8f857a"; background = "#efead8";
    success = "#8fa670"; warning = "#b8905e"; info = "#70a6a6";
    selection = "#a69e93"; border = "#a69e93";
  };
  
  colors = if palette != null then palette else defaultPalette;
in
{
  programs.btop = {
    enable = true;
    
    settings = {
      color_theme = "nix-theme";
      theme_background = false;
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_tree = true;
      rounded_corners = true;
      shown_boxes = "cpu mem net proc";
      vim_keys = true;
    };
  };

  # Rose Pine theme for btop (build-time default)
  xdg.configFile."btop/themes/nix-theme.theme".text = ''
    theme[main_bg]="${colors.background}"
    theme[main_fg]="${colors.text}"
    theme[title]="${colors.primary}"
    theme[hi_fg]="${colors.success}"
    theme[selected_bg]="${colors.selection}"
    theme[selected_fg]="${colors.text}"
    theme[inactive_fg]="${colors.muted}"
    theme[graph_text]="${colors.subtext0}"
    theme[proc_misc]="${colors.secondary}"
    theme[cpu_box]="${colors.primary}"
    theme[mem_box]="${colors.warning}"
    theme[net_box]="${colors.success}"
    theme[proc_box]="${colors.info}"
    theme[div_line]="${colors.border}"
  '';

  # Theme reloading is handled by the theme-switch script in theme/default.nix
}
