local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- Formatters
        null_ls.builtins.formatting.prettier.with({
            command = "prettierd",
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.nixfmt,
        
        -- Linters
        null_ls.builtins.diagnostics.eslint_d,
    },
})