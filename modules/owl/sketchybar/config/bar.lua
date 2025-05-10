local settings = require("config.settings")
																		
sbar.bar({ 																-- Create the bar
	topmost = "window", 												-- "window" or "screen"
	height = settings.dimens.graphics.bar.height,						-- Height of the bar
	color = settings.colors.bar.transparent,							-- Background color of the bar
	padding_right = settings.dimens.padding.bar,						-- Padding on the right side of the bar
	padding_left = settings.dimens.padding.bar,							-- Padding on the left side of the bar
	margin = settings.dimens.padding.bar,								-- Margin of the bar
	corner_radius = settings.dimens.graphics.background.corner_radius, 	-- Corner radius of the bar
	y_offset = settings.dimens.graphics.bar.offset,						-- Offset of the bar
	-- blur_radius = settings.dimens.graphics.blur_radius, 				-- Blur radius of the bar
	border_width = 0,													-- Border width of the bar
})