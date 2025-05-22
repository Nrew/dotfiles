local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

local currentAudioDevice = "None"

-- Volume display item
local volumeValue = sbar.add("item", constants.items.VOLUME .. ".value", {
  position = "right",
  label = {
    string = "??%",
    padding_left = 0,
  },
})

-- Volume bracket for grouping
local volumeBracket = sbar.add("bracket", constants.items.VOLUME .. ".bracket", { volumeValue.name }, {
  popup = { align = "center" }
})

-- Volume slider in popup
local volumeSlider = sbar.add("slider", constants.items.VOLUME .. ".slider", settings.dimens.graphics.popup.width, {
  position = "popup." .. volumeBracket.name,
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

-- Update volume display based on system volume
volumeValue:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO)
  if not volume then
    volumeValue:set({
      icon = settings.text.volume._0,
      label = { string = "Error" }
    })
    return
  end

  local icon = settings.text.volume._0

  -- Set icon based on volume level
  if volume > 60 then
    icon = settings.text.volume._100
  elseif volume > 30 then
    icon = settings.text.volume._66
  elseif volume > 10 then
    icon = settings.text.volume._33
  elseif volume > 0 then
    icon = settings.text.volume._10
  end

  -- Format volume percentage with leading zero if needed
  local lead = volume < 10 and "0" or ""
  local hasVolume = volume > 0

  -- Update the volume slider
  volumeSlider:set({ slider = { percentage = volume } })

  -- Update the volume display
  volumeValue:set({
    icon = icon,
    label = {
      string = hasVolume and (lead .. volume .. "%") or "",
      padding_right = hasVolume and 8 or 0,
    },
  })
end)

-- Hide volume details popup
local function hideVolumeDetails()
  local drawing = volumeBracket:query().popup.drawing == "on"
  if not drawing then 
    return 
  end
  
  volumeBracket:set({ popup = { drawing = false } })
  -- Remove audio device items
  sbar.remove("/" .. constants.items.VOLUME .. ".device\\.*/")
end

-- Toggle volume details popup
local function toggleVolumeDetails(env)
  if env.BUTTON == "right" then
    -- Right click opens system sound preferences
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  local shouldDraw = volumeBracket:query().popup.drawing == "off"
  
  if shouldDraw then
    volumeBracket:set({ popup = { drawing = true } })

    -- Get current audio device
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      if not result or result == "" then
        return
      end
      
      currentAudioDevice = result:gsub("%s+$", "") -- trim whitespace

      -- Get all available audio devices
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        if not available or available == "" then
          return
        end

        local current = currentAudioDevice
        local counter = 0

        for device in string.gmatch(available, '[^\r\n]+') do
          if device and device ~= "" then
            local color = colors.grey
            if current == device then
              color = colors.white
            end

            sbar.add("item", constants.items.VOLUME .. ".device." .. counter, {
              position = "popup." .. volumeBracket.name,
              align = "center",
              label = { string = device, color = color },
              click_script = string.format(
                'SwitchAudioSource -s "%s" && sketchybar --set /%s.device\\.*/ label.color=%s --set $NAME label.color=%s',
                device,
                constants.items.VOLUME,
                colors.grey,
                colors.white
              )
            })
            counter = counter + 1
          end
        end
      end)
    end)
  else
    hideVolumeDetails()
  end
end

-- Change volume via scroll wheel
local function changeVolume(env)
  local delta = tonumber(env.SCROLL_DELTA)
  if delta then
    sbar.exec(string.format(
      'osascript -e "set volume output volume (output volume of (get volume settings) + %d)"',
      delta
    ))
  end
end

-- Event subscriptions
volumeValue:subscribe("mouse.clicked", toggleVolumeDetails)
volumeValue:subscribe("mouse.scrolled", changeVolume)

return { volumeValue, volumeBracket, volumeSlider }
