local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "rose-pine",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        {
          "filename",
          file_status = true,
          newfile_status = false,
          path = 1,
        },
      },
      lualine_x = {
        {
          "encoding",
          show_bomb = true,
          cond = function()
            return vim.bo.encoding ~= "utf-8"
          end,
        },
        {
          "fileformat",
          symbols = {
            unix = "",
            dos = "",
            mac = "",
          },
          cond = function()
            return vim.bo.fileformat ~= "unix"
          end,
        },
        "filetype",
      },
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
    
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {
      "neo-tree",
      "quickfix",
      "trouble",
    },
  })
end

return M
