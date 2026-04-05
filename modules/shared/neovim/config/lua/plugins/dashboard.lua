return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local quotes = {
        "Everything that lives is designed to end.",
        "Glory to Mankind.",
        "We are perpetually trapped in a never-ending spiral of life and death.",
        "Is a piece of data capable of feeling joy?",
        "No matter how many times I die, I will return.",
        "Nothing is true. Everything is permitted. ...No. That's not right either.",
      }
      math.randomseed(os.time())
      local quote = quotes[math.random(#quotes)]

      opts.dashboard = opts.dashboard or {}
      opts.dashboard.enabled = true

      -- Set the ASCII header string (rendered by { section = "header" }).
      -- SnacksDashboardHeader → NierDashHeader in colors/theme.lua.
      -- Do NOT replace the whole preset — LazyVim sets preset.pick here too.
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = table.concat({
        "╔══════════════════════════════════════╗",
        "║                                      ║",
        "║   Y  o  R  H  a  │  N  o  .  2      ║",
        "║                                      ║",
        "║   A n d r o i d     T y p e  B      ║",
        "║   B a t t l e   U n i t   2 B       ║",
        "║                                      ║",
        "╚══════════════════════════════════════╝",
      }, "\n")

      opts.dashboard.preset.keys = {
        { icon = "  ", key = "n", desc = "New File",        action = ":ene | startinsert" },
        { icon = "  ", key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
        { icon = "  ", key = "r", desc = "Recent Files",    action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = "  ", key = "g", desc = "Find Text",       action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = "  ", key = "s", desc = "Restore Session", section = "session" },
        { icon = "  ", key = "l", desc = "Lazy",            action = ":Lazy" },
        { icon = "  ", key = "q", desc = "Quit",            action = ":qa" },
      }

      opts.dashboard.sections = {
        { section = "header", padding = 2 },
        { text = "  ══════════════════════════════════════  ", hl = "NierDashSeparator", align = "center", padding = 1 },
        { section = "keys", gap = 0, padding = 1 },
        { text = "  ══════════════════════════════════════  ", hl = "NierDashSeparator", align = "center", padding = 1 },
        { text = '"' .. quote .. '"',                         hl = "NierDashFooter",    align = "center", padding = 1 },
        { section = "startup",                                hl = "NierDashFooter" },
      }

      return opts
    end,
  },
}
