{ config, pkgs, lib, ... }:

let
  theme = import ../theme/default.nix { inherit lib; };
  colors = theme.theme;
in

{
  # btop configuration
  home.file.".config/btop/btop.conf".text = ''
    # btop configuration file
    # Theme
    color_theme = "rose-pine"
    
    # Global settings
    theme_background = True
    truecolor = True
    force_tty = False
    presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"
    vim_keys = True
    rounded_corners = True
    graph_symbol = "braille"
    graph_symbol_cpu = "default"
    graph_symbol_mem = "default"
    graph_symbol_net = "default"
    graph_symbol_proc = "default"
    
    # CPU settings
    shown_boxes = "cpu mem net proc"
    update_ms = 2000
    proc_sorting = "cpu lazy"
    proc_reversed = False
    proc_tree = False
    proc_colors = True
    proc_gradient = True
    proc_per_core = True
    proc_mem_bytes = True
    proc_cpu_graphs = True
    
    # CPU colors and gradients
    cpu_graph_upper = "default"
    cpu_graph_lower = "default"
    cpu_invert_lower = True
    cpu_single_graph = False
    cpu_bottom = False
    cpu_sensor = "Auto"
    
    # Memory settings
    mem_graphs = True
    mem_below_net = False
    zfs_arc_cached = True
    
    # Network settings
    net_download = 100
    net_upload = 100
    net_auto = True
    net_sync = False
    net_iface = ""
    net_icon_rx = ""
    net_icon_tx = "󰕒"
    
    # Processes settings
    show_detailed = False
    proc_filtering = True
    proc_info_smaps = False
    
    # Log settings
    log_level = "WARNING"
    
    # Disk settings
    show_disks = True
    only_physical = True
    use_fstab = True
    zfs_hide_datasets = False
    disk_free_priv = False
    show_io_stat = True
    io_mode = False
    io_graph_combined = False
    io_graph_speeds = ""
    
    # Temperature settings
    check_temp = True
    show_coretemp = True
    temp_scale = "celsius"
    show_gpu_info = True
    custom_gpu_name0 = ""
    custom_gpu_name1 = ""
    custom_gpu_name2 = ""
    custom_gpu_name3 = ""
    custom_gpu_name4 = ""
    custom_gpu_name5 = ""
  '';

  # Rose Pine theme for btop
  home.file.".config/btop/themes/rose-pine.theme".text = ''
    # Rose Pine theme for btop
    
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="191724"
    
    # Main text color
    theme[main_fg]="e0def4"
    
    # Title color for boxes
    theme[title]="e0def4"
    
    # Highlight color for keyboard shortcuts
    theme[hi_fg]="c4a7e7"
    
    # Background color of selected item in processes box
    theme[selected_bg]="26233a"
    
    # Foreground color of selected item in processes box
    theme[selected_fg]="e0def4"
    
    # Color of inactive/disabled text
    theme[inactive_fg]="6e6a86"
    
    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="e0def4"
    
    # Background color of the percentage meters
    theme[meter_bg]="26233a"
    
    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="e0def4"
    
    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="31748f"
    theme[mem_box]="9ccfd8"
    theme[net_box]="ebbcba"
    theme[proc_box]="f6c177"
    
    # Box divider line and small boxes line color
    theme[div_line]="6e6a86"
    
    # Temperature graph color (Green -> Yellow -> Red)
    theme[temp_start]="9ccfd8"
    theme[temp_mid]="f6c177"
    theme[temp_end]="eb6f92"
    
    # CPU graph colors (Teal -> Lavender -> Mauve)
    theme[cpu_start]="31748f"
    theme[cpu_mid]="9ccfd8"
    theme[cpu_end]="c4a7e7"
    
    # Mem/Disk free meter (Mauve -> Lavender -> Teal)
    theme[free_start]="c4a7e7"
    theme[free_mid]="9ccfd8"
    theme[free_end]="31748f"
    
    # Mem/Disk cached meter (Green -> Blue)
    theme[cached_start]="9ccfd8"
    theme[cached_mid]="31748f"
    theme[cached_end]="31748f"
    
    # Mem/Disk available meter (Red -> Orange -> Green)
    theme[available_start]="eb6f92"
    theme[available_mid]="f6c177"
    theme[available_end]="9ccfd8"
    
    # Mem/Disk used meter (Green -> Orange -> Red)
    theme[used_start]="9ccfd8"
    theme[used_mid]="f6c177"
    theme[used_end]="eb6f92"
    
    # Download graph colors (Peach -> Red)
    theme[download_start]="ebbcba"
    theme[download_mid]="f6c177"
    theme[download_end]="eb6f92"
    
    # Upload graph colors (Green -> Peach)
    theme[upload_start]="9ccfd8"
    theme[upload_mid]="ebbcba"
    theme[upload_end]="f6c177"
    
    # Process box color gradient for threads, mem and cpu usage (Red -> Green)
    theme[process_start]="eb6f92"
    theme[process_mid]="f6c177"
    theme[process_end]="9ccfd8"
  '';
}
