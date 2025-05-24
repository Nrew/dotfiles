local colors = require("colors")
local settings = require("settings")

sbar.exec("killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0")

local popup_width = settings.dimens.graphics.popup.width

local wifi_up = sbar.add("item", "widgets.wifi1", {
  position = "right",
  padding_left = 0,
  padding_right = settings.dimens.wifi.padding_right,
  width = 0,
  label = {
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.bold,
      size = settings.dimens.text.wifi_label,
    },
    color = colors.legacy.red,
    string = "Unknown SSID",
  },
  y_offset = 0,
})

wifi_up:subscribe({"wifi_change", "system_woke"}, function(env)
  sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(result)
    local ssid = result:gsub("\n", "")
    wifi_up:set({
      label = {
        string = ssid,
        color = colors.legacy.red
      }
    })
  end)
end)

local wifi = sbar.add("item", "widgets.wifi.padding", {
  position = "right",
  padding_right = settings.dimens.wifi.padding_main,
  label = { drawing = false },
})

local wifi_bracket = sbar.add("bracket", "widgets.wifi.bracket", {
  wifi.name,
  wifi_up.name,
}, {
  background = { color = colors.legacy.bg1 },
  popup = { align = "left", height = settings.dimens.graphics.bracket.height }
})

local hostname = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Hostname:",
    width = popup_width / settings.dimens.wifi.popup_split,
    color = colors.sections.widgets.wifi.icon,
  },
  label = {
    max_chars = 20,
    string = "????????????",
    width = popup_width / settings.dimens.wifi.popup_split,
    align = "right",
    color = colors.sections.widgets.wifi.icon,
  }
})

local ip = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "IP:",
    width = popup_width / settings.dimens.wifi.popup_split,
    color = colors.sections.widgets.wifi.icon,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / settings.dimens.wifi.popup_split,
    align = "right",
    color = colors.sections.widgets.wifi.icon,
  }
})

local mask = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Subnet mask:",
    width = popup_width / settings.dimens.wifi.popup_split,
    color = colors.sections.widgets.wifi.icon,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / settings.dimens.wifi.popup_split,
    align = "right",
    color = colors.sections.widgets.wifi.icon,
  }
})

local router = sbar.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Router:",
    width = popup_width / settings.dimens.wifi.popup_split,
    color = colors.sections.widgets.wifi.icon,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / settings.dimens.wifi.popup_split,
    align = "right",
    color = colors.sections.widgets.wifi.icon,
  },
})

sbar.add("item", { position = "right", width = settings.dimens.padding.group })

wifi:subscribe({"wifi_change", "system_woke"}, function(env)
  sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "")
    wifi:set({
      icon = {
        string = connected and settings.icons.wifi.connected or settings.icons.wifi.disconnected,
        color = connected and colors.sections.widgets.wifi.icon or colors.legacy.red,
      },
    })
  end)
end)

local function hide_details()
  wifi_bracket:set({ popup = { drawing = false } })
end

local function toggle_details()
  local should_draw = wifi_bracket:query().popup.drawing == "off"
  if should_draw then
    wifi_bracket:set({ popup = { drawing = true }})
    sbar.exec("networksetup -getcomputername", function(result)
      hostname:set({ label = result })
    end)
    sbar.exec("ipconfig getifaddr en0", function(result)
      ip:set({ label = result })
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
      mask:set({ label = result })
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router:set({ label = result })
    end)
  else
    hide_details()
  end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
  local label = sbar.query(env.NAME).label.value
  sbar.exec("echo \"" .. label .. "\" | pbcopy")
  sbar.set(env.NAME, { label = { string = settings.icons.clipboard, align = "center" } })
  sbar.delay(1, function()
    sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)
