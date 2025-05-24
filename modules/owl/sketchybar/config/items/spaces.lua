local colors = require("colors").sections.spaces
local settings = require("settings")

local spaces = {}

local function add_windows(space, space_name)
  sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
    local icon_line = ""
    local no_app = true
    
    for app in windows:gmatch "[^\r\n]+" do
      no_app = false
      local lookup = settings.apps[app]
      local icon = ((lookup == nil) and settings.apps["Default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    if no_app then
      icon_line = "—"
    end

    sbar.animate("tanh", settings.dimens.animation.medium, function()
      space:set {
        label = {
          string = icon_line,
          padding_right = icon_line == "—" and settings.dimens.padding.base or settings.dimens.spacing.fallback_padding,
        },
      }
    end)
  end)
end

-- Get all aerospace workspaces and create space items
sbar.exec("aerospace list-workspaces --all", function(workspace_list)
  for space_name in workspace_list:gmatch "[^\r\n]+" do
    local space = sbar.add("space", "space." .. space_name, {
      space = space_name,
      icon = {
        font = { 
          family = settings.fonts.family,
          style = settings.fonts.styles.bold,
          size = settings.dimens.text.icon
        },
        string = space_name,
        padding_left = 11,
        padding_right = 4,
        color = colors.icon.color,
        highlight_color = colors.icon.highlight,
        y_offset = 1
      },
      label = {
        font = settings.fonts.icons(16.0),
        padding_left = 4,
        padding_right = 12,
        color = colors.label.color,
        highlight_color = colors.label.highlight,
        y_offset = settings.dimens.spaces.label_offset,
      },
      padding_right = 1,
      padding_left = 1,
      background = {
        color = colors.sections.item.bg,
        border_width = 1,
        height = 26,
        border_color = colors.sections.item.border,
      },
      popup = { 
        background = { 
          border_width = 5, 
          border_color = colors.sections.item.border 
        } 
      }
    })

    spaces[space_name] = space

    -- Single item bracket for space items to achieve double border on highlight
    local space_bracket = sbar.add("bracket", { space.name }, {
      background = {
        color = colors.transparent,
        border_color = colors.sections.item.bg,
        height = 28,
        border_width = 2
      }
    })

    -- Padding space (using regular item since aerospace doesn't support space padding)
    sbar.add("item", "space.padding." .. space_name, {
      width = settings.dimens.padding.group,
      drawing = true,
    })

    -- Popup item for space preview (if screenshots are available)
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

    -- Add windows to space initially
    add_windows(space, space_name)

    -- Subscribe to aerospace workspace changes
    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.FOCUSED_WORKSPACE == space_name
      local border_color = selected and colors.sections.item.border or colors.sections.item.bg
      
      space:set({
        icon = { highlight = selected },
        label = { highlight = selected },
        background = { border_color = border_color }
      })
      
      space_bracket:set({
        background = { border_color = selected and colors.label.color or colors.sections.item.bg }
      })

      -- Add animation effect on selection
      if selected then
        sbar.animate("tanh", settings.dimens.animation.fast, function()
          space:set {
            background = { shadow = { distance = 0 } },
            y_offset = settings.dimens.spaces.animation_offset,
            padding_left = settings.dimens.padding.base,
            padding_right = 0,
          }
        end)
        sbar.animate("tanh", settings.dimens.animation.fast, function()
          space:set {
            background = { shadow = { distance = settings.dimens.spaces.shadow_distance } },
            y_offset = 0,
            padding_left = 1,
            padding_right = 1,
          }
        end)
      end
    end)

    -- Handle space windows change
    space:subscribe("space_windows_change", function()
      add_windows(space, space_name)
    end)

    -- Mouse interactions
    space:subscribe("mouse.clicked", function(env)
      if env.BUTTON == "other" then
        -- Middle click - show space preview popup
        space_popup:set({ background = { image = "space." .. space_name } })
        space:set({ popup = { drawing = "toggle" } })
      elseif env.BUTTON == "right" then
        -- Right click - additional actions could be added here
        -- For now, just focus the workspace
        sbar.exec("aerospace workspace " .. space_name)
      else
        -- Left click - focus workspace
        sbar.exec("aerospace workspace " .. space_name)
        
        -- Animation feedback
        sbar.animate("tanh", settings.dimens.animation.fast, function()
          space:set {
            background = { shadow = { distance = 0 } },
            y_offset = settings.dimens.spaces.animation_offset,
            padding_left = settings.dimens.padding.base,
            padding_right = 0,
          }
        end)
        sbar.animate("tanh", settings.dimens.animation.fast, function()
          space:set {
            background = { shadow = { distance = settings.dimens.spaces.shadow_distance } },
            y_offset = 0,
            padding_left = 1,
            padding_right = 1,
          }
        end)
      end
    end)

    -- Hide popup when mouse exits
    space:subscribe("mouse.exited", function(_)
      space:set({ popup = { drawing = false } })
    end)
  end
end)

-- Spaces indicator with enhanced styling and hover effects
local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = -5,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.label.color,
    string = settings.icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.sections.item.bg,
    font = {
      family = settings.fonts.family,
      style = settings.fonts.styles.semibold,
      size = settings.dimens.text.label
    }
  },
  background = {
    color = colors.with_alpha(colors.label.color, 0.0),
    border_color = colors.with_alpha(colors.sections.item.bg, 0.0),
    corner_radius = settings.dimens.graphics.background.corner_radius,
  }
})

-- Subscribe to swap event for menu/spaces toggle
spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == settings.icons.switch.on
  spaces_indicator:set({
    icon = currently_on and settings.icons.switch.off or settings.icons.switch.on
  })
end)

-- Enhanced hover effects
spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", settings.dimens.animation.slow, function()
    spaces_indicator:set({
      background = {
        color = colors.with_alpha(colors.label.color, 1.0),
        border_color = colors.with_alpha(colors.sections.item.bg, 1.0),
      },
      icon = { color = colors.sections.item.bg },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", settings.dimens.animation.slow, function()
    spaces_indicator:set({
      background = {
        color = colors.with_alpha(colors.label.color, 0.0),
        border_color = colors.with_alpha(colors.sections.item.bg, 0.0),
      },
      icon = { color = colors.label.color },
      label = { width = 0 }
    })
  end)
end)

-- Click handler for spaces indicator
spaces_indicator:subscribe("mouse.clicked", function(env)
  -- Animation feedback
  sbar.animate("tanh", settings.dimens.animation.fast, function()
    spaces_indicator:set {
      background = { shadow = { distance = 0 } },
      y_offset = settings.dimens.spaces.animation_offset,
      padding_left = settings.dimens.padding.base,
      padding_right = settings.dimens.padding.space_micro,
    }
  end)
  sbar.animate("tanh", settings.dimens.animation.fast, function()
    spaces_indicator:set {
      background = { shadow = { distance = settings.dimens.spaces.shadow_distance } },
      y_offset = 0,
      padding_left = settings.dimens.padding.space_micro,
      padding_right = settings.dimens.padding.base,
    }
  end)

  -- Trigger the menu/spaces swap
  sbar.trigger("swap_menus_and_spaces")
end)

-- Return the spaces table for external access
return { spaces = spaces, indicator = spaces_indicator }
