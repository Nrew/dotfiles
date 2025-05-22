local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

local isCharging = false

local dimens = settings.dimens


local battery = sbar.add("item", constants.items.BATTERY, {
  position = "right",
  update_freq = 60,
})

local batteryPopup = sbar.add("item", {
  position = "popup." .. battery.name,
  width = "dynamic",
  label = {
    padding_right = dimens.padding.label,
    padding_left = dimens.padding.label,
  },
  icon = {
    padding_left = 0,
    padding_right = 0,
  },
})

-- Battery status update function
local function updateBatteryStatus()
  sbar.exec("pmset -g batt", function(batteryInfo)
    if not batteryInfo or batteryInfo == "" then
      battery:set({
        icon = { string = "!", color = colors.red },
        label = { string = "Error" }
      })
      return
    end

    local icon = "!"
    local label = "?"
    local color = colors.green

    -- Parse battery percentage
    local found, _, charge = batteryInfo:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    -- Check if charging
    local charging = batteryInfo:find("AC Power") ~= nil
    isCharging = charging

    if charging then
      icon = settings.text.battery.charging
      color = colors.green
    else
      -- Set icon and color based on charge level
      if found and charge > 80 then
        icon = settings.text.battery._100
        color = colors.green
      elseif found and charge > 60 then
        icon = settings.text.battery._75
        color = colors.green
      elseif found and charge > 40 then
        icon = settings.text.battery._50
        color = colors.yellow
      elseif found and charge > 30 then
        icon = settings.text.battery._50
        color = colors.yellow
      elseif found and charge > 20 then
        icon = settings.text.battery._25
        color = colors.orange
      else
        icon = settings.text.battery._0
        color = colors.red
      end
    end

    -- Format label with leading zero if needed
    local lead = ""
    if found and charge < 10 then
      lead = "0"
    end

    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = {
        string = lead .. label,
        padding_left = 0,
      },
    })
  end)
end

-- Subscribe to battery events
battery:subscribe({ "routine", "power_source_change", "system_woke" }, updateBatteryStatus)

-- Handle battery popup click
battery:subscribe("mouse.clicked", function(env)
  local drawing = battery:query().popup.drawing

  battery:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batteryInfo)
      if not batteryInfo or batteryInfo == "" then
        batteryPopup:set({ label = "Battery information unavailable" })
        return
      end

      local found, _, remaining = batteryInfo:find("(%d+:%d+) remaining")
      local label = found and ("Time remaining: " .. remaining .. "h") 
                    or (isCharging and "Charging" or "No estimate")
      batteryPopup:set({ label = label })
    end)
  end
end)

return battery
