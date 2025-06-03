local utils = require("core.utils")
local M = {}

function M.load()
  return {
    event = "InsertEnter"
  }
end

function M.setup()
  -- INVARIANT: nixCats must be available
  assert(utils.has_category, "INVARIANT FAILED: utils.has_category function not available")
  
  local blink = utils.safe_require("blink.cmp")
  assert(blink, "CRITICAL INVARIANT FAILED: blink.cmp is required for completion")
  assert(type(blink.setup) == "function", "INVARIANT FAILED: blink.cmp.setup must be function")

  local config = {
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "mono" },
    
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = { min_keyword_length = 4 },
        snippets = { min_keyword_length = 2 },
      },
    },
    
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { 
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "rounded" },
      },
      menu = { border = "rounded" },
    },
    
    signature = { 
      enabled = true,
      window = { border = "rounded" },
    },
  }

  -- INVARIANT: Config must be valid table structure
  assert(type(config) == "table", "INVARIANT FAILED: blink config must be table")
  assert(type(config.sources) == "table", "INVARIANT FAILED: sources config must be table")
  assert(type(config.sources.default) == "table", "INVARIANT FAILED: default sources must be table")
  assert(#config.sources.default > 0, "INVARIANT FAILED: must have at least one completion source")

  local success = utils.safe_call(function() 
    blink.setup(config) 
  end, "blink.cmp setup")
  
  -- INVARIANT: Setup must succeed for completion to work
  assert(success, "CRITICAL INVARIANT FAILED: blink.cmp setup must succeed")
end

return M
