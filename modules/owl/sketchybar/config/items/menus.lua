local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

local maxItems = 15
local menuItems = {}
local isShowingMenu = false

-- Hidden watchers for events
local frontAppWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local swapWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Create placeholder menu items
local function createPlaceholders()
  for index = 1, maxItems, 1 do
    local menu = sbar.add("item", constants.items.MENU .. "." .. index, {
      drawing = false,
      icon = { drawing = false },
      width = "dynamic",
      label = {
        font = {
          style = index == 1 and settings.fonts.styles.bold or settings.fonts.styles.regular,
        },
      },
      click_script = "$CONFIG_DIR/bridge/menus/bin/menus -s " .. index,
    })
    menuItems[index] = menu
  end

  -- Add padding item
  sbar.add("item", constants.items.MENU .. ".padding", {
    width = settings.dimens.padding.label
  })

  -- Create bracket for visual grouping
  sbar.add("bracket", { "/" .. constants.items.MENU .. "\\..*/" }, {
    background = {
      color = colors.bg1,
      padding_left = settings.dimens.padding.item,
      padding_right = settings.dimens.padding.item,
    },
  })
end

-- Update menu items based on current application
local function updateMenus()
  -- Hide all menu items first
  sbar.set("/" .. constants.items.MENU .. "\\..*/", { drawing = false })

  -- Get menu items from the bridge binary
  sbar.exec("$CONFIG_DIR/bridge/menus/bin/menus -l", function(menus)
    if not menus or menus == "" then
      return
    end

    local index = 1
    for menu in string.gmatch(menus, '[^\r\n]+') do
      if index < maxItems and menu ~= "" then
        menuItems[index]:set({
          width = "dynamic",
          label = menu,
          drawing = isShowingMenu
        })
        index = index + 1
      else
        break
      end
    end
  end)

  -- Show/hide padding based on menu visibility
  sbar.set(constants.items.MENU .. ".padding", { drawing = isShowingMenu })
end

-- Subscribe to front app changes
frontAppWatcher:subscribe(constants.events.FRONT_APP_SWITCHED, updateMenus)

-- Subscribe to menu/spaces toggle
swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
  isShowingMenu = env.isShowingMenu == "on"
  updateMenus()
end)

-- Initialize the menu system
createPlaceholders()

return menuItems
