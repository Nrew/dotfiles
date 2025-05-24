local colors = require("colors")
local settings = require("settings")

sbar.add("item", { width = settings.dimens.padding.group })

local apple = sbar.add("item", {
  icon = {
    font = { size = settings.dimens.text.apple_icon },
    string = settings.icons.apple,
    padding_right = settings.dimens.padding.base,
    padding_left = settings.dimens.padding.base,
  },
  label = { drawing = false },
  background = {
    color = colors.sections.item.bg,
    border_color = colors.sections.item.border,
    border_width = settings.dimens.graphics.border.width
  },
  padding_left = settings.dimens.padding.small,
  padding_right = settings.dimens.padding.small,
})

-- Subscribe to mouse clicks to trigger the menu swap
apple:subscribe("mouse.clicked", function(env)
  -- First trigger the menu/spaces swap to show menus
  sbar.trigger("swap_menus_and_spaces")
  
  -- Small delay to ensure menus are visible before clicking
  sbar.delay(0.1, function()
    sbar.exec("$CONFIG_DIR/bridge/menus/bin/menus -s 0")
  end)
end)

sbar.add("bracket", { apple.name }, {
  background = {
    color = colors.transparent,
    height = settings.dimens.graphics.bracket.height,
    border_color = colors.legacy.grey,
  }
})

sbar.add("item", { width = settings.dimens.padding.final })
