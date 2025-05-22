local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

local popupWidth = settings.dimens.graphics.popup.width + 20

-- Start network monitoring daemon
sbar.exec(
  "killall network_load >/dev/null 2>&1; $CONFIG_DIR/bridge/network_load/bin/network_load en0 network_update 2.0"
)

-- Network upload indicator
local wifiUp = sbar.add("item", constants.items.WIFI .. ".up", {
  position = "right",
  width = 0,
  icon = {
    padding_left = 0,
    padding_right = 0,
    font = {
      style = settings.fonts.styles.bold,
      size = 10.0,
    },
    string = settings.text.wifi.upload,
  },
  label = {
    font = {
      family = settings.fonts.numbers,
      style = settings.fonts.styles.bold,
      size = 10.0,
    },
    color = colors.orange,
    string = "--- Bps",
  },
  y_offset = 4,
})

-- Network download indicator
local wifiDown = sbar.add("item", constants.items.WIFI .. ".down", {
  position = "right",
  icon = {
    padding_left = 0,
    padding_right = 0,
    font = {
      style = settings.fonts.styles.bold,
      size = 10.0,
    },
    string = settings.text.wifi.download,
  },
  label = {
    font = {
      family = settings.fonts.numbers,
      style = settings.fonts.styles.bold,
      size = 10,
    },
    color = colors.blue,
    string = "--- Bps",
  },
  y_offset = -4,
})

-- WiFi status indicator
local wifi = sbar.add("item", constants.items.WIFI .. ".padding", {
  position = "right",
  label = { drawing = false },
  padding_right = 0,
})

-- Group WiFi elements in a bracket
local wifiBracket = sbar.add("bracket", constants.items.WIFI .. ".bracket", {
  wifi.name,
  wifiUp.name,
  wifiDown.name
}, {
  popup = { align = "center" }
})

-- Popup elements for detailed network information
local ssid = sbar.add("item", {
  align = "center",
  position = "popup." .. wifiBracket.name,
  width = popupWidth,
  background = { height = 16 },
  icon = {
    string = settings.text.wifi.router,
    font = { style = settings.fonts.styles.bold },
  },
  label = {
    font = {
      style = settings.fonts.styles.bold,
      size = settings.dimens.text.label,
    },
    max_chars = 18,
    string = "Loading...",
  },
})

local hostname = sbar.add("item", {
  position = "popup." .. wifiBracket.name,
  background = { height = 16 },
  icon = {
    align = "left",
    string = "Hostname:",
    width = popupWidth / 2,
    font = { size = settings.dimens.text.label },
  },
  label = {
    max_chars = 20,
    string = "Loading...",
    width = popupWidth / 2,
    align = "right",
  }
})

local ip = sbar.add("item", {
  position = "popup." .. wifiBracket.name,
  background = { height = 16 },
  icon = {
    align = "left",
    string = "IP:",
    width = popupWidth / 2,
    font = { size = settings.dimens.text.label },
  },
  label = {
    align = "right",
    string = "Loading...",
    width = popupWidth / 2,
  }
})

local router = sbar.add("item", {
  position = "popup." .. wifiBracket.name,
  background = { height = 16 },
  icon = {
    align = "left",
    string = "Router:",
    width = popupWidth / 2,
    font = { size = settings.dimens.text.label },
  },
  label = {
    align = "right",
    string = "Loading...",
    width = popupWidth / 2,
  },
})

-- Add spacing after WiFi widgets
sbar.add("item", { position = "right", width = settings.dimens.padding.item })

-- Update network upload/download indicators
wifiUp:subscribe("network_update", function(env)
  local upColor = (env.upload == "000 Bps") and colors.grey or colors.orange
  local downColor = (env.download == "000 Bps") and colors.grey or colors.blue

  wifiUp:set({
    icon = { color = upColor },
    label = {
      string = env.upload,
      color = upColor
    }
  })
  
  wifiDown:set({
    icon = { color = downColor },
    label = {
      string = env.download,
      color = downColor
    }
  })
end)

-- Update WiFi connection status
wifi:subscribe({ "wifi_change", "system_woke", "forced" }, function(env)
  -- Start with disconnected state
  wifi:set({
    icon = {
      string = settings.text.wifi.disconnected,
      color = colors.red,
    }
  })

  -- Check for network connectivity
  sbar.exec("ipconfig getifaddr en0", function(ip)
    local ipConnected = ip and ip ~= ""
    local wifiIcon = settings.text.wifi.disconnected
    local wifiColor = colors.red

    if ipConnected then
      wifiIcon = settings.text.wifi.connected
      wifiColor = colors.white

      -- Check for VPN connection
      sbar.exec("scutil --nwi | grep -m1 'utun' | awk '{ print $1 }'", function(vpn)
        local isVPNConnected = vpn and vpn ~= ""

        if isVPNConnected then
          wifiIcon = "🔒"  -- VPN indicator (could be customized)
          wifiColor = colors.green
        end

        wifi:set({
          icon = {
            string = wifiIcon,
            color = wifiColor,
          }
        })
      end)
    else
      wifi:set({
        icon = {
          string = wifiIcon,
          color = wifiColor,
        }
      })
    end
  end)
end)

-- Popup management functions
local function hideDetails()
  wifiBracket:set({ popup = { drawing = false } })
end

local function toggleDetails()
  local shouldDrawDetails = wifiBracket:query().popup.drawing == "off"

  if shouldDrawDetails then
    wifiBracket:set({ popup = { drawing = true } })
    
    -- Update all network information
    sbar.exec("networksetup -getcomputername", function(result)
      hostname:set({ label = result and result ~= "" and result or "Unknown" })
    end)
    
    sbar.exec("ipconfig getifaddr en0", function(result)
      ip:set({ label = result and result ~= "" and result or "Not connected" })
    end)
    
    sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(result)
      ssid:set({ label = result and result ~= "" and result or "No network" })
    end)
    
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router:set({ label = result and result ~= "" and result or "Unknown" })
    end)
  else
    hideDetails()
  end
end

-- Copy label to clipboard functionality
local function copyLabelToClipboard(env)
  local label = sbar.query(env.NAME).label.value
  if label and label ~= "" then
    sbar.exec("echo \"" .. label .. "\" | pbcopy")
    sbar.set(env.NAME, { label = { string = "📋", align = "center" } })
    sbar.delay(1, function()
      sbar.set(env.NAME, { label = { string = label, align = "right" } })
    end)
  end
end

-- Event subscriptions
wifiUp:subscribe("mouse.clicked", toggleDetails)
wifiDown:subscribe("mouse.clicked", toggleDetails)
wifi:subscribe("mouse.clicked", toggleDetails)

ssid:subscribe("mouse.clicked", copyLabelToClipboard)
hostname:subscribe("mouse.clicked", copyLabelToClipboard)
ip:subscribe("mouse.clicked", copyLabelToClipboard)
router:subscribe("mouse.clicked", copyLabelToClipboard)

return { wifi, wifiUp, wifiDown, wifiBracket }
