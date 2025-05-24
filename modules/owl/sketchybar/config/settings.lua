local icons = require("icons")

local M = {}

-- Constants 
local FONT_FAMILY <const> = "JetBrains Mono Nerd Font"

-- Padding constants
local BASE_PADDING <const> = 8
local SMALL_PADDING <const> = 1
local GROUP_SPACING <const> = 5
local MENU_LABEL_PADDING <const> = 6
local FINAL_SPACING <const> = 7
local MEDIA_SMALL_PADDING <const> = 3
local SPACE_MICRO_PADDING <const> = 4
local INDICATOR_PADDING <const> = 9

-- Graphics constants
local BRACKET_HEIGHT <const> = 30
local POPUP_WIDTH <const> = 200
local LARGE_POPUP_WIDTH <const> = 300
local BATTERY_POPUP_WIDTH <const> = 100
local VOLUME_LABEL_WIDTH <const> = 25
local WIFI_PADDING_RIGHT <const> = 25
local WIFI_PADDING_MAIN <const> = 6
local MEDIA_COVER_PADDING <const> = 60
local CALENDAR_WIDTH <const> = 49

-- Animation constants
local ANIMATION_FAST <const> = 8
local ANIMATION_MEDIUM <const> = 10
local ANIMATION_SLOW <const> = 30
local ANIMATION_DELAY <const> = 5

-- Timing constants
local CALENDAR_UPDATE_FREQ <const> = 30
local BATTERY_UPDATE_FREQ <const> = 180

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
    slider = { 
      height = 20 
    },
    popup = {
      width = POPUP_WIDTH,
      large_width = LARGE_POPUP_WIDTH,
    },
    border = { 
      width = 1 
    },
    knob = { 
      size = 32 
    },
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
  effects = { 
    blur_radius = 35 
  },
  animation = {
    fast = ANIMATION_FAST,
    medium = ANIMATION_MEDIUM,
    slow = ANIMATION_SLOW,
    delay = ANIMATION_DELAY,
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
}

M.timing = {
  calendar_update = CALENDAR_UPDATE_FREQ,
  battery_update = BATTERY_UPDATE_FREQ,
}

-- Icon and app references
M.icons = icons.text.sf_symbols
M.apps = icons.apps

-- Utility functions for settings
function M.get_font_config(style, size)
  style = style or M.fonts.styles.regular
  size = size or M.dimens.text.label
  
  return {
    family = M.fonts.family,
    style = style,
    size = size,
  }
end

function M.get_padding_config(left, right)
  left = left or M.dimens.padding.base
  right = right or left
  
  return {
    padding_left = left,
    padding_right = right,
  }
end

return M
