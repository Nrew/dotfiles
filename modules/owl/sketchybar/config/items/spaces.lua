local colors = require("colors").sections.spaces
local settings = require("settings")

local function add_windows(space, space_name)
  sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
    local icon_line = ""
    for app in windows:gmatch "[^\r\n]+" do
      local lookup = settings.apps[app]
      local icon = ((lookup == nil) and settings.apps["Default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    sbar.animate("tanh", settings.dimens.animation.medium, function()
      space:set {
        label = {
          string = icon_line == "" and "—" or icon_line,
          padding_right = icon_line == "" and settings.dimens.padding.base or settings.dimens.spaces.fallback_padding,
        },
      }
    end)
  end)
end

sbar.exec("aerospace list-workspaces --all", function(spaces)
  for space_name in spaces:gmatch "[^\r\n]+" do
    local space = sbar.add("item", "space." .. space_name, {
      icon = {
        string = space_name,
        color = colors.icon.color,
        highlight_color = colors.icon.highlight,
        padding_left = settings.dimens.padding.base,
      },
      label = {
        font = settings.fonts.icons(settings.dimens.text.spaces_font),
        string = "",
        color = colors.label.color,
        highlight_color = colors.label.highlight,
        y_offset = settings.dimens.spaces.label_offset,
      },
      click_script = "aerospace workspace " .. space_name,
      padding_left = space_name == "1" and 0 or settings.dimens.padding.micro,
    })

    add_windows(space, space_name)

    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.FOCUSED_WORKSPACE == space_name
      space:set {
        icon = { highlight = selected },
        label = { highlight = selected },
      }

      if selected then
        sbar.animate("tanh", settings.dimens.animation.fast, function()
          space:set {
            background = { shadow = { distance = 0 } },
            y_offset = settings.dimens.spaces.animation_offset,
            padding_left = settings.dimens.padding.base,
            padding_right = 0,
          }
          space:set {
            background = { shadow = { distance = settings.dimens.spaces.shadow_distance } },
            y_offset = 0,
            padding_left = settings.dimens.padding.micro,
            padding_right = settings.dimens.padding.micro,
          }
        end)
      end
    end)

    space:subscribe("space_windows_change", function()
      add_windows(space, space_name)
    end)

    space:subscribe("mouse.clicked", function()
      sbar.animate("tanh", settings.dimens.animation.fast, function()
        space:set {
          background = { shadow = { distance = 0 } },
          y_offset = settings.dimens.spaces.animation_offset,
          padding_left = settings.dimens.padding.base,
          padding_right = 0,
        }
        space:set {
          background = { shadow = { distance = settings.dimens.spaces.shadow_distance } },
          y_offset = 0,
          padding_left = settings.dimens.padding.micro,
          padding_right = settings.dimens.padding.micro,
        }
      end)
    end)
  end
end)

local spaces_indicator = sbar.add("item", {
  icon = {
    padding_left = settings.dimens.padding.base,
    padding_right = settings.dimens.spaces.indicator_padding,
    string = settings.icons.switch.on,
    color = colors.indicator,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = settings.dimens.padding.base,
  },
  padding_right = settings.dimens.padding.base,
})

spaces_indicator:subscribe("swap_menus_and_spaces", function()
  local currently_on = spaces_indicator:query().icon.value == settings.icons.switch.on
  spaces_indicator:set {
    icon = currently_on and settings.icons.switch.off or settings.icons.switch.on,
  }
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.animate("tanh", settings.dimens.animation.fast, function()
    spaces_indicator:set {
      background = { shadow = { distance = 0 } },
      y_offset = settings.dimens.spaces.animation_offset,
      padding_left = settings.dimens.padding.base,
      padding_right = settings.dimens.padding.micro,
    }
    spaces_indicator:set {
      background = { shadow = { distance = settings.dimens.spaces.shadow_distance } },
      y_offset = 0,
      padding_left = settings.dimens.padding.micro,
      padding_right = settings.dimens.padding.base,
    }
  end)

  sbar.trigger("swap_menus_and_spaces")
end)
