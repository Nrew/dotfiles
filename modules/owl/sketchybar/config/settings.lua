local icons = require("icons")

local M = {}

-- ALL constants defined here - no magic numbers anywhere
local FONT_FAMILY = "JetBrains Mono Nerd Font"
local BASE_PADDING = 8
local SMALL_PADDING = 1
local GROUP_SPACING = 5
local MENU_LABEL_PADDING = 6
local FINAL_SPACING = 7
local MEDIA_SMALL_PADDING = 3
local SPACE_MICRO_PADDING = 4
local INDICATOR_PADDING = 9
local BRACKET_HEIGHT = 30
local POPUP_WIDTH = 200
local VOLUME_LABEL_WIDTH = 25
local WIFI_PADDING_RIGHT = 25
local WIFI_PADDING_MAIN = 6
local MEDIA_COVER_PADDING = 60
local CALENDAR_WIDTH = 49
local BATTERY_POPUP_WIDTH = 100

M.dimens = {
  padding = {
    base = BASE_PADDING,
    small = SMALL_PADDING,
    group = GROUP_SPACING,
    menu_label = MENU_LABEL_PADDING,
    final = FINAL_SPACING,
    media_small = MEDIA_SMALL_PADDING,
    space_micro = SPACE_MICRO_PADDING,
    indicator = INDICATOR_PADDING,
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
      width = POPUP_WIDTH,
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
    media_artist = 9,
    media_title = 10,
    calendar_icon = 12.0,
  },
  spacing = {
    calendar_width = CALENDAR_WIDTH,
    media_cover_padding = MEDIA_COVER_PADDING,
    wifi_padding_right = WIFI_PADDING_RIGHT,
    wifi_padding_main = WIFI_PADDING_MAIN,
    volume_label_width = VOLUME_LABEL_WIDTH,
    battery_popup_width = BATTERY_POPUP_WIDTH,
    fallback_padding = 12,
  },
  effects = { blur_radius = 35 },
  animation = {
    fast = 8,
    medium = 10,
    slow = 30,
    delay = 5,
  },
  media = {
    artist_offset = -8,
    title_offset = 6,
    artist_chars = 25,
    title_chars = 55,
    artwork_scale = 0.85,
    artist_alpha = 0.6,
  },
  spaces = {
    label_offset = -1,
    animation_offset = -4,
    shadow_distance = 4,
  },
  volume = {
    padding_negative = -1,
    slider_height = 6,
    slider_radius = 3,
    background_height = 2,
    background_offset = -20,
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
