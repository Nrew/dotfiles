return {
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        which_key = true,
        mason = true,
        notify = true,
        noice = true,
        mini = {
          enabled = true,
          indentscope_color = "lavender",
        },
      },
    },
  },

  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "main",
      dark_variant = "main",
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    },
  },

  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    },
  },

  -- Nord
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
    end,
  },

  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "",
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
  },

  -- LazyVim colorscheme configuration
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
