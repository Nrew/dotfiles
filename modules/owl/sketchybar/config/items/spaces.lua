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
        y_offset = 1
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
      popup = { 
        background = { 
          border_width = 5, 
          border_color = colors.black,
        } 
      }
    })

    -- Store space reference for global updates
    spaces[space_name] = space

    local space_bracket = sbar.add("bracket", { space.name }, {
      background = {
        color = colors.transparent,
        border_color = colors.bg2,
        height = 28,
        border_width = 2,
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

    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.FOCUSED_WORKSPACE == space_name
      
      sbar.animate("tanh", 20, function()
        space:set({
          icon = { 
            highlight = selected,
            color = selected and colors.blue or colors.white,
            font = { size = selected and 16 or 14 }
          },
          label = { 
            highlight = selected,
            color = selected and colors.white or colors.grey
          },
          background = { 
            border_color = selected and colors.blue or colors.bg2,
            color = selected and colors.with_alpha(colors.blue, 0.2) or colors.bg1,
          }
        })
        space_bracket:set({
          background = { 
            border_color = selected and colors.blue or colors.bg2,
            color = selected and colors.with_alpha(colors.blue, 0.1) or colors.transparent
          }
        })
      end)
    end)

    space:subscribe("mouse.entered", function()
      sbar.animate("tanh", 15, function()
        space:set({
          background = {
            color = colors.with_alpha(colors.blue, 0.1),
            border_color = colors.blue,
          },
          icon = {
            color = colors.blue,
          }
        })
        space_bracket:set({
          background = {
            border_color = colors.blue,
            color = colors.with_alpha(colors.blue, 0.05)
          }
        })
      end)
    end)

    space:subscribe("mouse.exited", function()
      local current_workspace = sbar.exec("aerospace list-workspaces --focused"):match("^%s*(.-)%s*$")
      local is_current = current_workspace == space_name
      
      sbar.animate("tanh", 15, function()
        space:set({
          background = {
            color = is_current and colors.with_alpha(colors.blue, 0.2) or colors.bg1,
            border_color = is_current and colors.blue or colors.bg2,
          },
          icon = {
            color = is_current and colors.blue or colors.white,
          }
        })
        space_bracket:set({
          background = {
            border_color = is_current and colors.blue or colors.bg2,
            color = is_current and colors.with_alpha(colors.blue, 0.1) or colors.transparent
          }
        })
      end)
      
      -- Hide popup
      space:set({ popup = { drawing = false } })
    end)

    space:subscribe("mouse.clicked", function(env)
      if env.BUTTON == "other" then
        space_popup:set({ background = { image = "space." .. env.SID } })
        space:set({ popup = { drawing = "toggle" } })
      else
        -- Animate click feedback
        sbar.animate("tanh", 8, function()
          space:set({
            background = { color = colors.with_alpha(colors.blue, 0.4) }
          })
        end)
        
        -- Switch workspace with small delay for visual feedback
        sbar.delay(0.1, function()
          sbar.exec("aerospace workspace " .. space_name)
        end)
      end
    end)
  end
end)

-- Enhanced space window observer
local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

local update_timer = nil
local function debounced_update()
  if update_timer then
    sbar.cancel(update_timer)
  end
  
  update_timer = sbar.delay(0.1, function()
    sbar.exec("aerospace list-windows --format '%{workspace}|%{app-name}' --all", function(windows_output)
      local workspace_apps = {}

      -- Parse all windows in one go
      for line in windows_output:gmatch("[^\r\n]+") do
        local workspace, app = line:match("([^|]+)|(.+)")
        if workspace and app and workspace ~= "" and app ~= "" then
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
    update_timer = nil
  end)
end

space_window_observer:subscribe("space_windows_change", debounced_update)

-- Initial window state update
debounced_update()

-- Enhanced spaces indicator with better animations
local spaces_indicator = sbar.add("item", "spaces_indicator", {
  padding_left = -3,
  padding_right = -5,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
    font = { size = 16 }
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
    font = { style = "Medium" }
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
    corner_radius = 6,
  }
})

-- Fixed event name for menu swapping
spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  
  sbar.animate("tanh", 20, function()
    spaces_indicator:set({
      icon = {
        string = currently_on and icons.switch.off or icons.switch.on,
        color = currently_on and colors.red or colors.green
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 25, function()
    spaces_indicator:set({
      background = {
        color = colors.with_alpha(colors.grey, 1.0),
        border_color = colors.with_alpha(colors.bg1, 1.0),
      },
      icon = { 
        color = colors.bg1,
        font = { size = 18 }
      },
      label = { 
        width = "dynamic",
        color = colors.bg1
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 25, function()
    spaces_indicator:set({
      background = {
        color = colors.with_alpha(colors.grey, 0.0),
        border_color = colors.with_alpha(colors.bg1, 0.0),
      },
      icon = { 
        color = colors.grey,
        font = { size = 16 }
      },
      label = { 
        width = 0,
        color = colors.bg1
      }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  -- Add click animation
  sbar.animate("tanh", 8, function()
    spaces_indicator:set({
      background = { color = colors.with_alpha(colors.blue, 0.3) }
    })
  end)
  
  sbar.delay(0.1, function()
    sbar.trigger("swap_menus_and_spaces")
  end)
end)

-- Add initial workspace highlighting
sbar.delay(0.5, function()
  sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
    local current = focused_workspace:match("^%s*(.-)%s*$")
    if current and spaces[current] then
      spaces[current]:set({
        icon = { 
          highlight = true,
          color = colors.blue,
          font = { size = 16 }
        },
        label = { highlight = true },
        background = { 
          border_color = colors.blue,
          color = colors.with_alpha(colors.blue, 0.2)
        }
      })
    end
  end)
end)