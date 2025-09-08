local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspaces = {}

local function getWorkspaceIcons(apps)
  if not apps or #apps == 0 then
    return " —"
  end

  local icons_list = {}
  for _, app in ipairs(apps) do
    table.insert(icons_list, app_icons[app] or app_icons["default"])
  end
  return table.concat(icons_list, " ")
end

-- Update workspace appearance
local function updateWorkspace(workspace_id, apps, is_focused)
  local workspace = workspaces[workspace_id]
  if not workspace then return end

  local icons_string = getWorkspaceIcons(apps)

  workspace:set({
    icon = {
      highlight = is_focused,
      color = is_focused and colors.red or colors.white
    },
    label = {
      string = icons_string,
      highlight = is_focused,
      color = is_focused and colors.red or colors.grey
    },
    background = {
      border_color = is_focused and colors.red or colors.bg2,
      color = is_focused and colors.with_alpha(colors.red, 0.2) or colors.bg1
    }
  })
end

-- Update workspace-to-monitor assignments
local function updateMonitorAssignments()
  sbar.exec("aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json", function(workspaces_monitors)
    for _, entry in ipairs(workspaces_monitors) do
      local workspace_id = entry.workspace
      local monitor_id = math.floor(entry["monitor-appkit-nsscreen-screens-id"])

      if workspaces[workspace_id] then
        workspaces[workspace_id]:set({
          display = monitor_id
        })
      end
    end
  end)
end

local function refreshWorkspaces()
  sbar.exec("aerospace list-windows --all --format '%{workspace}%{app-name}' --json", function(windows_data)
    local workspace_apps = {}

    -- Parse windows data
    for _, entry in ipairs(windows_data) do
      local workspace_id = entry.workspace
      local app = entry["app-name"]

      if workspace_id and app then
        workspace_apps[workspace_id] = workspace_apps[workspace_id] or {}
        table.insert(workspace_apps[workspace_id], app)
      end
    end

    -- Get focused workspace
    sbar.exec("aerospace list-workspaces --focused", function(focused_output)
      local focused = focused_output:match("^%s*(.-)%s*$")

      -- Update all workspaces
      for workspace_id, _ in pairs(workspaces) do
        updateWorkspace(workspace_id, workspace_apps[workspace_id], workspace_id == focused)
      end
    end)
  end)
end

local function fullRefresh()
  updateMonitorAssignments()
  refreshWorkspaces()
end

sbar.exec("aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json", function(workspaces_data)
  for _, entry in ipairs(workspaces_data) do
    local workspace_id = entry.workspace
    local monitor_id = math.floor(entry["monitor-appkit-nsscreen-screens-id"])

    local workspace = sbar.add("item", "space." .. workspace_id, {
      icon = {
        font = { family = settings.font.space_numbers },
        string = workspace_id,
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
        string = " —"
      },
      padding_right = 1,
      padding_left = 1,
      background = {
        color = colors.bg1,
        border_width = 1,
        height = 26,
        border_color = colors.black
      },
      click_script = "aerospace workspace " .. workspace_id,
      display = monitor_id
    })

    -- Store reference
    workspaces[workspace_id] = workspace

    -- Focus change handler
    workspace:subscribe("aerospace_workspace_change", function(env)
      if env.FOCUSED_WORKSPACE == workspace_id then
        workspace:set({
          icon = { highlight = true, color = colors.red },
          label = { highlight = true, color = colors.red },
          background = { border_color = colors.red, color = colors.with_alpha(colors.red, 0.2) }
        })
      else
        workspace:set({
          icon = { highlight = false, color = colors.white },
          label = { highlight = false, color = colors.grey },
          background = { border_color = colors.bg2, color = colors.bg1 }
        })
      end
    end)
  end

  -- Initial refresh
  fullRefresh()

  -- Set up refresh events
  local refresh_trigger = sbar.add("item", "refresh_trigger", { drawing = false, updates = true })

  -- App/window changes - just refresh workspace content
  refresh_trigger:subscribe("space_windows_change", refreshWorkspaces)

  -- Monitor changes - full refresh with monitor reassignment
  refresh_trigger:subscribe("display_change", function()
    print("Display change detected - updating monitor assignments")
    fullRefresh()
  end)

  refresh_trigger:subscribe("system_woke", function()
    sbar.delay(1.5, fullRefresh)
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
  spaces_indicator:set({ icon = currently_on and icons.switch.off or icons.switch.on })
end)

spaces_indicator:subscribe("mouse.entered", function()
  spaces_indicator:set({
    background = { color = { alpha = 1.0 }, border_color = { alpha = 1.0 } },
    icon = { color = colors.bg1 },
    label = { width = "dynamic" }
  })
end)

spaces_indicator:subscribe("mouse.exited", function()
  spaces_indicator:set({
    background = { color = { alpha = 0.0 }, border_color = { alpha = 0.0 } },
    icon = { color = colors.grey },
    label = { width = 0 }
  })
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.trigger("swap_menus_and_spaces")
end)
