local constants = require("constants")
local colors = require("colors")

local calendar = sbar.add("item", constants.items.CALENDAR, {
  position = "right",
  update_freq = 1,
  icon = { 
    padding_left = 0, 
    padding_right = 0 
  },
  label = {
    color = colors.white,
  }
})

-- Update calendar display
local function updateCalendar()
  -- Format: "Mon 25 Dec, 14:30"
  local dateStr = os.date("%a %d %b, %H:%M")
  calendar:set({
    label = { string = dateStr },
  })
end

-- Subscribe to time-based events
calendar:subscribe({ "forced", "routine", "system_woke" }, updateCalendar)

-- Handle calendar clicks
calendar:subscribe("mouse.clicked", function(env)
  -- Open Calendar app on click
  sbar.exec("open -a 'Calendar'")
end)

-- Handle right-click to show date/time preferences
calendar:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/DateAndTime.prefpane")
  end
end)

-- Initialize calendar
updateCalendar()

return calendar
