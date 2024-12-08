local settings = require("config.settings")

sbar.default({
  updates = "when_shown",
  scroll_texts = true,

  -- Icon configuration
  icon = {
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.icon,
    },
    color = settings.colors.white,
    padding_left = settings.dimens.padding.icon,
    padding_right = settings.dimens.padding.icon,
  },

  -- Label configuration
  label = {
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.label,
    },
    color = settings.colors.white,
    padding_left = settings.dimens.padding.label,
    padding_right = settings.dimens.padding.label,
  },

  -- Background configuration
  background = {
    height = settings.dimens.graphics.background.height,
    corner_radius = settings.dimens.graphics.background.corner_radius,
    border_width = 0,
    image = {
      corner_radius = settings.dimens.graphics.background.corner_radius
    }
  },

  -- Popup configuration
  popup = {
    y_offset = settings.dimens.padding.popup,
    align = "center",
    blur_radius = settings.dimens.graphics.blur_radius,
    background = {
      border_width = 0,
      corner_radius = settings.dimens.graphics.background.corner_radius,
      color = settings.colors.popup.bg,
      shadow = { drawing = true },
      padding_left = settings.dimens.padding.icon,
      padding_right = settings.dimens.padding.icon,
    },
  },

  -- Slider configuration
  slider = {
    highlight_color = settings.colors.orange,
    background = {
      height = settings.dimens.graphics.slider.height,
      corner_radius = settings.dimens.graphics.background.corner_radius,
      color = settings.colors.slider.bg,
      border_color = settings.colors.slider.border,
      border_width = 1,
    },
    knob = {
      font = {
        family = settings.fonts.text,
        style = settings.fonts.styles.regular,
        size = 32,
      },
      string = settings.icons.text.slider.knob,
      drawing = false,
    },
  },
})