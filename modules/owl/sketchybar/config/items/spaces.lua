local colors    = require("colors")
local icons     = require("icons")
local settings  = require("settings")
local app_icons = require("helpers.app_icons")

local workspaces = {}
local spaces_props = {}

local query_workspaces = "aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"
local get_windows = "aerospace list-windows --monitor all --format '%{workspace}%{app-name}' --json"
local query_visible_workspaces = "aerospace list-workspaces --visible --monitor all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"
local get_focused_workspace = "aerospace list-workspaces --focused"

local function withWorkspaceData(callback)
  local open_windows = {}

  sbar.exec(get_windows, function(workspace_and_windows)
    for _, entry in ipairs(workspace_and_windows) do
      local workspace_index = entry.workspace
      local app = entry["app-name"]
      if open_windows[workspace_index] == nil then
        open_windows[workspace_index] = {}
      end
      table.insert(open_windows[workspace_index], app)
    end

    sbar.exec(get_focused_workspace, function(focused_workspace)
      local focused = focused_workspace:match("^%s*(.-)%s*$")

      sbar.exec(query_visible_workspaces, function(visible_workspaces)

        callback({
          open_windows = open_windows,
          focused_workspace = focused,
          visible_workspaces = visible_workspaces
        })
      end)
    end)
  end)
end

local function updateWorkspace(workspace_index, data)
  local workspace_apps = data.open_windows[workspace_index] or {}
  local focused_workspace = data.focused_workspace
  local visible_workspaces = data.visible_workspaces

  local is_focused = (workspace_index == focused_workspace)
  local is_visible = false
  local monitor_id = nil

  for _, visible_workspace in ipairs(visible_workspaces) do
    if workspace_index == visible_workspace.workspace then
      is_visible = true
      monitor_id = math.floor(visible_workspace["monitor-appkit-nsscreen-screens-id"])
      break
    end
  end

  local icon_list = {}
  local no_app = (#workspace_apps == 0)

  for _, app_name in ipairs(workspace_apps) do
    local icon = app_icons[app_name] or app_icons["default"]
    table.insert(icon_list, icon)
  end

  local label_string = no_app and " —" or table.concat(icon_list, " ")

  local space_item = workspaces[workspace_index]
  local space_props = spaces_props[workspace_index]

  if not space_item or not space_props then return end

  local should_show = is_visible or is_focused

  if not should_show then
    sbar.animate("tanh", 30, function()
      space_item:set({
        icon = { drawing = false },
        label = { drawing = false },
        background = { drawing = false },
        padding_right = 0,
        padding_left = 0,
      })
      if space_props.bracket then
        space_props.bracket:set({
          background = { drawing = false }
        })
      end
    end)
    return
  end

  sbar.animate("tanh", 30, function()
    space_item:set({
      icon = {
        drawing = true,
        highlight = is_focused,
        color = is_focused and colors.red or colors.white
      },
      label = {
        drawing = true,
        string = label_string,
        highlight = is_focused,
        color = is_focused and colors.red or colors.grey
      },
      background = {
        drawing = true,
        border_color = is_focused and colors.red or colors.bg2,
        color = is_focused and colors.with_alpha(colors.red, 0.2) or colors.bg1
      },
      padding_right = 1,
      padding_left = 1,
      display = monitor_id
    })

    if space_props.bracket then
      space_props.bracket:set({
        background = {
          drawing = true,
          border_color = is_focused and colors.red or colors.bg2,
          color = is_focused and colors.with_alpha(colors.red, 0.1) or colors.transparent
        }
      })
    end
  end)
end

-- Update all workspaces
local function updateAllWorkspaces()
  withWorkspaceData(function(data)
    for workspace_index, _ in pairs(workspaces) do
      updateWorkspace(workspace_index, data)
    end
  end)
end

-- Update workspace-to-monitor assignments
local function updateWorkspaceMonitors()
  sbar.exec(query_workspaces, function(workspaces_and_monitors)
    local workspace_monitor = {}
    for _, entry in ipairs(workspaces_and_monitors) do
      local space_index = entry.workspace
      local monitor_id = math.floor(entry["monitor-appkit-nsscreen-screens-id"])
      workspace_monitor[space_index] = monitor_id
    end

    for workspace_index, workspace_item in pairs(workspaces) do
      workspace_item:set({
        display = workspace_monitor[workspace_index]
      })
    end
  end)
end

-- Initialize workspaces using JSON query
sbar.exec(query_workspaces, function(workspaces_and_monitors)
  for _, entry in ipairs(workspaces_and_monitors) do
    local workspace_index = entry.workspace

    local space_item = sbar.add("item", "space." .. workspace_index, {
      icon = {
        font = { family = settings.font.space_numbers },
        string = workspace_index,
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
        border_color = colors.black
      },
      popup = {
        background = {
          border_width = 5,
          border_color = colors.black
        }
      },
      click_script = "aerospace workspace " .. workspace_index,
    })

    local bracket_item = sbar.add("bracket", "bracket." .. workspace_index, { "space." .. workspace_index }, {
      background = {
        color = colors.transparent,
        border_color = colors.bg2,
        height = 28,
        border_width = 2
      }
    })

    local popup_item = sbar.add("item", "popup." .. workspace_index, {
      position = "popup." .. space_item.name,
      padding_left = 5,
      padding_right = 0,
      background = {
        drawing = true,
        image = { corner_radius = 9, scale = 0.2 },
      }
    })

    -- Store references
    workspaces[workspace_index] = space_item
    spaces_props[workspace_index] = {
      item = space_item,
      bracket = bracket_item,
      popup = popup_item,
      is_active = false
    }

    space_item:subscribe("aerospace_workspace_change", function(env)
      local focused_workspace = env.FOCUSED_WORKSPACE
      local is_focused = (focused_workspace == workspace_index)

      spaces_props[workspace_index].is_active = is_focused

      local query_result = space_item:query()
      local is_hovered = query_result and query_result.mouse and query_result.mouse.over == "true"

      if is_hovered then return end

      sbar.animate("tanh", 30, function()
        space_item:set({
          icon = { highlight = is_focused, color = is_focused and colors.red or colors.white },
          label = { highlight = is_focused, color = is_focused and colors.red or colors.grey },
          background = {
            border_color = is_focused and colors.red or colors.bg2,
            color = is_focused and colors.with_alpha(colors.red, 0.2) or colors.bg1
          }
        })
        bracket_item:set({
          background = {
            border_color = is_focused and colors.red or colors.bg2,
            color = is_focused and colors.with_alpha(colors.red, 0.1) or colors.transparent
          }
        })
      end)
    end)

    space_item:subscribe("mouse.entered", function()
      sbar.animate("tanh", 30, function()
        space_item:set({
          background = {
            color = colors.with_alpha(colors.yellow, 0.3),
            border_color = colors.yellow,
          },
          icon = { color = colors.yellow },
        })
        bracket_item:set({
          background = {
            color = colors.with_alpha(colors.yellow, 0.1),
            border_color = colors.yellow
          }
        })
      end)
    end)

    space_item:subscribe("mouse.exited", function()
      local is_active = spaces_props[workspace_index].is_active
      sbar.animate("tanh", 30, function()
        space_item:set({
          background = {
            color = is_active and colors.with_alpha(colors.red, 0.2) or colors.bg1,
            border_color = is_active and colors.red or colors.bg2,
          },
          icon = { color = is_active and colors.red or colors.white },
        })
        bracket_item:set({
          background = {
            color = is_active and colors.with_alpha(colors.red, 0.1) or colors.transparent,
            border_color = is_active and colors.red or colors.bg2,
          }
        })
      end)
    end)

    space_item:subscribe("mouse.clicked", function(env)
      if env.BUTTON == "other" then
        popup_item:set({ background = { image = "space." .. workspace_index } })
        space_item:set({ popup = { drawing = "toggle" } })
      end
    end)
  end

  updateAllWorkspaces()
  updateWorkspaceMonitors()

  sbar.add("item", "workspace_events", { drawing = false, updates = true }):subscribe("aerospace_focus_change", function()
    updateAllWorkspaces()
  end)

  sbar.add("item", "display_events", { drawing = false, updates = true }):subscribe("display_change", function()
    updateWorkspaceMonitors()
    updateAllWorkspaces()
  end)

  sbar.exec(get_focused_workspace, function(focused_workspace)
    local focused = focused_workspace:match("^%s*(.-)%s*$")
    if workspaces[focused] then
      workspaces[focused]:set({
        icon = { highlight = true },
        label = { highlight = true },
        background = { border_width = 2 },
      })
      if spaces_props[focused] then
        spaces_props[focused].is_active = true
      end
    end
  end)
end)

local spaces_indicator = sbar.add("item", "spaces_indicator", {
  padding_left = -3,
  padding_right = -5,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0)
  },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function()
  local currently_on = spaces_indicator:query().icon.string == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function()
  spaces_indicator:set({
    background = {
      color = { alpha = 1.0 },
      border_color = { alpha = 1.0 },
    },
    icon = { color = colors.bg1 },
    label = { width = "dynamic" }
  })
end)

spaces_indicator:subscribe("mouse.exited", function()
  spaces_indicator:set({
    background = {
      color = { alpha = 0.0 },
      border_color = { alpha = 0.0 },
    },
    icon = { color = colors.grey },
    label = { width = 0 }
  })
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.trigger("swap_menus_and_spaces")
end)