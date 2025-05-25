return {
  paddings = 3,
  group_paddings = 5,

  icons = "sf-symbols", -- alternatively available: NerdFont

  -- This is a font configuration for SF Pro and SF Mono (installed manually)
  -- font = require("helpers.default_font"),

  font = {
    text = "Maple Mono NF",    -- Used for text
    numbers = "Maple Mono NF", -- Used for numbers
    space_numbers = "Maple Mono NF",
    style_map = {
      ["Regular"] = "Regular",
      ["Semibold"] = "Medium",
      ["Bold"] = "SemiBold",
      ["Heavy"] = "Bold",
      ["Black"] = "ExtraBold",
    },
  },
}
