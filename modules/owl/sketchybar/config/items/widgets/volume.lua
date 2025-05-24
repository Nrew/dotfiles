local colors = require("colors")
local settings = require("settings")

local popup_width = settings.dimens.graphics.popup.width
local volume_colors = colors.sections.widgets.volume

-- Volume percentage display
local volume_percent = sbar.add("item", "widgets.volume.percent", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "??%",
    padding_left = settings.dimens.volume.padding_negative,
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.label,
    },
    color = colors.sections.item.text,
  },
})

-- Volume icon display
local volume_icon = sbar.add("item", "widgets.volume.icon", {
  position = "right",
  padding_right = settings.dimens.volume.padding_negative,
  icon = {
    string = settings.icons.volume._100,
    width = 0,
    align = "left",
    color = volume_colors.icon,
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.volume_icon,
    },
  },
  label = {
    width = settings.dimens.spacing.volume_label_width,
    align = "left",
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.volume_icon,
    },
  },
})

-- Bracket around volume components
local volume_bracket = sbar.add("bracket", "widgets.volume.bracket", {
  volume_icon.name,
  volume_percent.name
}, {
  background = { color = colors.legacy.bg1 },
  popup = { align = "center" }
})

-- Spacing after volume
sbar.add("item", "widgets.volume.padding", {
  position = "right",
  width = settings.dimens.padding.group
})

-- Volume slider in popup
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
      string = settings.icons.slider.knob,
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

-- Helper function to get volume icon based on level
local function get_volume_icon(volume)
  if volume > 60 then
    return settings.icons.volume._100
  elseif volume > 30 then
    return settings.icons.volume._66
  elseif volume > 10 then
    return settings.icons.volume._33
  elseif volume > 0 then
    return settings.icons.volume._10
  else
    return settings.icons.volume._0
  end
end

-- Volume change handler
volume_percent:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO)
  if not volume or volume < 0 or volume > 100 then return end

  local icon = get_volume_icon(volume)
  local lead = volume < 10 and "0" or ""

  volume_icon:set({ label = { string = icon } })
  volume_percent:set({ label = { string = lead .. volume .. "%" } })
  volume_slider:set({ slider = { percentage = volume } })
end)

-- Audio device management
local current_audio_device = "None"

local function collapse_volume_details()
  local drawing = volume_bracket:query().popup.drawing == "on"
  if not drawing then return end

  volume_bracket:set({ popup = { drawing = false } })
  sbar.remove('/volume.device\\.*/')
end

local function toggle_volume_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  local should_draw = volume_bracket:query().popup.drawing == "off"

  if should_draw then
    volume_bracket:set({ popup = { drawing = true } })

    -- Get current audio device
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      if not result or result == "" then
        current_audio_device = "Unknown"
        return
      end

      current_audio_device = result:gsub("\n", "")

      -- Get available audio devices
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        if not available or available == "" then return end

        local counter = 0
        for device in string.gmatch(available, '[^\r\n]+') do
          if device and device ~= "" then
            local device_color = current_audio_device == device and
                               volume_colors.popup.item or
                               volume_colors.popup.highlight

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
        end
      end)
    end)
  else
    collapse_volume_details()
  end
end

local function handle_volume_scroll(env)
  local delta = tonumber(env.SCROLL_DELTA)
  if not delta then return end

  sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

-- Event subscriptions
volume_icon:subscribe("mouse.clicked", toggle_volume_details)
volume_icon:subscribe("mouse.scrolled", handle_volume_scroll)
volume_percent:subscribe("mouse.clicked", toggle_volume_details)
volume_percent:subscribe("mouse.exited.global", collapse_volume_details)
volume_percent:subscribe("mouse.scrolled", handle_volume_scroll)
