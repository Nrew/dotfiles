local utils = require("core.utils")
local M = {}

function M.load()
  return {
    keys = {
      { "<leader>e", desc = "Toggle file explorer" },
      { "<leader>o", desc = "Focus file explorer"  },
    }
  }
end

function M.setup()
  local neo_tree = utils.safe_require("neo-tree")
  if not neo_tree then return end

  utils.safe_call(function()
    neo_tree.setup({
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      
      default_component_configs = {
        indent = { indent_size = 2, padding = 1 },
        icon = { folder_closed = "", folder_open = "", folder_empty = "" },
        git_status = {
          symbols = {
            added = "", modified = "", deleted = "✖", renamed = "󰁕",
            untracked = "", ignored = "", unstaged = "󰄱", staged = "",
          },
        },
      },
      
      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<cr>"] = "open",
          ["s"] = "open_vsplit",
          ["S"] = "open_split",
          ["t"] = "open_tabnew",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["R"] = "refresh",
        },
      },
      
      filesystem = {
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = { ".DS_Store", "thumbs.db" },
        },
        follow_current_file = { enabled = false },
        use_libuv_file_watcher = false,
      },
    })
    
    utils.keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
    utils.keymap("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus file explorer" })
  end, "neo-tree setup")
end

return M
