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
  -- Setup capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local blink_ok, blink = pcall(require, "blink.cmp")
  if blink_ok and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" }
  }

  -- Configure LSP servers using vim.lsp.config
  vim.lsp.config["*"] = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  -- Lua Language Server
  vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
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
  }

  -- Nix Language Server
  vim.lsp.config.nixd = {
    cmd = { "nixd" },
    root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" },
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
  }

  -- TypeScript/JavaScript Language Server
  vim.lsp.config.ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      on_attach(client, bufnr)
    end,
  }

  -- Python Language Server
  vim.lsp.config.pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    settings = { 
      python = { 
        analysis = { 
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        }
      }
    },
  }

  -- Rust Language Server
  vim.lsp.config.rust_analyzer = {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = { 
      ["rust-analyzer"] = { 
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
      }
    },
  }

  -- Go Language Server
  vim.lsp.config.gopls = {
    cmd = { "gopls" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = { 
      gopls = { 
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      }
    },
  }

  -- C/C++ Language Server
  vim.lsp.config.clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      offsetEncoding = { "utf-16" }
    }),
  }

  -- Enable LSP servers based on filetype
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function(args)
      vim.lsp.enable("lua_ls", args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "nix" },
    callback = function(args)
      vim.lsp.enable("nixd", args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    callback = function(args)
      vim.lsp.enable("ts_ls", args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function(args)
      vim.lsp.enable("pyright", args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust" },
    callback = function(args)
      vim.lsp.enable("rust_analyzer", args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "gomod", "gowork", "gotmpl" },
    callback = function(args)
      vim.lsp.enable("gopls", args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    callback = function(args)
      vim.lsp.enable("clangd", args.buf)
    end,
  })

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
