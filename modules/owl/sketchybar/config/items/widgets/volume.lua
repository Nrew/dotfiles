local colors = require("colors")
local settings = require("settings")

local popup_width = settings.dimens.graphics.popup.width
local volume_colors = colors.sections.widgets.volume

local volume_percent = sbar.add("item", "widgets.volume1", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "??%",
    padding_left = settings.dimens.volume.padding_negative,
    font = { family = settings.fonts.family },
    color = colors.sections.item.text,
  },
})

local volume_icon = sbar.add("item", "widgets.volume2", {
  position = "right",
  padding_right = settings.dimens.volume.padding_negative,
  icon = {
    string = settings.icons.volume._100,
    width = 0,
    align = "left",
    color = volume_colors.icon,
    font = {
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.volume_icon,
    },
  },
  label = {
    width = settings.dimens.volume.label_width,
    align = "left",
    font = {
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.volume_icon,
    },
  },
})

local volume_bracket = sbar.add("bracket", "widgets.volume.bracket", {
  volume_icon.name,
  volume_percent.name
}, {
  background = { color = colors.legacy.bg1 },
  popup = { align = "center" }
})

sbar.add("item", "widgets.volume.padding", {
  position = "right",
  width = settings.dimens.padding.group
})

local volume_slider = sbar.add("slider", popup_width, {
  position = "popup." .. volume_bracket.name,
  slider = {
    highlight_color = volume_colors.slider.highlight,
    background = {
      height = settings.dimens.volume.slider_height,
      corner_radius = settings.dimens.volume.slider_radius,
      color = volume_colors.slider.bg,
    },
    knob = {
      string = "􀀁",
      drawing = true,
    },
  },
  background = { 
    color = volume_colors.popup.bg, 
    height = settings.dimens.volume.background_height, 
    y_offset = settings.dimens.volume.background_offset 
  },
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

volume_percent:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO)
  local icon = settings.icons.volume._0
  
  if volume > 60 then
    icon = settings.icons.volume._100
  elseif volume > 30 then
    icon = settings.icons.volume._66
  elseif volume > 10 then
    icon = settings.icons.volume._33
  elseif volume > 0 then
    icon = settings.icons.volume._10
  end

  local lead = ""
  if volume < 10 then
    lead = "0"
  end

  volume_icon:set({ label = icon })
  volume_percent:set({ label = lead .. volume .. "%" })
  volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
  local drawing = volume_bracket:query().popup.drawing == "on"
  if not drawing then return end
  volume_bracket:set({ popup = { drawing = false } })
  sbar.remove('/volume.device\\.*/')
end

local current_audio_device = "None"
local function volume_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  local should_draw = volume_bracket:query().popup.drawing == "off"
  if should_draw then
    volume_bracket:set({ popup = { drawing = true } })
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      current_audio_device = result:sub(1, -2)
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        local current = current_audio_device
        local counter = 0

        for device in string.gmatch(available, '[^\r\n]+') do
          local device_color = volume_colors.popup.highlight
          if current == device then
            device_color = volume_colors.popup.item
          end
          
          sbar.add("item", "volume.device." .. counter, {
            position = "popup." .. volume_bracket.name,
            width = popup_width,
            align = "center",
            label = { 
              string = device, 
              color = device_color 
            },
            click_script = 'SwitchAudioSource -s "' .. device .. '"'
          })
          counter = counter + 1
        end
      end)
    end)
  else
    volume_collapse_details()
  end
end

local function volume_scroll(env)
  local delta = env.SCROLL_DELTA
  sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume_icon:subscribe("mouse.clicked", volume_toggle_details)
volume_icon:subscribe("mouse.scrolled", volume_scroll)
volume_percent:subscribe("mouse.clicked", volume_toggle_details)
volume_percent:subscribe("mouse.exited.global", volume_collapse_details)
volume_percent:subscribe("mouse.scrolled", volume_scroll)
