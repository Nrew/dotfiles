-- NieR:Automata colorscheme for Neovim
-- Palette sourced from XadillaX/vim-automata-theme and official NieR:Automata UI
-- Designed by Hisayoshi Kijima (PlatinumGames): "systematic and sterile, but also beautiful"
-- Directive: "nice, warm beige — avoid a wide range of colors"

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.background = "light"
vim.g.colors_name = "theme"

local c = {
  -- Shades: light background → dark foreground (vim-automata-theme shade0–shade7)
  shade0 = "#dad4bb", -- bg: warm parchment
  shade1 = "#cac4ad", -- bg_soft: cursor line, popups
  shade2 = "#b9b49f", -- bg_mid: comments, line numbers
  shade3 = "#a9a491", -- fg_dim: muted UI text
  shade4 = "#999482", -- fg_mid2
  shade5 = "#898474", -- fg_mid: statusline, titles
  shade6 = "#787466", -- fg: primary text
  shade7 = "#686458", -- fg_dark: bold text
  -- Accents (vim-automata-theme accent0–accent7)
  accent0 = "#cd664d", -- error/warning: muted red-orange (NieR's ONLY vivid color)
  accent1 = "#b4af9a", -- spell rare
  accent2 = "#3ba99f", -- identifier/function: teal
  accent3 = "#727b59", -- constant/string: olive
  accent4 = "#4e4c43", -- special/character: dark
  accent5 = "#5e6666", -- statement/keyword: muted slate
  accent6 = "#b26f5f", -- preproc/macro: mauve
  accent7 = "#50403c", -- type: deep warm brown
  -- YoRHa terminal dark mode (dashboard / loading screen aesthetic)
  term_bg  = "#0a0a0a",
  term_bg2 = "#1a1a1a",
  term_fg  = "#e8e6e3",
  term_dim = "#a09890",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Core ──────────────────────────────────────────────────────────────────
hi("Normal",           { fg = c.shade6, bg = c.shade0 })
hi("NormalFloat",      { fg = c.shade6, bg = c.shade1 })
hi("NormalNC",         { fg = c.shade5, bg = c.shade0 })
hi("NormalSB",         { fg = c.shade6, bg = c.shade1 })
hi("Visual",           { bg = c.shade2 })
hi("VisualNOS",        { bg = c.shade2 })
hi("Search",           { fg = c.shade0, bg = c.accent2 })
hi("IncSearch",        { fg = c.shade0, bg = c.accent2 })
hi("CurSearch",        { fg = c.shade0, bg = c.accent0 })
hi("CursorLine",       { bg = c.shade1 })
hi("CursorColumn",     { bg = c.shade1 })
hi("CursorLineNr",     { fg = c.shade5, bold = true })
hi("ColorColumn",      { bg = c.shade1 })
hi("LineNr",           { fg = c.shade3 })
hi("SignColumn",       { fg = c.shade3, bg = c.shade0 })
hi("Folded",           { fg = c.shade4, bg = c.shade1 })
hi("FoldColumn",       { fg = c.shade3, bg = c.shade0 })
hi("VertSplit",        { fg = c.shade3 })
hi("WinSeparator",     { fg = c.shade3 })
hi("StatusLine",       { fg = c.shade5, bg = c.shade1 })
hi("StatusLineNC",     { fg = c.shade3, bg = c.shade1 })
hi("TabLine",          { fg = c.shade5, bg = c.shade1 })
hi("TabLineFill",      { fg = c.shade3, bg = c.shade1 })
hi("TabLineSel",       { fg = c.shade0, bg = c.shade6, bold = true })
hi("Pmenu",            { fg = c.shade6, bg = c.shade1 })
hi("PmenuSel",         { fg = c.shade0, bg = c.shade6 })
hi("PmenuSbar",        { bg = c.shade2 })
hi("PmenuThumb",       { bg = c.shade4 })
hi("WildMenu",         { fg = c.shade0, bg = c.accent5 })
hi("MatchParen",       { fg = c.accent0, bold = true })
hi("NonText",          { fg = c.shade2 })
hi("SpecialKey",       { fg = c.shade2 })
hi("Conceal",          { fg = c.shade3 })
hi("Directory",        { fg = c.accent5 })
hi("Title",            { fg = c.shade5, bold = true })
hi("Question",         { fg = c.shade7 })
hi("MoreMsg",          { fg = c.accent4 })
hi("ModeMsg",          { fg = c.shade6, bold = true })
hi("MsgArea",          { fg = c.shade6 })
hi("ErrorMsg",         { fg = c.shade0, bg = c.accent0 })
hi("WarningMsg",       { fg = c.accent0 })
hi("QuickFixLine",     { bg = c.shade1 })

-- ── Syntax ────────────────────────────────────────────────────────────────
hi("Comment",          { fg = c.shade2, italic = true })
hi("Constant",         { fg = c.accent3 })
hi("String",           { fg = c.accent3 })
hi("Character",        { fg = c.accent4 })
hi("Number",           { fg = c.accent3 })
hi("Boolean",          { fg = c.accent3 })
hi("Float",            { fg = c.accent3 })
hi("Identifier",       { fg = c.accent2 })
hi("Function",         { fg = c.accent2 })
hi("Statement",        { fg = c.accent5 })
hi("Keyword",          { fg = c.accent5 })
hi("Conditional",      { fg = c.accent5 })
hi("Repeat",           { fg = c.accent5 })
hi("Label",            { fg = c.accent5 })
hi("Operator",         { fg = c.shade6 })
hi("Exception",        { fg = c.accent0 })
hi("PreProc",          { fg = c.accent6 })
hi("Include",          { fg = c.accent6 })
hi("Define",           { fg = c.accent6 })
hi("Macro",            { fg = c.accent6 })
hi("PreCondit",        { fg = c.accent6 })
hi("Type",             { fg = c.accent7 })
hi("StorageClass",     { fg = c.accent7 })
hi("Structure",        { fg = c.accent7 })
hi("Typedef",          { fg = c.accent7 })
hi("Special",          { fg = c.accent4 })
hi("SpecialComment",   { fg = c.shade3 })
hi("Delimiter",        { fg = c.shade5 })
hi("Underlined",       { fg = c.accent5, underline = true })
hi("Error",            { fg = c.shade0, bg = c.accent0 })
hi("Todo",             { fg = c.shade0, bg = c.accent0, bold = true })

-- ── Diagnostics ───────────────────────────────────────────────────────────
hi("DiagnosticError",               { fg = c.accent0 })
hi("DiagnosticWarn",                { fg = c.accent6 })
hi("DiagnosticInfo",                { fg = c.accent2 })
hi("DiagnosticHint",                { fg = c.shade4 })
hi("DiagnosticOk",                  { fg = c.accent3 })
hi("DiagnosticVirtualTextError",    { fg = c.accent0, bg = c.shade1, italic = true })
hi("DiagnosticVirtualTextWarn",     { fg = c.accent6, bg = c.shade1, italic = true })
hi("DiagnosticVirtualTextInfo",     { fg = c.accent2, bg = c.shade1, italic = true })
hi("DiagnosticVirtualTextHint",     { fg = c.shade4,  bg = c.shade1, italic = true })
hi("DiagnosticUnderlineError",      { sp = c.accent0, undercurl = true })
hi("DiagnosticUnderlineWarn",       { sp = c.accent6, undercurl = true })
hi("DiagnosticUnderlineInfo",       { sp = c.accent2, undercurl = true })
hi("DiagnosticUnderlineHint",       { sp = c.shade4,  undercurl = true })

-- ── LSP ───────────────────────────────────────────────────────────────────
hi("LspReferenceText",               { bg = c.shade2 })
hi("LspReferenceRead",               { bg = c.shade2 })
hi("LspReferenceWrite",              { bg = c.shade2 })
hi("LspSignatureActiveParameter",    { fg = c.accent0, bold = true })

-- ── TreeSitter ────────────────────────────────────────────────────────────
hi("@variable",                { fg = c.shade6 })
hi("@variable.builtin",        { fg = c.shade5 })
hi("@variable.parameter",      { fg = c.shade6 })
hi("@variable.member",         { fg = c.shade6 })
hi("@constant",                { fg = c.accent3 })
hi("@constant.builtin",        { fg = c.accent3 })
hi("@constant.macro",          { fg = c.accent6 })
hi("@string",                  { fg = c.accent3 })
hi("@string.regexp",           { fg = c.accent4 })
hi("@string.escape",           { fg = c.accent0 })
hi("@character",               { fg = c.accent4 })
hi("@number",                  { fg = c.accent3 })
hi("@boolean",                 { fg = c.accent3 })
hi("@float",                   { fg = c.accent3 })
hi("@function",                { fg = c.accent2 })
hi("@function.builtin",        { fg = c.accent2 })
hi("@function.call",           { fg = c.accent2 })
hi("@function.macro",          { fg = c.accent6 })
hi("@function.method",         { fg = c.accent2 })
hi("@function.method.call",    { fg = c.accent2 })
hi("@constructor",             { fg = c.accent7 })
hi("@operator",                { fg = c.shade6 })
hi("@keyword",                 { fg = c.accent5 })
hi("@keyword.function",        { fg = c.accent5 })
hi("@keyword.operator",        { fg = c.shade6 })
hi("@keyword.return",          { fg = c.accent5 })
hi("@keyword.import",          { fg = c.accent6 })
hi("@conditional",             { fg = c.accent5 })
hi("@repeat",                  { fg = c.accent5 })
hi("@label",                   { fg = c.accent5 })
hi("@include",                 { fg = c.accent6 })
hi("@exception",               { fg = c.accent0 })
-- New treesitter group names (nvim-treesitter 0.9+)
hi("@keyword.conditional",     { fg = c.accent5 })
hi("@keyword.repeat",          { fg = c.accent5 })
hi("@keyword.exception",       { fg = c.accent0 })
hi("@keyword.directive",       { fg = c.accent6 })
hi("@string.special.url",      { fg = c.accent2, underline = true })
hi("@type",                    { fg = c.accent7 })
hi("@type.builtin",            { fg = c.accent7 })
hi("@type.qualifier",          { fg = c.accent7 })
hi("@type.definition",         { fg = c.accent7 })
hi("@attribute",               { fg = c.accent6 })
hi("@namespace",               { fg = c.shade5 })
hi("@module",                  { fg = c.shade5 })
hi("@comment",                 { fg = c.shade2, italic = true })
hi("@comment.todo",            { fg = c.shade0, bg = c.accent0, bold = true })
hi("@punctuation",             { fg = c.shade5 })
hi("@punctuation.bracket",     { fg = c.shade5 })
hi("@punctuation.delimiter",   { fg = c.shade5 })
hi("@punctuation.special",     { fg = c.shade4 })
hi("@tag",                     { fg = c.accent7 })
hi("@tag.attribute",           { fg = c.accent3 })
hi("@tag.delimiter",           { fg = c.shade5 })
hi("@markup.heading",          { fg = c.shade7, bold = true })
hi("@markup.bold",             { fg = c.shade6, bold = true })
hi("@markup.italic",           { fg = c.shade6, italic = true })
hi("@markup.strikethrough",    { fg = c.shade4, strikethrough = true })
hi("@markup.link",             { fg = c.accent2, underline = true })
hi("@markup.link.url",         { fg = c.accent2, underline = true })
hi("@markup.raw",              { fg = c.accent3 })
hi("@markup.list",             { fg = c.accent5 })
hi("@diff.plus",               { fg = c.accent3 })
hi("@diff.minus",              { fg = c.accent0 })
hi("@diff.delta",              { fg = c.accent2 })

-- ── Diff ──────────────────────────────────────────────────────────────────
hi("DiffAdd",    { fg = c.accent3, bg = c.shade1 })
hi("DiffChange", { fg = c.accent2, bg = c.shade1 })
hi("DiffDelete", { fg = c.accent0, bg = c.shade1 })
hi("DiffText",   { fg = c.accent2, bg = c.shade2, bold = true })

-- ── GitSigns ──────────────────────────────────────────────────────────────
hi("GitSignsAdd",      { fg = c.accent3 })
hi("GitSignsChange",   { fg = c.accent2 })
hi("GitSignsDelete",   { fg = c.accent0 })
hi("GitSignsAddNr",    { fg = c.accent3 })
hi("GitSignsChangeNr", { fg = c.accent2 })
hi("GitSignsDeleteNr", { fg = c.accent0 })
hi("GitSignsAddLn",    { bg = c.shade1 })
hi("GitSignsChangeLn", { bg = c.shade1 })

-- ── Telescope ─────────────────────────────────────────────────────────────
hi("TelescopeBorder",         { fg = c.shade3, bg = c.shade0 })
hi("TelescopePromptBorder",   { fg = c.shade4, bg = c.shade1 })
hi("TelescopeResultsBorder",  { fg = c.shade3, bg = c.shade0 })
hi("TelescopePreviewBorder",  { fg = c.shade3, bg = c.shade0 })
hi("TelescopeNormal",         { fg = c.shade6, bg = c.shade0 })
hi("TelescopePromptNormal",   { fg = c.shade6, bg = c.shade1 })
hi("TelescopeSelection",      { bg = c.shade2 })
hi("TelescopeSelectionCaret", { fg = c.accent0, bg = c.shade2 })
hi("TelescopeMatching",       { fg = c.accent0, bold = true })
hi("TelescopePromptPrefix",   { fg = c.accent0 })

-- ── nvim-cmp ──────────────────────────────────────────────────────────────
hi("CmpItemAbbr",             { fg = c.shade6 })
hi("CmpItemAbbrDeprecated",   { fg = c.shade3, strikethrough = true })
hi("CmpItemAbbrMatch",        { fg = c.accent0, bold = true })
hi("CmpItemAbbrMatchFuzzy",   { fg = c.accent0 })
hi("CmpItemKind",             { fg = c.accent2 })
hi("CmpItemKindVariable",     { fg = c.shade6 })
hi("CmpItemKindFunction",     { fg = c.accent2 })
hi("CmpItemKindKeyword",      { fg = c.accent5 })
hi("CmpItemKindText",         { fg = c.shade5 })
hi("CmpItemMenu",             { fg = c.shade3 })

-- ── Spell ─────────────────────────────────────────────────────────────────
hi("SpellBad",   { sp = c.accent0, undercurl = true })
hi("SpellCap",   { sp = c.accent2, undercurl = true })
hi("SpellLocal", { sp = c.accent4, undercurl = true })
hi("SpellRare",  { sp = c.accent1, undercurl = true })

-- ── WhichKey ──────────────────────────────────────────────────────────────
hi("WhichKey",           { fg = c.accent5 })
hi("WhichKeyGroup",      { fg = c.accent2 })
hi("WhichKeyDesc",       { fg = c.shade6 })
hi("WhichKeySeparator",  { fg = c.shade3 })
hi("WhichKeyFloat",      { bg = c.shade1 })
hi("WhichKeyBorder",     { fg = c.shade3 })
hi("WhichKeyValue",      { fg = c.shade4 })

-- ── Noice ─────────────────────────────────────────────────────────────────
hi("NoiceCmdlinePopupBorder",       { fg = c.shade3 })
hi("NoiceCmdlinePopupBorderSearch", { fg = c.accent2 })
hi("NoiceConfirmBorder",            { fg = c.shade4 })
hi("NoiceMini",                     { fg = c.shade5, bg = c.shade1 })

-- ── Snacks Picker ─────────────────────────────────────────────────────────
hi("SnacksPickerBorder",   { fg = c.shade3 })
hi("SnacksPickerMatch",    { fg = c.accent0, bold = true })
hi("SnacksPickerSelected", { bg = c.shade2 })

-- ── Snacks Dashboard (map to NierDash* so dark bg applies to all elements)
hi("SnacksDashboardNormal",       { link = "NierDashNormal" })
hi("SnacksDashboardHeader",       { link = "NierDashHeader" })
hi("SnacksDashboardFooter",       { link = "NierDashFooter" })
hi("SnacksDashboardKey",          { link = "NierDashKey" })
hi("SnacksDashboardDesc",         { link = "NierDashButton" })
hi("SnacksDashboardIcon",         { link = "NierDashButton" })
hi("SnacksDashboardTitle",        { link = "NierDashHeader" })
hi("SnacksDashboardSectionTitle", { link = "NierDashSeparator" })
hi("SnacksDashboardDir",          { link = "NierDashFooter" })
hi("SnacksDashboardSpecial",      { link = "NierDashKey" })
hi("SnacksDashboardTerminal",     { link = "NierDashFooter" })

-- ── NieR Dashboard: YoRHa terminal dark mode ──────────────────────────────
-- Used exclusively by the dashboard window via winhighlight override.
hi("NierDashNormal",    { fg = c.term_fg,  bg = c.term_bg })
hi("NierDashAscii",     { fg = c.term_dim, bg = c.term_bg })
hi("NierDashHeader",    { fg = c.term_fg,  bg = c.term_bg, bold = true })
hi("NierDashSeparator", { fg = c.shade4,   bg = c.term_bg })
hi("NierDashButton",    { fg = c.term_dim, bg = c.term_bg })
hi("NierDashButtonSel", { fg = c.term_fg,  bg = c.term_bg2, bold = true })
hi("NierDashFooter",    { fg = c.shade5,   bg = c.term_bg, italic = true })
hi("NierDashKey",       { fg = c.accent0,  bg = c.term_bg, bold = true })

-- ── Lualine theme ─────────────────────────────────────────────────────────
-- Exposed as vim.g.nier_lualine_theme for use in lualine opts override.
vim.g.nier_lualine_theme = {
  normal = {
    a = { fg = c.shade0, bg = c.shade6, gui = "bold" },
    b = { fg = c.shade6, bg = c.shade2 },
    c = { fg = c.shade5, bg = c.shade1 },
  },
  insert = {
    a = { fg = c.shade0, bg = c.accent2, gui = "bold" },
    b = { fg = c.shade6, bg = c.shade2 },
    c = { fg = c.shade5, bg = c.shade1 },
  },
  visual = {
    a = { fg = c.shade0, bg = c.accent3, gui = "bold" },
    b = { fg = c.shade6, bg = c.shade2 },
    c = { fg = c.shade5, bg = c.shade1 },
  },
  replace = {
    a = { fg = c.shade0, bg = c.accent0, gui = "bold" },
    b = { fg = c.shade6, bg = c.shade2 },
    c = { fg = c.shade5, bg = c.shade1 },
  },
  command = {
    a = { fg = c.shade0, bg = c.accent5, gui = "bold" },
    b = { fg = c.shade6, bg = c.shade2 },
    c = { fg = c.shade5, bg = c.shade1 },
  },
  inactive = {
    a = { fg = c.shade3, bg = c.shade1 },
    b = { fg = c.shade3, bg = c.shade1 },
    c = { fg = c.shade3, bg = c.shade1 },
  },
}
