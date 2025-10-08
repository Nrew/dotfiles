local M = {}

local function has_category(cat)
  return type(_G.nixCats) == "function" and _G.nixCats(cat) or false
end

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
      condition = has_category("lua"),
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "nixCats" } },
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
      condition = has_category("nix"),
      settings = {
        nixd = {
          nixpkgs = { 
            expr = _G.nixCats("nixdExtras.nixpkgs") or "import <nixpkgs> { }"
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
    tsserver = {
      condition = has_category("typescript"),
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
      end,
    },
    pyright = {
      condition = has_category("python"),
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
      condition = has_category("rust"),
      settings = { 
        ["rust-analyzer"] = { 
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        }
      },
    },
    gopls = {
      condition = has_category("go"),
      settings = { 
        gopls = { 
          analyses = { unusedparams = true },
          staticcheck = true,
          gofumpt = true,
        }
      },
    },
    clangd = {
      condition = has_category("c"),
      cmd = { "clangd", "--background-index", "--clang-tidy" },
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" }
      }),
    },
  }

  for server, config in pairs(servers) do
    if config.condition then
      lspconfig[server].setup({
        capabilities = config.capabilities or capabilities,
        on_attach = config.on_attach or on_attach,
        settings = config.settings,
        cmd = config.cmd,
      })
    end
  end

  -- Diagnostics Configuration
  vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    float = { source = "always", border = "rounded" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- LSP diagnostic signs
  local signs = { Error = "", Warn = "", Hint = "", Info = "" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M