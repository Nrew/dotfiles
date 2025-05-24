local icons = require("icons")

local M = {}

-- Core constants
local FONT_FAMILY = "JetBrains Mono Nerd Font"
local BASE_PADDING = 8
local SMALL_PADDING = 1
local GROUP_SPACING = 5
local TINY_PADDING = 3
local MICRO_PADDING = 4
local FINAL_PADDING = 7
local BRACKET_HEIGHT = 30
local KNOB_SIZE = 32
local ANIMATION_FAST = 8
local ANIMATION_MEDIUM = 10
local ANIMATION_SLOW = 30
local ANIMATION_DELAY = 5

M.dimens = {
  padding = {
    base = BASE_PADDING,
    small = SMALL_PADDING,
    group = GROUP_SPACING,
    tiny = TINY_PADDING,
    micro = MICRO_PADDING,
    final = FINAL_PADDING,
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
      height = BRACKET_HEIGHT,
    },
    slider = { height = 20 },
    popup = {
      width = 200,
      large_width = 300,
    },
    border = { width = 1 },
    knob = { size = KNOB_SIZE },
  },
  text = {
    icon = 14.0,
    label = 12.0,
    calendar_icon = 12.0,
    apple_icon = 16.0,
    media_artist = 9,
    media_title = 10,
    spaces_font = 14.0,
    calendar_width = 49,
    battery_icon = 19.0,
    volume_icon = 14.0,
    wifi_label = 10.0,
  },
  effects = { blur_radius = 35 },
  animation = {
    fast = ANIMATION_FAST,
    medium = ANIMATION_MEDIUM,
    slow = ANIMATION_SLOW,
    delay = ANIMATION_DELAY,
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
    device_label_padding = 6,
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
