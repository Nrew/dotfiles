local M = {}

function M.setup()
  local ok, neo_tree = pcall(require, "neo-tree")
  if not ok then return end

  neo_tree.setup({
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,

    default_component_configs = {
      indent = { indent_size = 2, padding = 1 },
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
end

return M