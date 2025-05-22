local colors = require("colors")
local settings = require("settings")

local dimens = settings.dimens
local alphas = settings.alphas

sbar.bar({ 																-- Create the bar
	topmost = "window", 												-- "window" or "screen"
	height = dimens.graphics.bar.height,								-- Height of the bar
	color = colors.with_alpha(colors.bar.bg, alphas.bar.background),	-- Background color of the bar, using colors.bar.bg
	padding_right = dimens.padding.bar,									-- Padding on the right side of the bar
	padding_left = dimens.padding.bar,									-- Padding on the left side of the bar
	shadow = false,														-- Shadow of the bar
	margin = dimens.graphics.bar.margin,								-- Margin of the bar
	corner_radius = dimens.graphics.bar.corner_radius, 					-- Corner radius of the bar
	y_offset = dimens.graphics.bar.offset,								-- Offset of the bar
	blur_radius = dimens.effects.blur_radius, 							-- Blur radius of the bar
})