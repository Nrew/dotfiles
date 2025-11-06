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

  # Script to generate btop theme from runtime palette
  btopThemeReloader = pkgs.writeShellScript "btop-theme-reload" ''
    #!/usr/bin/env bash
    
    PALETTE_FILE="${config.xdg.configHome}/theme/palette.json"
    BTOP_THEME="${config.xdg.configHome}/btop/themes/nix-theme.theme"
    
    if [ ! -f "$PALETTE_FILE" ]; then
      exit 0
    fi
    
    mkdir -p "$(dirname "$BTOP_THEME")"
    
    # Extract colors from palette.json
    BG=$(${pkgs.jq}/bin/jq -r '.colors.background // .colors.base' "$PALETTE_FILE")
    FG=$(${pkgs.jq}/bin/jq -r '.colors.text' "$PALETTE_FILE")
    PRIMARY=$(${pkgs.jq}/bin/jq -r '.colors.primary' "$PALETTE_FILE")
    SUCCESS=$(${pkgs.jq}/bin/jq -r '.colors.success // .colors.green' "$PALETTE_FILE")
    SEL_BG=$(${pkgs.jq}/bin/jq -r '.colors.selection // .colors.overlay' "$PALETTE_FILE")
    MUTED=$(${pkgs.jq}/bin/jq -r '.colors.muted' "$PALETTE_FILE")
    SUBTEXT=$(${pkgs.jq}/bin/jq -r '.colors.subtext0 // .colors.subtext' "$PALETTE_FILE")
    SECONDARY=$(${pkgs.jq}/bin/jq -r '.colors.secondary' "$PALETTE_FILE")
    WARNING=$(${pkgs.jq}/bin/jq -r '.colors.warning // .colors.orange' "$PALETTE_FILE")
    INFO=$(${pkgs.jq}/bin/jq -r '.colors.info // .colors.cyan' "$PALETTE_FILE")
    BORDER=$(${pkgs.jq}/bin/jq -r '.colors.border // .colors.overlay' "$PALETTE_FILE")
    
    # Generate btop theme
    cat > "$BTOP_THEME" <<EOF
theme[main_bg]="$BG"
theme[main_fg]="$FG"
theme[title]="$PRIMARY"
theme[hi_fg]="$SUCCESS"
theme[selected_bg]="$SEL_BG"
theme[selected_fg]="$FG"
theme[inactive_fg]="$MUTED"
theme[graph_text]="$SUBTEXT"
theme[proc_misc]="$SECONDARY"
theme[cpu_box]="$PRIMARY"
theme[mem_box]="$WARNING"
theme[net_box]="$SUCCESS"
theme[proc_box]="$INFO"
theme[div_line]="$BORDER"
EOF

    # Signal btop to reload config if running
    pkill -SIGUSR1 btop 2>/dev/null || true
  '';
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

  # Add the theme reloader script to home packages
  home.packages = [ (pkgs.writeShellScriptBin "btop-reload-theme" ''
    ${btopThemeReloader}
  '') ];
}
