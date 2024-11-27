# modules/cli/neovim/theme.nix
{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    extraConfig = ''
      " Theme Configuration
      set background=dark
      colorscheme wal

      " Transparent background
      highlight Normal guibg=none
      highlight NonText guibg=none
      highlight LineNr guibg=none
      highlight Folded guibg=none
      highlight NeogitDiffContextHighlight guibg=none
      highlight SignColumn guibg=none
    '';
  };

  # Create pywal template for Neovim
  home.file.".config/wal/templates/colors-wal.vim".text = ''
    " Special
    let g:terminal_color_foreground = "{foreground}"
    let g:terminal_color_background = "{background}"
    let g:terminal_color_cursor = "{cursor}"

    " Colors
    let g:terminal_color_0 = "{color0}"
    let g:terminal_color_1 = "{color1}"
    let g:terminal_color_2 = "{color2}"
    let g:terminal_color_3 = "{color3}"
    let g:terminal_color_4 = "{color4}"
    let g:terminal_color_5 = "{color5}"
    let g:terminal_color_6 = "{color6}"
    let g:terminal_color_7 = "{color7}"
    let g:terminal_color_8 = "{color8}"
    let g:terminal_color_9 = "{color9}"
    let g:terminal_color_10 = "{color10}"
    let g:terminal_color_11 = "{color11}"
    let g:terminal_color_12 = "{color12}"
    let g:terminal_color_13 = "{color13}"
    let g:terminal_color_14 = "{color14}"
    let g:terminal_color_15 = "{color15}"

    " Background
    hi Normal guibg={background} guifg={foreground}

    " UI Elements
    hi LineNr guifg={color8}
    hi CursorLineNr guifg={color4}
    hi SignColumn guibg=none
    hi VertSplit guifg={color8}
    hi StatusLine guibg={color8} guifg={foreground}
    hi StatusLineNC guibg={color0} guifg={color8}
    hi Search guibg={color3} guifg={background}
    hi IncSearch guibg={color3} guifg={background}
    hi Pmenu guibg={background} guifg={foreground}
    hi PmenuSel guibg={color4} guifg={background}
    hi PmenuThumb guibg={color4}
    hi PmenuSbar guibg={color8}

    " Syntax Highlighting
    hi Comment guifg={color8}
    hi Constant guifg={color4}
    hi String guifg={color2}
    hi Character guifg={color2}
    hi Number guifg={color3}
    hi Boolean guifg={color3}
    hi Float guifg={color3}
    hi Identifier guifg={color5}
    hi Function guifg={color4}
    hi Statement guifg={color1}
    hi Conditional guifg={color1}
    hi Repeat guifg={color1}
    hi Label guifg={color1}
    hi Operator guifg={color1}
    hi Keyword guifg={color1}
    hi Exception guifg={color1}
    hi PreProc guifg={color6}
    hi Include guifg={color6}
    hi Define guifg={color6}
    hi Macro guifg={color6}
    hi Type guifg={color3}
    hi StorageClass guifg={color3}
    hi Structure guifg={color3}
    hi Typedef guifg={color3}
    hi Special guifg={color5}
    hi Tag guifg={color4}
    hi Delimiter guifg={foreground}
    hi SpecialComment guifg={color8}
    hi Debug guifg={color5}
    hi Todo guifg={background} guibg={color1}

    " Git
    hi DiffAdd guibg={color2} guifg={background}
    hi DiffChange guibg={color3} guifg={background}
    hi DiffDelete guibg={color1} guifg={background}
    hi DiffText guibg={color4} guifg={background}

    " LSP
    hi DiagnosticError guifg={color1}
    hi DiagnosticWarn guifg={color3}
    hi DiagnosticInfo guifg={color4}
    hi DiagnosticHint guifg={color6}
    hi LspReferenceText guibg={color8}
    hi LspReferenceRead guibg={color8}
    hi LspReferenceWrite guibg={color8}
  '';

  # Add helper script for reloading Neovim colors
  home.packages = with pkgs; [
    (writeShellScriptBin "nvim-reload-colors" ''
      #!/usr/bin/env bash
      # Reload colors in all Neovim instances
      for server in $(nvr --serverlist); do
        nvr --servername "$server" -cc 'source $MYVIMRC | colorscheme wal'
      done
    '')
  ];
}

