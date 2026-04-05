{ }:

{
  catppuccin.btop.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_tree = true;
      vim_keys = true;
    };
  };
}
