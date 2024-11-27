local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<Esc>"] = actions.close,
            },
        },
        file_ignore_patterns = {
            "node_modules",
            ".git",
            "target",
            "dist",
            "build",
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
        },
    },
})

telescope.load_extension('fzf')
telescope.load_extension('file_browser')