local colors = require("colors")
local settings = require("settings")

-- Whitelist of supported media applications
local whitelist = {
  ["Psst"] = true,
  ["Spotify"] = true,
  ["Music"] = true,
  ["TIDAL"] = true,
  ["Podcasts"] = true,
}

-- Media cover art display
local media_cover = sbar.add("item", {
  position = "left",
  background = {
    image = {
      string = "media.artwork",
      scale = 0.80,
    },
    color = colors.transparent,
  },
  label = { drawing = false },
  icon = { drawing = false },
  drawing = false,
  updates = true,
  popup = {
    align = "center",
    horizontal = true,
  }
})

-- Media artist display
local media_artist = sbar.add("item", {
  position = "left",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  width = 0,
  icon = { drawing = false },
  label = {
    width = 0,
    font = { size = 9 },
    color = colors.with_alpha(colors.white, 0.6),
    max_chars = 24,
    y_offset = 6,
  },
})

-- Media title display
local media_title = sbar.add("item", {
  position = "left",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  icon = { drawing = false },
  label = {
    font = { size = 11 },
    width = 0,
    max_chars = 35,
    y_offset = -5,
  },
})

-- Media control buttons in popup
local media_previous = sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = settings.text.media.back },
  label = { drawing = false },
  click_script = "nowplaying-cli previous",
})

local media_play_pause = sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = settings.text.media.play_pause },
  label = { drawing = false },
  click_script = "nowplaying-cli togglePlayPause",
})

local media_next = sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = settings.text.media.forward },
  label = { drawing = false },
  click_script = "nowplaying-cli next",
})

-- Animation control variables
local interrupt = 0

-- Animate media details visibility
local function animate_detail(detail)
  if not detail then
    interrupt = interrupt - 1
  end

  if interrupt > 0 and not detail then
    return
  end

  sbar.animate("tanh", 30, function()
    media_artist:set({
      label = { width = detail and "dynamic" or 0 }
    })
    media_title:set({
      label = { width = detail and "dynamic" or 0 }
    })
  end)
end

-- Handle media state changes
media_cover:subscribe("media_change", function(env)
  if not env.INFO or not env.INFO.app then
    return
  end

  -- Check if the app is in our whitelist
  if whitelist[env.INFO.app] then
    local drawing = (env.INFO.state == "playing")

    -- Update media information
    media_artist:set({
      drawing = drawing,
      label = env.INFO.artist or "Unknown Artist"
    })

    media_title:set({
      drawing = drawing,
      label = env.INFO.title or "Unknown Title"
    })

    media_cover:set({ drawing = drawing })

    if drawing then
      animate_detail(true)
      interrupt = interrupt + 1
      -- Auto-hide details after 5 seconds
      sbar.delay(5, animate_detail)
    else
      media_cover:set({ popup = { drawing = false } })
    end
  end
end)

-- Show details on mouse enter
media_cover:subscribe("mouse.entered", function(env)
  interrupt = interrupt + 1
  animate_detail(true)
end)

-- Hide details on mouse exit
media_cover:subscribe("mouse.exited", function(env)
  animate_detail(false)
end)

-- Toggle media controls popup
media_cover:subscribe("mouse.clicked", function(env)
  media_cover:set({ popup = { drawing = "toggle" } })
end)

-- Hide popup when mouse leaves the title area
media_title:subscribe("mouse.exited.global", function(env)
  media_cover:set({ popup = { drawing = false } })
end)

return {
  media_cover,
  media_artist,
  media_title,
  media_previous,
  media_play_pause,
  media_next
}