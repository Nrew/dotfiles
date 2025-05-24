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
  label = { font = { family = settings.fonts.family } },
  update_freq = settings.timing.battery_update,
  popup = { align = "center" }
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  icon = {
    string = "Time remaining:",
    width = settings.dimens.spacing.battery_popup_width,
    align = "left",
  },
  label = {
    string = "??:??h",
    width = settings.dimens.spacing.battery_popup_width,
    align = "right",
  },
})

-- Battery status parsing with better error handling
local function parse_battery_info(batt_info)
  if not batt_info or batt_info == "" then
    return nil, nil, nil
  end

  local charge_match = batt_info:match("(%d+)%%")
  local charge = charge_match and tonumber(charge_match) or nil

  local is_charging = batt_info:find("AC Power") ~= nil

  local remaining_match = batt_info:match("(%d+:%d+) remaining")
  local remaining = remaining_match or "No estimate"

  return charge, is_charging, remaining
end

local function get_battery_icon_and_color(charge, is_charging)
  local icon = settings.icons.battery._100
  local color = battery_colors.high

  if is_charging then
    icon = settings.icons.battery.charging
    color = battery_colors.high
  elseif charge then
    if charge > 80 then
      icon = settings.icons.battery._100
      color = battery_colors.high
    elseif charge > 60 then
      icon = settings.icons.battery._75
      color = battery_colors.high
    elseif charge > 40 then
      icon = settings.icons.battery._50
      color = battery_colors.high
    elseif charge > 20 then
      icon = settings.icons.battery._25
      color = battery_colors.mid
    else
      icon = settings.icons.battery._0
      color = battery_colors.low
    end
  else
    icon = "!"
    color = battery_colors.low
  end

  return icon, color
end

battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local charge, is_charging, remaining = parse_battery_info(batt_info)
    local icon, color = get_battery_icon_and_color(charge, is_charging)

    local label = charge and charge .. "%" or "?"
    local lead = (charge and charge < 10) and "0" or ""

    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = {
        string = lead .. label
      },
    })
  end)
end)

battery:subscribe("mouse.clicked", function(env)
  local drawing = battery:query().popup.drawing
  battery:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local _, _, remaining = parse_battery_info(batt_info)
      local label = remaining ~= "No estimate" and remaining .. "h" or remaining
      remaining_time:set({ label = { string = label } })
    end)
  end
end)

-- Bracket around battery
sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = { color = colors.legacy.bg1 }
})

-- Final spacing (rightmost)
sbar.add("item", "widgets.battery.padding", {
  position = "right",
  width = settings.dimens.padding.group
})
