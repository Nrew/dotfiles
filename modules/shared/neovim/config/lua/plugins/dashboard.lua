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

      -- Dark YoRHa terminal window: map Normal → NierDashNormal for black bg
      opts.dashboard.win = opts.dashboard.win or {}
      opts.dashboard.win.style = "dashboard"
      opts.dashboard.wo = {
        winhighlight = table.concat({
          "Normal:NierDashNormal",
          "NormalFloat:NierDashNormal",
          "NormalNC:NierDashNormal",
          "EndOfBuffer:NierDashNormal",
          "SignColumn:NierDashNormal",
        }, ","),
      }

      opts.dashboard.preset = {
        keys = {
          { icon = "  ", key = "n", desc = "New File",        action = ":ene | startinsert" },
          { icon = "  ", key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "  ", key = "r", desc = "Recent Files",    action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "  ", key = "g", desc = "Find Text",       action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "  ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "  ", key = "l", desc = "Lazy",            action = ":Lazy" },
          { icon = "  ", key = "q", desc = "Quit",            action = ":qa" },
        },
      }

      opts.dashboard.sections = {
        { padding = 2 },
        {
          text = {
            { "    ╔══════════════════════════════════════╗\n", hl = "NierDashAscii" },
            { "    ║                                      ║\n", hl = "NierDashAscii" },
            { "    ║   Y  o  R  H  a  │  N  o  .  2      ║\n", hl = "NierDashHeader" },
            { "    ║                                      ║\n", hl = "NierDashAscii" },
            { "    ║   A n d r o i d     T y p e  B      ║\n", hl = "NierDashAscii" },
            { "    ║   B a t t l e   U n i t   2 B       ║\n", hl = "NierDashAscii" },
            { "    ║                                      ║\n", hl = "NierDashAscii" },
            { "    ╚══════════════════════════════════════╝\n", hl = "NierDashAscii" },
          },
          align = "center",
          padding = 1,
        },
        {
          text = { { "  ══════════════════════════════════════  \n", hl = "NierDashSeparator" } },
          align = "center",
        },
        { padding = 1 },
        { section = "keys", gap = 0, padding = 1 },
        { padding = 1 },
        {
          text = { { "  ══════════════════════════════════════  \n", hl = "NierDashSeparator" } },
          align = "center",
        },
        {
          text = { { '"' .. quote .. '"', hl = "NierDashFooter" } },
          align = "center",
          padding = 1,
        },
        { section = "startup", align = "center", hl = "NierDashFooter" },
      }

      return opts
    end,
  },
}
