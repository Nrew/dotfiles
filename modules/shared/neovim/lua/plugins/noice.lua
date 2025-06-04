local M = {}

function M.setup()
  local ok, noice = pcall(require, "noice")
  if not ok then return end

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
end

return M