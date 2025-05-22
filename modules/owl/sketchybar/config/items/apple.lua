local settings = require("settings")
local colors = require("colors")

local dimens = settings.dimens
local icon = settings.text

local apple = sbar.add("item", "apple", {
  icon = {
    padding_left = dimens.padding.icon,
    padding_right = dimens.padding.icon,
    string = icon.apple,
    color = colors.white,
  },
  label = {
    drawing = false
  },
  padding_left = dimens.padding.label,
  padding_right = dimens.padding.label,
  click_script = "$CONFIG_DIR/bridge/menus/bin/menus -s 0"
})

return apple