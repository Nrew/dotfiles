local utils = require("core.utils")
local M = {}

function M.load()
  return {
    event = "DeferredUIEnter",
  }
end

function M.setup()
  local noice = utils.safe_require("noice")
  if not noice then return end

  utils.safe_call(function()
    noice.setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        { filter = { event = "msg_show", find = "%d+L, %d+B" }, view = "mini" },
        { filter = { event = "msg_show", find = "; after #%d+" }, view = "mini" },
        { filter = { event = "msg_show", find = "; before #%d+" }, view = "mini" },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    })
  end, "noice setup")
end

return M
