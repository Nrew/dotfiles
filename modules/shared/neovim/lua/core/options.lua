local M = {}

-- Constants
local CONFIG = {
  UNDO_DIR = "undodir",
  SCROLLOFF = 8,
  PUMP = { HEIGHT = 10, BLEND = 10 },
  TIMING = { UPDATE = 100, TIMEOUT = 300 },
  NUMBER_WIDTH = 2,
}

local function ensure_directory(path)
  if vim.fn.isdirectory(vim.fn.expand(path)) == 0 then
    local status, err = pcall(vim.fn.mkdir, path, "p")
    if not status then
      vim.notify(string.format("Failed to create directory: %s (%s)", path, tostring(err)), vim.log.levels.WARN)
      return false
    end
  end
  return true
end

local function set_options(option_groups)
  local opt, g = vim.opt, vim.g
  
  for group_name, options in pairs(option_groups) do
    for key, value in pairs(options) do
      if group_name == "global" then
        g[key] = value
      else
        opt[key] = value
      end
    end
  end
end

local function get_option_groups()
  local undo_path = vim.fn.stdpath("data") .. "/" .. CONFIG.UNDO_DIR
  if not undo_path or #undo_path == 0 then
    error("Unable to determine data directory path")
  end
  ensure_directory(undo_path)
  
  return {
    global = {
      mapleader = " ",
      maplocalleader = " ",
      have_nerd_fonts = true,
    },
    
    core = {
      mouse = "a",
      clipboard = "unnamedplus",
      swapfile = false,
      backup = false,
      undofile = true,
      undodir = undo_path,
      confirm = true,
      autowriteall = true,
      hidden = true,
      updatetime = CONFIG.TIMING.UPDATE,
      timeoutlen = CONFIG.TIMING.TIMEOUT,
    },
    
    ui = {
      termguicolors = true,
      number = true,
      relativenumber = true,
      numberwidth = CONFIG.NUMBER_WIDTH,
      signcolumn = "yes:1",
      colorcolumn = "80,100",
      wrap = true,
      linebreak = true,
      breakindent = true,
      showbreak = "↪ ",
      scrolloff = CONFIG.SCROLLOFF,
      sidescrolloff = CONFIG.SCROLLOFF,
      pumheight = CONFIG.PUMP.HEIGHT,
      pumblend = CONFIG.PUMP.BLEND,
      showmode = false,
      showtabline = 2,
      laststatus = 3,
      cmdheight = 1,
      showcmd = false,
      fillchars = { eob = " ", diff = "╱", vert = "│", fold = " " },
    },
    
    editing = {
      ignorecase = true,
      smartcase = true,
      hlsearch = true,
      incsearch = true,
      inccommand = "nosplit",
      completeopt = { "menuone", "noselect", "preview" },
      expandtab = true,
      tabstop = 2,
      softtabstop = 2,
      shiftwidth = 2,
      autoindent = true,
      smartindent = true,
      list = true,
      listchars = { tab = "󰌒 ", trail = "·", nbsp = "␣", extends = "⟩", precedes = "⟨" },
      splitbelow = true,
      splitright = true,
      splitkeep = "screen",
      jumpoptions = "view",
      foldmethod = "expr",
      foldexpr = "nvim_treesitter#foldexpr()",
      foldlevel = 99,
      foldlevelstart = 99,
      foldenable = true,
      foldcolumn = "0",
    },
  }
end

function M.setup()
  if not vim.opt or not vim.g or type(vim.fn.stdpath) ~= "function" then
    error("CRITICAL INVARIANT FAILED: required vim APIs not available")
  end
  
  local option_groups = get_option_groups()
  set_options(option_groups)
  
  -- Handle special cases
  vim.opt.isfname:append("@-@")
  vim.opt.shortmess:append("sIc")
  
  vim.notify("NixCats options configured", vim.log.levels.INFO)
end

function M.validate_setup()
  local checks = {
    { vim.g.mapleader == " ", "mapleader not set correctly" },
    { vim.opt.undofile:get(), "undofile not enabled" },
    { vim.opt.updatetime:get() == CONFIG.TIMING.UPDATE, "updatetime not set correctly" },
    { vim.opt.scrolloff:get() >= CONFIG.SCROLLOFF, "scrolloff too low" },
  }
  
  local errors = {}
  for _, check in ipairs(checks) do
    if not check[1] then
      table.insert(errors, check[2])
    end
  end
  
  if #errors > 0 then
    vim.notify("Options validation failed: " .. table.concat(errors, ", "), vim.log.levels.ERROR)
    return false
  end
  
  return true
end

function M.get_config_summary()
  return {
    leader = vim.g.mapleader,
    updatetime = vim.opt.updatetime:get(),
    scrolloff = vim.opt.scrolloff:get(),
    undofile = vim.opt.undofile:get(),
    termguicolors = vim.opt.termguicolors:get(),
    relativenumber = vim.opt.relativenumber:get(),
  }
end

return M
