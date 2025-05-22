-- Default configuration for SketchyBar items
-- Fixed all reference issues and improved structure

local colors = require("colors")
local settings = require("settings")

local dimens = settings.dimens
local fonts = settings.fonts
local alphas = settings.alphas

sbar.default({
  updates = "when_shown",
  padding_left = dimens.padding.bar,
  padding_right = dimens.padding.bar,
  scroll_texts = true,

  -- Icon configuration
  icon = {
    font = {
      family = fonts.text,
      style = fonts.styles.bold,
      size = dimens.text.icon,
    },
    color = colors.white,
    padding_left = dimens.padding.icon,
    padding_right = dimens.padding.icon,
    background = { image = { corner_radius = 9 } },
  },

  -- Label configuration
  label = {
    font = {
      family = fonts.text,
      style = fonts.styles.semibold,
      size = dimens.text.label,
    },
    color = colors.white,
    padding_left = dimens.padding.label,
    padding_right = dimens.padding.label,
  },

  -- Background configuration
  background = {
    height = dimens.graphics.background.height,
    corner_radius = dimens.graphics.background.corner_radius,
    border_width = dimens.graphics.border.width,
    border_color = colors.with_alpha(colors.bg2, alphas.background.border),
    image = {
      corner_radius = dimens.graphics.background.corner_radius,
      border_color = colors.with_alpha(colors.grey, alphas.background.border_image),
      border_width = dimens.graphics.border.width,
    }
  },

  -- Popup configuration
  popup = {
    blur_radius = dimens.effects.blur_radius,
    background = {
      border_width = 0,
      corner_radius = dimens.graphics.background.corner_radius,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
  },

  -- Slider configuration
  slider = {
    highlight_color = colors.orange,
    background = {
      height = dimens.graphics.slider.height,
      corner_radius = dimens.graphics.background.corner_radius,
      border_color = colors.popup.border,
      color = colors.slider.bg,
      border_width = 1,
    },
    knob = {
      font = {
        family = fonts.text,
        style = fonts.styles.regular,
        size = 32,
      },
      string = settings.text.slider.knob,
      drawing = false,
    },
  },
})
