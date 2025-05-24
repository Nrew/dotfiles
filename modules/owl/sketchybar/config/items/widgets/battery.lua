local colors = require("colors")
local settings = require("settings")

local battery_colors = colors.sections.widgets.battery

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  icon = {
    font = {
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.battery_icon,
    }
  },
  label = { 
    font = { family = settings.fonts.family },
    color = battery_colors.high,
  },
  update_freq = settings.timing.battery_update,
  popup = { align = "center" }
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  icon = {
    string = "Time remaining:",
    width = settings.dimens.battery.popup_width,
    align = "left",
    color = battery_colors.high,
  },
  label = {
    string = "??:??h",
    width = settings.dimens.battery.popup_width,
    align = "right",
    color = battery_colors.high,
  },
})

battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    local color = battery_colors.high
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      icon = settings.icons.battery.charging
    else
      if found and charge > 80 then
        icon = settings.icons.battery._100
      elseif found and charge > 60 then
        icon = settings.icons.battery._75
      elseif found and charge > 40 then
        icon = settings.icons.battery._50
      elseif found and charge > 20 then
        icon = settings.icons.battery._25
        color = battery_colors.mid
      else
        icon = settings.icons.battery._0
        color = battery_colors.low
      end
    end

    local lead = ""
    if found and charge < 10 then
      lead = "0"
    end

    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = { string = lead .. label },
    })
  end)
end)

battery:subscribe("mouse.clicked", function(env)
  local drawing = battery:query().popup.drawing
  battery:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      remaining_time:set({ label = label })
    end)
  end
end)

sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = { color = colors.legacy.bg1 }
})

sbar.add("item", "widgets.battery.padding", {
  position = "right",
  width = settings.dimens.padding.group
})
