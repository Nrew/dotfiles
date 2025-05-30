local utils = require("core.utils")
local M = {}

function M.setup()
  local telescope = utils.safe_require("telescope")
  local actions = utils.safe_require("telescope.actions")
  
  -- INVARIANT: Both telescope and actions must be available
  assert(telescope, "CRITICAL INVARIANT FAILED: telescope is required")
  assert(actions, "CRITICAL INVARIANT FAILED: telescope.actions is required")
  assert(type(telescope.setup) == "function", "INVARIANT FAILED: telescope.setup must be function")
  assert(type(telescope.load_extension) == "function", "INVARIANT FAILED: telescope.load_extension must be function")

  -- INVARIANT: Essential actions must exist
  local required_actions = { "close", "move_selection_next", "move_selection_previous", "send_to_qflist", "open_qflist" }
  for _, action_name in ipairs(required_actions) do
    assert(actions[action_name], string.format("INVARIANT FAILED: actions.%s must exist", action_name))
  end

  local config = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = { prompt_position = "top", preview_width = 0.6 },
        width = 0.9,
        height = 0.8,
      },
      file_ignore_patterns = { "%.git/", "node_modules/", "__pycache__/" },
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        },
      },
    },
    pickers = {
      find_files = { theme = "dropdown", previewer = false },
      buffers = { theme = "dropdown", previewer = false },
      live_grep = { theme = "ivy" },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
      },
    },
  }

  -- INVARIANT: Config structure must be valid
  assert(type(config.defaults) == "table", "INVARIANT FAILED: defaults must be table")
  assert(type(config.defaults.mappings) == "table", "INVARIANT FAILED: mappings must be table")
  assert(type(config.defaults.mappings.i) == "table", "INVARIANT FAILED: insert mode mappings must be table")
  assert(type(config.pickers) == "table", "INVARIANT FAILED: pickers must be table")
  assert(type(config.extensions) == "table", "INVARIANT FAILED: extensions must be table")

  local success = utils.safe_call(function()
    telescope.setup(config)
    
    -- INVARIANT: FZF extension must be loadable if configured
    local fzf_available = pcall(telescope.load_extension, "fzf")
    if not fzf_available then
      vim.notify("FZF extension not available, telescope may be slower", vim.log.levels.WARN)
    end
  end, "telescope setup")

  -- INVARIANT: Telescope setup must succeed
  assert(success, "CRITICAL INVARIANT FAILED: telescope setup must succeed")
end

return M