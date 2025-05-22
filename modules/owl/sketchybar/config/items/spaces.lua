-- Workspace/Spaces display for SketchyBar
-- Fixed variable references and improved consistency

local constants = require("constants")
local settings = require("settings")
local colors = require("colors")

-- Extract commonly used settings
local apps = settings.apps
local dimens = settings.dimens

local spaces = {}

-- Hidden watchers for events
local swapWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local currentWorkspaceWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Configuration for different workspace types
local spaceConfigs = {
  ["B"] = { icon = "󰖟", name = "Browsing" },
  ["C"] = { icon = "", name = "Coding" },
  ["E"] = { icon = "", name = "Mail" },
  ["F"] = { icon = "", name = "Files" },
  ["T"] = { icon = "", name = "Terminal" },
  ["X"] = { icon = "", name = "Misc" },
}

-- Highlight the currently focused workspace
local function selectCurrentWorkspace(focusedWorkspaceName)
  if not focusedWorkspaceName or focusedWorkspaceName == "" then
    return
  end

  for sid, item in pairs(spaces) do
    if item then
      local isSelected = sid == constants.items.SPACES .. "." .. focusedWorkspaceName
      item:set({
        icon = { color = isSelected and colors.bg1 or colors.white },
        label = { color = isSelected and colors.bg1 or colors.white },
        background = { color = isSelected and colors.white or colors.bg1 },
      })
    end
  end

  sbar.trigger(constants.events.UPDATE_WINDOWS)
end

-- Find and select the current workspace
local function findAndSelectCurrentWorkspace()
  sbar.exec(constants.aerospace.GET_CURRENT_WORKSPACE, function(focusedWorkspaceOutput)
    if focusedWorkspaceOutput then
      local focusedWorkspaceName = focusedWorkspaceOutput:match("[^\r\n]+")
      selectCurrentWorkspace(focusedWorkspaceName)
    end
  end)
end

-- Add a workspace item to the bar
local function addWorkspaceItem(workspaceName)
  if not workspaceName or workspaceName == "" then
    return
  end

  local spaceName = constants.items.SPACES .. "." .. workspaceName
  local spaceConfig = spaceConfigs[workspaceName] or { 
    icon = apps["default"] or ":default:", 
    name = workspaceName 
  }

  spaces[spaceName] = sbar.add("item", spaceName, {
    label = {
      width = 0,
      padding_left = 0,
      string = spaceConfig.name,
    },
    icon = {
      string = spaceConfig.icon,
      color = colors.white,
    },
    background = {
      color = colors.bg1,
    },
    click_script = "aerospace workspace " .. workspaceName,
  })

  -- Add hover animations
  spaces[spaceName]:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
      spaces[spaceName]:set({ label = { width = "dynamic" } })
    end)
  end)

  spaces[spaceName]:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
      spaces[spaceName]:set({ label = { width = 0 } })
    end)
  end)

  -- Add padding after each workspace
  sbar.add("item", spaceName .. ".padding", {
    width = dimens.padding.label
  })
end

-- Create all workspace items
local function createWorkspaces()
  sbar.exec(constants.aerospace.LIST_ALL_WORKSPACES, function(workspacesOutput)
    if not workspacesOutput or workspacesOutput == "" then
      return
    end

    for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
      if workspaceName and workspaceName ~= "" then
        addWorkspaceItem(workspaceName)
      end
    end

    findAndSelectCurrentWorkspace()
  end)
end

-- Subscribe to menu/spaces toggle events
swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
  local isShowingSpaces = env.isShowingMenu == "off"
  sbar.set("/" .. constants.items.SPACES .. "\\..*/", { drawing = isShowingSpaces })
end)

-- Subscribe to workspace change events
currentWorkspaceWatcher:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
  if env.FOCUSED_WORKSPACE then
    selectCurrentWorkspace(env.FOCUSED_WORKSPACE)
    sbar.trigger(constants.events.UPDATE_WINDOWS)
  end
end)

-- Initialize workspaces
createWorkspaces()

return spaces
