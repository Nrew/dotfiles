local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

-- Main message item (invisible, used for positioning)
local message = sbar.add("item", constants.items.MESSAGE, {
  width = 0,
  position = "center",
  popup = { align = "center" },
  label = {
    padding_left = 0,
    padding_right = 0,
  },
  background = {
    padding_left = 0,
    padding_right = 0,
  }
})

-- Popup content for displaying the actual message
local messagePopup = sbar.add("item", {
  position = "popup." .. message.name,
  width = "dynamic",
  label = {
    padding_right = settings.dimens.padding.label,
    padding_left = settings.dimens.padding.label,
  },
  icon = {
    padding_left = 0,
    padding_right = 0,
  },
})

-- Hide the message popup
local function hideMessage()
  message:set({ popup = { drawing = false } })
end

-- Show a message with optional auto-hide
local function showMessage(content, hold)
  if not content or content == "" then
    return
  end

  -- Hide any existing message first
  hideMessage()

  -- Show the new message
  message:set({ popup = { drawing = true } })
  messagePopup:set({ label = { string = content } })

  -- Auto-hide after 5 seconds unless hold is true
  if not hold then
    sbar.delay(5, function()
      hideMessage()
    end)
  end
end

-- Subscribe to message display events
message:subscribe(constants.events.SEND_MESSAGE, function(env)
  local content = env.MESSAGE
  local hold = env.HOLD and env.HOLD == "true"
  showMessage(content, hold)
end)

-- Subscribe to message hide events
message:subscribe(constants.events.HIDE_MESSAGE, hideMessage)

return { message, messagePopup }
