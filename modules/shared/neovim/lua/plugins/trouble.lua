local M = {}

-- Helper function to safely check nixCats
local function safe_nixcats(category)
  if type(nixCats) == "function" then
    return nixCats(category)
  end
  return false
end

function M.setup()
  if not safe_nixcats("general") then
    return
  end
  
  require("trouble").setup({
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    mode = "workspace_diagnostics",
    severity = nil,
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    cycle_results = true,
    action_keys = {
      close = "q",
      cancel = "<esc>",
      refresh = "r",
      jump = { "<cr>", "<tab>" },
      open_split = { "<c-x>" },
      open_vsplit = { "<c-v>" },
      open_tab = { "<c-t>" },
      jump_close = { "o" },
      toggle_mode = "m",
      switch_severity = "s",
      toggle_preview = "P",
      hover = "K",
      preview = "p",
      close_folds = { "zM", "zm" },
      open_folds = { "zR", "zr" },
      toggle_fold = { "zA", "za" },
      previous = "k",
      next = "j"
    },
    multiline = true,
    indent_lines = true,
    win_config = { border = "single" },
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    auto_fold = false,
    auto_jump = { "lsp_definitions" },
    include_declaration = {
      "lsp_references",
      "lsp_implementations",
      "lsp_definitions"
    },
    signs = {
      error = "",
      warning = "",
      hint = "",
      information = "",
      other = ""
    },
    use_diagnostic_signs = false
  })
end

return M