local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

sbar.exec("aerospace list-workspaces --all", function(workspace_list)
  for space_name in workspace_list:gmatch("[^\r\n]+") do
    local space = sbar.add("space", "space." .. space_name, {
      space = space_name,
      icon = {
        font = { family = settings.font.space_numbers },
        string = space_name,
        padding_left = 11,
        padding_right = 4,
        color = colors.white,
        highlight_color = colors.blue,
        y_offset = "1"
      },
      label = {
        padding_left = 4,
        padding_right = 12,
        color = colors.grey,
        highlight_color = colors.white,
        font = "sketchybar-app-font:Regular:16.0",
      },
      padding_right = 1,
      padding_left = 1,
      background = {
        color = colors.bg1,
        border_width = 1,
        height = 26,
        border_color = colors.black,
      },
      popup = { background = { border_width = 5, border_color = colors.black } }
    })

    -- Store space reference for global updates
    spaces[space_name] = space

    local space_bracket = sbar.add("bracket", { space.name }, {
      background = {
        color = colors.transparent,
        border_color = colors.bg2,
        height = 28,
        border_width = 2
      }
    })

    -- Padding space
    sbar.add("item", "space.padding." .. space_name, {
      space = space_name,
      script = "",
      width = settings.group_paddings,
    })

    local space_popup = sbar.add("item", {
      position = "popup." .. space.name,
      padding_left = 5,
      padding_right = 0,
      background = {
        drawing = true,
        image = {
          corner_radius = 9,
          scale = 0.2
        }
      }
    })

    -- Enhanced workspace change with animation (like spaces_indicator)
    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.SELECTED == "true"
      
      sbar.animate("tanh", 30, function()
        space:set({
          icon = { highlight = selected },
          label = { highlight = selected },
          background = { border_color = selected and colors.black or colors.bg2 }
        })
        space_bracket:set({
          background = { border_color = selected and colors.grey or colors.bg2 }
        })
      end)
    end)

    -- Add hover animations (like spaces_indicator pattern)
    space:subscribe("mouse.entered", function(env)
      sbar.animate("tanh", 30, function()
        space:set({
          background = {
            color = colors.with_alpha(colors.blue, 0.3),
            border_color = colors.blue,
          },
          icon = { color = colors.blue },
        })
        space_bracket:set({
          background = {
            color = colors.with_alpha(colors.blue, 0.1),
            border_color = colors.blue,
          }
        })
      end)
    end)

    space:subscribe("mouse.exited", function(env)
      local selected = env.SELECTED == "true" -- Check current state
      
      sbar.animate("tanh", 30, function()
        space:set({
          background = {
            color = colors.bg1,
            border_color = selected and colors.black or colors.bg2,
          },
          icon = { color = colors.white },
          popup = { drawing = false }
        })
        space_bracket:set({
          background = {
            color = colors.transparent,
            border_color = selected and colors.grey or colors.bg2,
          }
        })
      end)
    end)

    space:subscribe("mouse.clicked", function(env)
      if env.BUTTON == "other" then
        space_popup:set({ background = { image = "space." .. env.SID } })
        space:set({ popup = { drawing = "toggle" } })
      else
        sbar.exec("aerospace workspace " .. env.SID)
      end
    end)
  end
end)

-- Efficient global space window observer
local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Batch update function for better performance
local function update_space_windows()
  sbar.exec("aerospace list-windows --format '%{workspace}|%{app-name}' --all", function(windows_output)
    local workspace_apps = {}

    -- Parse all windows in one go
    for line in windows_output:gmatch("[^\r\n]+") do
      local workspace, app = line:match("([^|]+)|(.+)")
      if workspace and app then
        if not workspace_apps[workspace] then
          workspace_apps[workspace] = {}
        end
        workspace_apps[workspace][app] = true
      end
    end

    -- Update all spaces
    for space_name, space in pairs(spaces) do
      local apps = workspace_apps[space_name] or {}
      local icon_line = ""
      local no_app = true

      for app, _ in pairs(apps) do
        no_app = false
        local lookup = app_icons[app]
        local icon = (lookup == nil) and app_icons["default"] or lookup
        icon_line = icon_line .. " " .. icon
      end

      if no_app then
        icon_line = " —"
      end

      sbar.animate("tanh", 10, function()
        space:set({ label = icon_line })
      end)
    end
  end)
end

space_window_observer:subscribe("space_windows_change", function(env)
  update_space_windows()
end)

-- Initial window state update
update_space_windows()

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = -5,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)