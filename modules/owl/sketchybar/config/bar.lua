local colors = require("colors")
local settings = require("settings")

sbar.bar({
  topmost = "window",
  height = settings.dimens.graphics.bar.height,
  color = colors.sections.bar.bg,
  padding_right = settings.dimens.padding.base,
  padding_left = settings.dimens.padding.base,
  shadow = false,
  margin = settings.dimens.graphics.bar.margin,
  corner_radius = settings.dimens.graphics.bar.corner_radius,
  y_offset = settings.dimens.graphics.bar.offset,
  blur_radius = settings.dimens.effects.blur_radius,
})
