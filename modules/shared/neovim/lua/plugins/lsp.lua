local M = {}

local function on_attach(client, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr, silent = true }

  map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
  map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
  map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
  map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
  map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
  map("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
  map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
  map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
  map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format code" }))

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

function M.setup()
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then
    vim.notify("lspconfig not found", vim.log.levels.ERROR)
    return
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local blink_ok, blink = pcall(require, "blink.cmp")
  if blink_ok and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" }
  }

  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false
          },
          telemetry = { enable = false },
          format = { enable = false },
        },
      },
    },
    nixd = {
      settings = {
        nixd = {
          nixpkgs = { 
            expr = "import <nixpkgs> { }"
          },
          formatting = {
            command = { "nixfmt" }
          },
          options = {
            nixos = {
              expr = string.format('(builtins.getFlake "%s/.config/dotfiles").nixosConfigurations.default.options', vim.env.HOME)
            },
            ["nix-darwin"] = {
              expr = string.format('(builtins.getFlake "%s/.config/dotfiles").darwinConfigurations.owl.options', vim.env.HOME)
            },
            home_manager = {
              expr = string.format('(builtins.getFlake "%s/.config/dotfiles").homeConfigurations.default.options', vim.env.HOME)
            }
          }
        }
      },
    },
    ts_ls = {
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
      end,
    },
    pyright = {
      settings = { 
        python = { 
          analysis = { 
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          }
        }
      },
    },
    rust_analyzer = {
      settings = { 
        ["rust-analyzer"] = { 
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        }
      },
    },
    gopls = {
      settings = { 
        gopls = { 
          analyses = { unusedparams = true },
          staticcheck = true,
          gofumpt = true,
        }
      },
    },
    clangd = {
      cmd = { "clangd", "--background-index", "--clang-tidy" },
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" }
      }),
    },
  }

  for server, config in pairs(servers) do
    lspconfig[server].setup({
      capabilities = config.capabilities or capabilities,
      on_attach = config.on_attach or on_attach,
      settings = config.settings,
      cmd = config.cmd,
    })
  end

  -- Diagnostics Configuration with modern sign API
  vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    float = { source = "always", border = "rounded" },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M
