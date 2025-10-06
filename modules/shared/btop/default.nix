{ config, pkgs, lib, palette, ... }:
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

  # Rose Pine theme for btop
  xdg.configFile."btop/themes/nix-theme.theme".text = ''
    theme[main_bg]="${palette.background}"
    theme[main_fg]="${palette.text}"
    theme[title]="${palette.primary}"
    theme[hi_fg]="${palette.success}"
    theme[selected_bg]="${palette.selection}"
    theme[selected_fg]="${palette.text}"
    theme[inactive_fg]="${palette.muted}"
    theme[graph_text]="${palette.subtext}"
    theme[proc_misc]="${palette.secondary}"
    theme[cpu_box]="${palette.primary}"
    theme[mem_box]="${palette.warning}"
    theme[net_box]="${palette.success}"
    theme[proc_box]="${palette.info}"
    theme[div_line]="${palette.border}"
  '';
}
