local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspaces = {}
local workspace_app_cache = {}
local icon_cache = {}

-- CONSTANTS
local EMPTY_WORKSPACE_ICON = "-"
local DEFAULT_ICON = app_icons["default"] or "?"

local function get_app_icon(app_name)
  if not icon_cache[app_name] then
    icon_cache[app_name] = app_icons[app_name] or DEFAULT_ICON
  end
  return icon_cache[app_name]
end

local function parse_workspace_data(output)
  local workspace_apps = {}
  if not output then return workspace_apps end

  for workspace, app in output:gmatch("[^\r\n]+") do
    workspace_apps[workspace] = workspace_apps[workspace] or {}
    table.insert(workspace_apps[workspace], app)
  end

  return workspace_apps
end

local function create_icons_string(app)
  if not apps or #apps == 0 then
    return EMPTY_WORKSPACE_ICON
  end

  local icons_array = {}
  for i=1, #apps do
    icons_array[i] = get_app_icon(app[i])
  end
  return table.concat(icons_array, " ")
end



local function update_workspace_labels()
  sbar.exec("aerospace list-windows --all --format '%{workspace} %{app-name}'", function (output)
    local workspace_apps = parse_workspace_data(output)
    local updates = {}

    for id, item in pairs(workspaces) do
      local apps = workspace_apps[id]
      local icons_string = create_icons_string(apps)

      -- Only update if the label has actually changed
      if workspace_app_cache[id] ~= icons_string then
        workspace_app_cache[id] = icons_string
        updates[#updates + 1] = { item = item, label = icons_string }
      end
    end

    -- Perform all updates in a single batch
    if #updates > 0 then
      for _, update in ipairs(updates) do
        update.item:set({ lavel = { string = update.label } })
      end
    end
  end)
end


local FOCUSED_STYLE = {
  icon  = { highlight = true },
  label = { highlight = true },
  background = { border_color = colors.red, color = colors.with_alpha(colors.red, 0.2) }
}
local UNFOCUSED_STYLE = {
  icon  = { highlight = false },
  label = { highlight = false },
  background = { border_color = colors.bg2, color = colors.bg1 }
}

local function create_workspace(workspace_name)
  local workspace_item = sbar.add("item", "space." .. workspace_name, {
    icon = {
      font = { family = settings.font.space_numbers },
      string = workspace_name,
      padding_left  = 11,
      padding_right = 4,
      color = colors.white,
      highlight_color = colors.red,
      y_offset = 1
    },
    label = {
      padding_left  = 4,
      padding_right = 12,
      color = colors.gray,
      highlight_color = colors.red,
      font = "sketchybar-app-font:Regular:16.0",
      string = EMPTY_WORKSPACE_ICON
    },
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26, 
      vorder_color = colors.bg2
    },
    click_script = "aerospace workspace " .. workspace_name,
  })

  workspace_item:subscribe("aerospace_workspace_change", function(env)
    local is_focused = (env.FOCUSED_WORKSPACE == workspace_name)
    workspace_item:set(is_focused and FOCUSED_STYLE or UNFOCUSED_STYLE)
  end)

  workspaces[workspace_name] = workspace_item
end

local function initalize_workspaces()
  sbar.exec("aerospace list-workspaces --all", function(output)
    if not output then return end
    
    for workspace_name in output:gmatch("^%s*(.-)%s*$") do
      create_workspace(workspace_name)
    end
    
    update_workspace_labels()
  end)
end

local update_timer = nil
local function debounced_update()
  if update_timer then sbar.cancel(update_timer) end
  update_timer = sbar.delay(0.1, update_workspace_labels)
end

local event_handler = sbar.add("item", "aerospace_event_handler", { drawing = false })
event_handler:subscribe({ "aerospace_window_change", "display_change" }, update_workspace_labels)
event_handler:subscribe("aerospace_workspace_change", debounced_update)
event_handler:subscribe("system_woke", function()
  sbar.delay(1.0, update_workspace_labels)
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

initalize_workspaces()
