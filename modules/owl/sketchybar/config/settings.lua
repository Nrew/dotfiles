local icons = require("icons")

local M = {}

-- Core constants - simplified and working values
local FONT_FAMILY = "JetBrains Mono Nerd Font"
local BASE_PADDING = 8
local GROUP_SPACING = 5

M.dimens = {
  padding = {
    base = BASE_PADDING,
    small = 1,
    group = GROUP_SPACING,
  },
  graphics = {
    bar = {
      height = 40,
      offset = 0,
      corner_radius = 15,
      margin = 0,
    },
    background = {
      height = 24,
      corner_radius = 9,
    },
    bracket = {
      height = 30,
    },
    slider = { height = 20 },
    popup = {
      width = 200,
      large_width = 300,
    },
    border = { width = 1 },
    knob = { size = 32 },
  },
  text = {
    icon = 14.0,
    label = 12.0,
    apple_icon = 16.0,
    battery_icon = 19.0,
    volume_icon = 14.0,
    wifi_label = 10.0,
  },
  effects = { blur_radius = 35 },
  animation = {
    fast = 8,
    medium = 10,
    slow = 30,
    delay = 5,
  },
  media = {
    cover_padding = 60,
    artist_offset = -8,
    title_offset = 6,
    artist_chars = 25,
    title_chars = 55,
    artwork_scale = 0.85,
    artist_alpha = 0.6,
  },
  spaces = {
    indicator_padding = 9,
    label_offset = -1,
    animation_offset = -4,
    shadow_distance = 4,
    fallback_padding = 12,
  },
  wifi = {
    padding_right = 25,
    padding_main = 6,
    popup_split = 2,
  },
  battery = {
    popup_width = 100,
  },
  volume = {
    padding_negative = -1,
    slider_height = 6,
    slider_radius = 3,
    background_height = 2,
    background_offset = -20,
    label_width = 25,
  },
  calendar = {
    width = 49,
    icon_size = 12.0,
  },
}

M.alphas = {
  bar = {
    background = 0.94,
    border = 0.5,
  },
  background = {
    border = 0.7,
    border_image = 0.6,
  },
}

M.fonts = {
  family = FONT_FAMILY,
  styles = {
    regular = "Regular",
    semibold = "Semibold",
    bold = "Bold",
    heavy = "Heavy",
    black = "Black",
  },
  icons = function(size)
    local font = "sketchybar-app-font:Regular:"
    return size and (font .. size) or (font .. M.dimens.text.icon)
  end,
}

M.timing = {
  calendar_update = 30,
  battery_update = 180,
}

M.icons = icons.text.nerdfont
M.apps = icons.apps

return M
