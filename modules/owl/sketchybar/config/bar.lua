local settings = require("config.settings")

sbar.bar({ 																-- Create the bar
	topmost = "window", 												-- "window" or "screen"
	height = 40,						-- Height of the bar
	color = settings.colors.with_alpha(settings.colors.bg2, 0.35),							-- Background color of the bar
	padding_right = 5,						-- Padding on the right side of the bar
	padding_left = 5,							-- Padding on the left side of the bar
	blur_radius = 35, 	-- Blur radius of the bar
	shadow = false,
	margin = 0,								-- Margin of the bar
	corner_radius = 15, 	-- Corner radius of the bar
	y_offset = 0,						-- Offset of the bar
	-- blur_radius = settings.dimens.graphics.blur_radius, 				-- Blur radius of the bar
	background_color = settings.olors.with_alpha(settings.colors.bar.bg, 0.40),
})