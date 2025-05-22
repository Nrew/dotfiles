-- Main bar configuration for SketchyBar
-- Fixed alpha references and improved structure

local colors = require("colors")
local settings = require("settings")

local dimens = settings.dimens
local alphas = settings.alphas

sbar.bar({
  topmost = "window",                                                      -- "window" or "screen"
  height = dimens.graphics.bar.height,                                    -- Height of the bar
  color = colors.with_alpha(colors.bar.bg, alphas.bar.background),       -- Background color with transparency
  padding_right = dimens.padding.bar,                                     -- Padding on the right side
  padding_left = dimens.padding.bar,                                      -- Padding on the left side
  shadow = false,                                                          -- Disable shadow
  margin = dimens.graphics.bar.margin,                                    -- Margin around the bar
  corner_radius = dimens.graphics.bar.corner_radius,                      -- Corner radius for rounded corners
  y_offset = dimens.graphics.bar.offset,                                  -- Vertical offset from screen edge
  blur_radius = dimens.effects.blur_radius,                               -- Background blur radius
})
