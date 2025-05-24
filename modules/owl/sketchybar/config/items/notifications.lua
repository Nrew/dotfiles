local colors = require("colors")
local settings = require("settings")

local notification = sbar.add("item", "notifications", {
  width = 0,
  position = "center",
  popup = {
    drawing = true,
    align = "center",
    y_offset = -80,
  },
})

local notification_popup = sbar.add("item", {
  position = "popup." .. notification.name,
  width = "dynamic",
  icon = { drawing = false },
  background = { drawing = false },
  label = {
    color = colors.sections.item.text,
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.semibold,
      size = settings.dimens.text.label,
    },
  },
})

local function hide_notification()
  sbar.animate("sin", settings.dimens.animation.slow, function()
    notification:set({ popup = { y_offset = 2 } })
    notification:set({ popup = { y_offset = -80 } })
  end)
end

local function show_notification(content, hold)
  if not content or content == "" then
    return
  end
  
  hide_notification()
  notification_popup:set({ label = { string = content } })

  sbar.animate("sin", settings.dimens.animation.slow, function()
    notification:set({ popup = { y_offset = -80 } })
    notification:set({ popup = { y_offset = 2 } })
  end)

  if not hold then
    sbar.delay(5, function()
      if not hold then 
        hide_notification()
      end
    end)
  end
end

notification:subscribe("send_message", function(env)
  local content = env.MESSAGE
  local hold = env.HOLD and env.HOLD == "true"
  show_notification(content, hold)
end)

notification:subscribe("hide_message", hide_notification)
