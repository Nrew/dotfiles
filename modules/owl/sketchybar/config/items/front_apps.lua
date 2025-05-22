local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

local frontApps = {}

-- Create bracket for grouping front app items
sbar.add("bracket", constants.items.FRONT_APPS, {}, { position = "left" })

-- Hidden watcher for front app events
local frontAppWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Highlight the currently focused window
local function selectFocusedWindow(frontAppName)
  if not frontAppName or frontAppName == "" then
    return
  end

  for appName, app in pairs(frontApps) do
    if app then
      local isSelected = appName == frontAppName
      local color = isSelected and colors.orange or colors.white

      app:set({
        label = { color = color },
        icon = { color = color },
      })
    end
  end
end

-- Update the list of visible windows
local function updateWindows(windows)
  if not windows or windows == "" then
    return
  end

  -- Remove existing front app items
  sbar.remove("/" .. constants.items.FRONT_APPS .. "\\.*/")
  frontApps = {}

  local foundWindows = string.gmatch(windows, "[^\n]+")
  for window in foundWindows do
    if window and window ~= "" then
      local parsedWindow = {}

      -- Parse window information (id=123, name=AppName)
      for key, value in string.gmatch(window, "(%w+)=([%w%s%-_%.]+)") do
        parsedWindow[key] = value
      end

      local windowId = parsedWindow["id"]
      local windowName = parsedWindow["name"]

      if windowId and windowName then
        -- Get app icon, fallback to default if not found
        local icon = settings.apps[windowName] or settings.apps["default"] or ":default:"

        frontApps[windowName] = sbar.add("item", constants.items.FRONT_APPS .. "." .. windowName, {
          label = {
            padding_left = 0,
            padding_right = 0,
            -- Uncomment to show app names: string = windowName,
          },
          icon = {
            string = icon,
            font = settings.fonts.icons(),
            color = colors.white,
          },
          click_script = "aerospace focus --window-id " .. windowId,
        })
      end
    end
  end

  -- Update focus state for current window
  sbar.exec(constants.aerospace.GET_CURRENT_WINDOW, function(frontAppName)
    if frontAppName then
      selectFocusedWindow(frontAppName:gsub("[\n\r]", ""))
    end
  end)
end

-- Get current windows from aerospace
local function getWindows()
  sbar.exec(constants.aerospace.LIST_WINDOWS, function(result)
    updateWindows(result)
  end)
end

-- Subscribe to window update events
frontAppWatcher:subscribe(constants.events.UPDATE_WINDOWS, getWindows)

-- Subscribe to front app switch events
frontAppWatcher:subscribe(constants.events.FRONT_APP_SWITCHED, getWindows)

-- Initialize windows on startup
getWindows()

return frontApps
