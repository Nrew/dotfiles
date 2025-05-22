local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

-- Create the custom event for swapping
sbar.add("event", constants.events.SWAP_MENU_AND_SPACES)

-- Toggle between menu and spaces view
local function switchToggle(menuToggle)
  local currentIcon = menuToggle:query().icon.value
  local isShowingMenu = currentIcon == settings.text.switch.on

  menuToggle:set({
    icon = isShowingMenu and settings.text.switch.off or settings.text.switch.on,
    label = isShowingMenu and "Menus" or "Spaces",
  })

  -- Trigger the swap event
  sbar.trigger(constants.events.SWAP_MENU_AND_SPACES, { 
    isShowingMenu = isShowingMenu and "on" or "off"
  })
end

-- Create the toggle button
local function addToggle()
  local menuToggle = sbar.add("item", constants.items.MENU_TOGGLE, {
    icon = {
      string = settings.text.switch.on
    },
    label = {
      width = 0,
      color = colors.bg1,
      string = "Spaces",
    },
    background = {
      color = colors.with_alpha(colors.dirty_white, 0.0),
    }
  })

  -- Add padding after toggle
  sbar.add("item", constants.items.MENU_TOGGLE .. ".padding", {
    width = settings.dimens.padding.label
  })

  -- Mouse enter animation
  menuToggle:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
      menuToggle:set({
        background = {
          color = { alpha = 1.0 },
          border_color = { alpha = 0.5 },
        },
        icon = { color = colors.bg1 },
        label = { width = "dynamic" }
      })
    end)
  end)

  -- Mouse exit animation
  menuToggle:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
      menuToggle:set({
        background = {
          color = { alpha = 0.0 },
          border_color = { alpha = 0.0 },
        },
        icon = { color = colors.white },
        label = { width = 0 }
      })
    end)
  end)

  -- Handle clicks
  menuToggle:subscribe("mouse.clicked", function(env)
    switchToggle(menuToggle)
  end)

  -- Handle aerospace workspace switches
  menuToggle:subscribe(constants.events.AEROSPACE_SWITCH, function(env)
    switchToggle(menuToggle)
  end)

  return menuToggle
end

local toggle = addToggle()
return toggle