local colors = require("colors")
local settings = require("settings")

sbar.default({
  updates = "when_shown",
  padding_left = settings.dimens.padding.base,
  padding_right = settings.dimens.padding.base,
  scroll_texts = true,

  icon = {
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.bold,
      size = settings.dimens.text.icon,
    },
    color = colors.sections.item.text,
    padding_left = settings.dimens.padding.base,
    padding_right = settings.dimens.padding.base,
    background = { 
      image = { corner_radius = settings.dimens.graphics.background.corner_radius } 
    },
  },

  label = {
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.semibold,
      size = settings.dimens.text.label,
    },
    color = colors.sections.item.text,
    padding_left = settings.dimens.padding.base,
    padding_right = settings.dimens.padding.base,
  },

  background = {
    height = settings.dimens.graphics.background.height,
    corner_radius = settings.dimens.graphics.background.corner_radius,
    border_width = settings.dimens.graphics.border.width,
    border_color = colors.with_alpha(colors.sections.item.border, settings.alphas.background.border),
    image = {
      corner_radius = settings.dimens.graphics.background.corner_radius,
      border_color = colors.with_alpha(colors.legacy.grey, settings.alphas.background.border_image),
      border_width = settings.dimens.graphics.border.width,
    }
  },

  popup = {
    blur_radius = settings.dimens.effects.blur_radius,
    background = {
      border_width = 0,
      corner_radius = settings.dimens.graphics.background.corner_radius,
      color = colors.sections.popup.bg,
      shadow = { drawing = true },
    },
  },

  slider = {
    highlight_color = colors.legacy.orange,
    background = {
      height = settings.dimens.graphics.slider.height,
      corner_radius = settings.dimens.graphics.background.corner_radius,
      border_color = colors.sections.popup.border,
      color = colors.sections.popup.bg,
      border_width = settings.dimens.graphics.border.width,
    },
    knob = {
      font = {
        family = settings.fonts.family,
        style = settings.fonts.styles.regular,
        size = settings.dimens.graphics.knob.size,
      },
      string = settings.icons.slider.knob,
      drawing = false,
    },
  },
})
