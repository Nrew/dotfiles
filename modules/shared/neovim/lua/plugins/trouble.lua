local utils = require("core.utils")
local M = {}

function M.load()
  return {
    keys = {
      { "<leader>xx", desc = "Toggle Trouble" },
      { "<leader>xw", desc = "Workspace Diagnostics" },
      { "<leader>xd", desc = "Document Diagnostics" },
      { "gR",         desc = "LSP References" },
    }
  }
end

function M.setup()
  local trouble = utils.safe_require("trouble")
  if not trouble then return end

  utils.safe_call(function()
    trouble.setup({
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
        jump = { "<cr>", "<tab>", "<2-leftmouse>" },
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = { "o" },
        toggle_mode = "m",
        switch_severity = "s",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        open_code_href = "c",
        close_folds = { "zM", "zm" },
        open_folds = { "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
        help = "?",
      },
      multiline = true,
      indent_lines = true,
      win_config = { border = "rounded" },
      auto_open = false,
      auto_close = false,
      auto_preview = true,
      auto_fold = false,
      auto_jump = { "lsp_definitions" },
      include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" },
      signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "",
      },
      use_diagnostic_signs = false,
    })

    utils.keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
    utils.keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
    utils.keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })
    utils.keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location List" })
    utils.keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix" })
    utils.keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References" })
  end, "trouble setup")
end

return M
