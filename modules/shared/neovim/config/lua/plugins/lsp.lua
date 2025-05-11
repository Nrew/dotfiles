-- LSP Configuration

-- Mason setup
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'nil_ls',
    'tsserver',
    'rust_analyzer',
    'pyright',
    'gopls',
    'bashls',
    'jsonls',
    'yamlls',
    'cssls',
    'html',
    'emmet_ls',
  },
  automatic_installation = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lua LSP
require('lspconfig').lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- TypeScript
require('typescript-tools').setup({
  capabilities = capabilities,
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
  },
})

-- Rust
require('rust-tools').setup({
  server = {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
})

-- Other LSPs
local servers = {
  'nil_ls', 'pyright', 'gopls', 'bashls',
  'jsonls', 'yamlls', 'cssls', 'html', 'emmet_ls'
}

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup({
    capabilities = capabilities,
  })
end

-- Null-ls setup for formatters and linters
require('null-ls').setup({
  sources = {
    -- Add your preferred formatters and linters here
  },
})
