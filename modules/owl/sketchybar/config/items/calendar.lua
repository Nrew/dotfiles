local settings = require("settings")
local colors = require("colors")

sbar.add("item", { position = "right", width = settings.dimens.padding.group })

local cal = sbar.add("item", {
  icon = {
    color = colors.sections.calendar.label,
    padding_left = settings.dimens.padding.base,
    font = {
      style = settings.fonts.styles.black,
      size = settings.dimens.calendar.icon_size,
    },
  },
  label = {
    color = colors.sections.calendar.label,
    padding_right = settings.dimens.padding.base,
    width = settings.dimens.calendar.width,
    align = "right",
    font = { family = settings.fonts.family },
  },
  position = "right",
  update_freq = settings.timing.calendar_update,
  padding_left = settings.dimens.padding.small,
  padding_right = settings.dimens.padding.small,
  background = {
    color = colors.sections.item.bg,
    border_color = colors.sections.item.border,
    border_width = settings.dimens.graphics.border.width
  },
})

sbar.add("bracket", { cal.name }, {
  background = {
    color = colors.transparent,
    height = settings.dimens.graphics.bracket.height,
    border_color = colors.legacy.grey,
  }
})

sbar.add("item", { position = "right", width = settings.dimens.padding.group })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
end)
