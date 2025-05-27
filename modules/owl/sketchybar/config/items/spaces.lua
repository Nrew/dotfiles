local colors    = require("colors")
local icons     = require("icons")
local settings  = require("settings")
local app_icons = require("helpers.app_icons")

-- -- Stores { [space_name] = { item = space_obj, bracket = bracket_obj, popup = popup_obj, is_active = false } }
local spaces_props = {}

local function update_workspaces_visuals(focused_workspace)
  for name, data in pairs(spaces_props) do
    local is_active = (name == focused_workspace)
    data.is_active = is_active

    local query_result = data.item:query()
    local is_hovered = query_result.mouse.over == "true"

    if not is_hovered then
      sbar.animate("tanh", 30, function()
        data.item:set({
          icon = { highlight = is_active, color = is_active and colors.red or colors.white },
          label = { highlight = is_active, color = is_active and colors.red or colors.grey },
          background = {
            border_color = is_active and colors.red or colors.bg2,
            color = is_active and colors.with_alpha(colors.red, 0.2) or colors.bg1
          }
        })
        data.bracket:set({
          background = {
            border_color = is_active and colors.red or colors.bg2,
            color = is_active and colors.with_alpha(colors.red, 0.1) or colors.transparent
          }
        })
      end)
    end
  end
end

local aerospace_listener = sbar.add("item", "aerospace_listener", { drawing = false })
aerospace_listener:subscribe("aerospace_workspace_change", function(env)
  if env.WORKSPACE then
    update_workspaces_visuals(env.WORKSPACE)
  else
    sbar.exec("aerospace list-workspaces --focused", function(focused_raw)
      local focused = focused_raw:match("^%s*(.-)%s*$")
      if focused then update_workspaces_visuals(focused) end
    end)
  end
end)

local function update_workspace()
  sbar.exec("aerospace list-windows --format '%{workspace}|%{app-name}' --all", function(windows_output)
    local workspace_apps = {}
    for line in windows_output:gmatch("[^\r\n]+") do
      local workspace, app = line:match("([^|]+)|(.+)")
      if workspace and app then
          workspace_apps[workspace] = workspace_apps[workspace] or {}
          table.insert(workspace_apps[workspace], app)
        end
     end

     for space_name, data in pairs(spaces_props) do
      local apps_in_space = workspace_apps[space_name]
      local icon_list = {}
      local no_app = true

      if apps_in_space then
        for _, app_name in ipairs(apps_in_space) do
          no_app = false
          local icon = app_icons[app_name] or app_icons["default"]
          table.insert(icon_list, icon)
        end
      end

      local label_string = no_app and " —" or table.concat(icon_list, " ")
      data.item:set({ label = label_string })
    end
  end)
end

sbar.exec("aerospace list-workspaces --all", function(workspace_list)
  local workspace_names = {}
  for name in workspace_list:gmatch("[^\r\n]+") do
    table.insert(workspace_names, name)
  end

  for _, space_name in ipairs(workspace_names) do 
    local item = sbar.add("space", "space." .. space_name, {
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
      padding_right = 1 + (settings.group_paddings or 0),
      padding_left = 1,
      background = { color = colors.bg1, border_width = 1, height = 26, border_color = colors.black, },
      popup = { background = { border_width = 5, border_color = colors.black } }
    })

    local bracket_item_name = "bracket." .. space_name
    local bracket_item = sbar.add("bracket", { space_name }, {
      background = {
        color = colors.transparent,
        border_color = colors.bg2,
        height = 28,
        border_width = 2
      }
    })

    local popup_item = sbar.add("item", "popup." .. space_name, {
      position = "popup." .. space_name,
      padding_left = 5,
      padding_right = 0,
      background = {
        drawing = true,
        image = { corner_radius = 9, scale = 0.25, },
      }
    })

    spaces_props[space_name] = {
      item = item,
      bracket = bracket_item,
      popup = popup_item,
      is_active = false
    }

    -- Add hover animations with gold coloring
    item:subscribe("mouse.entered", function(env)
      sbar.animate("tanh", 30, function()
        item:set({
          background = {
            color = colors.with_alpha(colors.yellow, 0.3), -- Gold hover background
            border_color = colors.yellow, -- Gold hover border
          },
          icon = { color = colors.yellow }, -- Gold hover icon
        })
        bracket_item:set({
          background = {
            color = colors.with_alpha(colors.yellow, 0.1), -- Gold hover bracket
            border_color = colors.yellow,
          }
        })
      end)
    end)

    item:subscribe("mouse.exited", function(env)
      local data = spaces_props[space_name]
      local is_active = data.is_active
      sbar.animate("tanh", 30, function()
        item:set({
          background = {
            color = is_active and colors.with_alpha(colors.red, 0.2) or colors.bg1, -- Return to red if active
            border_color = is_active and colors.red or colors.bg2, -- Return to red if active
          },
          icon = { color = is_active and colors.red or colors.white }, -- Return to red if active
        })
        bracket_item:set({
          background = {
            color = is_active and colors.with_alpha(colors.red, 0.1) or colors.transparent, -- Return to red if active
            border_color = is_active and colors.red or colors.bg2, -- Return to red if active
          }
        })
      end)
    end)
    
    item:subscribe("mouse.clicked", function(env)
      if env.BUTTON == "other" then
        popup_item:set({ background = { image = "space." .. space_name } })
        item:set({ popup = { drawing = "toggle" } })
      else
        sbar.exec("aerospace workspace " .. space_name)
      end
    end)
  end

  sbar.exec("aerospace list-workspaces --focused", function(focused_raw)
    local focused = focused_raw:match("^%s*(.-)%s*$")
    if focused then update_workspaces_visuals(focused) end
  end)
  update_workspace()
end)

-- Enhanced window observer to also handle workspace highlighting
local space_window_observer = sbar.add("item", "space_window_observer", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe("space_window_change", function(env)
  update_workspace()
end)


local spaces_indicator = sbar.add("item", "space_indicator", {
  padding_left = -3, padding_right = -5,
  icon = { padding_left = 8, padding_right = 9, color = colors.grey, string = icons.switch.on },
  label = { width = 0, padding_left = 0, padding_right = 8, string = "Spaces", color = colors.bg1 },
  background = { color = colors.with_alpha(colors.grey, 0.0), border_color = colors.with_alpha(colors.bg1, 0.0) },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({ icon = currently_on and icons.switch.off or icons.switch.on })
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