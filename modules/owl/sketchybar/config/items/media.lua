local colors = require("colors")
local settings = require("settings")

local whitelist = { 
  ["Spotify"] = true,
  ["Music"] = true
}

local media_cover = sbar.add("item", {
  position = "right",
  padding_right = settings.dimens.media.cover_padding,
  background = {
    image = {
      string = "media.artwork",
      scale = settings.dimens.media.artwork_scale,
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

local media_artist = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = settings.dimens.padding.tiny,
  padding_right = 0,
  width = 0,
  icon = { drawing = false },
  label = {
    width = 0,
    font = { size = settings.dimens.text.media_artist },
    color = colors.with_alpha(colors.sections.media.label, settings.dimens.media.artist_alpha),
    max_chars = settings.dimens.media.artist_chars,
    y_offset = settings.dimens.media.artist_offset,
  },
})

local media_title = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = settings.dimens.padding.tiny,
  padding_right = 0,
  icon = { drawing = false },
  label = {
    font = { size = settings.dimens.text.media_title },
    color = colors.sections.media.label,
    width = 0,
    max_chars = settings.dimens.media.title_chars,
    y_offset = settings.dimens.media.title_offset,
  },
})

sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = settings.icons.media.back },
  label = { drawing = false },
  click_script = "nowplaying-cli previous",
})

sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = settings.icons.media.play_pause },
  label = { drawing = false },
  click_script = "nowplaying-cli togglePlayPause",
})

sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = settings.icons.media.forward },
  label = { drawing = false },
  click_script = "nowplaying-cli next",
})

local interrupt = 0
local function animate_detail(detail)
  if (not detail) then interrupt = interrupt - 1 end
  if interrupt > 0 and (not detail) then return end

  sbar.animate("tanh", settings.dimens.animation.slow, function()
    media_artist:set({ label = { width = detail and "dynamic" or 0 } })
    media_title:set({ label = { width = detail and "dynamic" or 0 } })
  end)
end

media_cover:subscribe("media_change", function(env)
  if whitelist[env.INFO.app] then
    local drawing = (env.INFO.state == "playing")
    media_artist:set({ drawing = drawing, label = env.INFO.artist })
    media_title:set({ drawing = drawing, label = env.INFO.title })
    media_cover:set({ drawing = drawing })

    if drawing then
      animate_detail(true)
      interrupt = interrupt + 1
      sbar.delay(settings.dimens.animation.delay, animate_detail)
    else
      media_cover:set({ popup = { drawing = false } })
    end
  end
end)

media_cover:subscribe("mouse.entered", function(env)
  interrupt = interrupt + 1
  animate_detail(true)
end)

media_cover:subscribe("mouse.exited", function(env)
  animate_detail(false)
end)

media_cover:subscribe("mouse.clicked", function(env)
  media_cover:set({ popup = { drawing = "toggle" }})
end)

media_title:subscribe("mouse.exited.global", function(env)
  media_cover:set({ popup = { drawing = false }})
end)
