local M = {}

function M.setup()
  local ok, lualine = pcall(require, "lualine")
  if not ok then return end

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = "rose-pine",
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