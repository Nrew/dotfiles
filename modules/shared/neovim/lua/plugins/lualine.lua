local M = {}

function M.setup()
  local ok, lualine = pcall(require, "lualine")
  if not ok then return end

  -- Load dynamic palette
  local palette_ok, palette_loader = pcall(require, "theme.palette")
  local palette = palette_ok and palette_loader.get() or {
    base = "#191724",
    mantle = "#1f1d2e",
    surface = "#26233a",
    overlay = "#403d52",
    text = "#e0def4",
    subtext0 = "#908caa",
    muted = "#6e6a86",
    primary = "#c4a7e7",
    secondary = "#ebbcba",
    red = "#eb6f92",
    green = "#9ccfd8",
    yellow = "#f6c177",
    blue = "#31748f",
    cyan = "#31748f",
  }

  -- Create a custom lualine theme from the palette
  local custom_theme = {
    normal = {
      a = { bg = palette.primary, fg = palette.base, gui = "bold" },
      b = { bg = palette.surface, fg = palette.text },
      c = { bg = palette.base, fg = palette.subtext0 },
    },
    insert = {
      a = { bg = palette.green, fg = palette.base, gui = "bold" },
      b = { bg = palette.surface, fg = palette.text },
    },
    visual = {
      a = { bg = palette.secondary, fg = palette.base, gui = "bold" },
      b = { bg = palette.surface, fg = palette.text },
    },
    replace = {
      a = { bg = palette.red, fg = palette.base, gui = "bold" },
      b = { bg = palette.surface, fg = palette.text },
    },
    command = {
      a = { bg = palette.yellow, fg = palette.base, gui = "bold" },
      b = { bg = palette.surface, fg = palette.text },
    },
    inactive = {
      a = { bg = palette.mantle, fg = palette.muted },
      b = { bg = palette.mantle, fg = palette.muted },
      c = { bg = palette.mantle, fg = palette.muted },
    },
  }

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = custom_theme,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = {}, winbar = {} },
      always_divide_middle = true,
      globalstatus = true,
      refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "neo-tree", "lazy", "trouble" },
  })
end

return M