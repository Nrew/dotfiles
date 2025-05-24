local colors = require("colors")
local settings = require("settings")

local menu_watcher = sbar.add("item", {
  drawing = false,
  updates = false,
})

local space_menu_swap = sbar.add("item", {
  drawing = false,
  updates = true,
})

sbar.add("event", "swap_menus_and_spaces")

local max_items <const> = 15
local menu_items = {}

-- Create menu items with proper error handling
for i = 1, max_items do
  local menu = sbar.add("item", "menu." .. i, {
    padding_left = settings.dimens.padding.base,
    padding_right = settings.dimens.padding.base,
    drawing = false,
    icon = { drawing = false },
    label = {
      font = {
        family = settings.fonts.family,
        style = i == 1 and settings.fonts.styles.heavy or settings.fonts.styles.semibold,
        size = settings.dimens.text.label,
      },
      padding_left = settings.dimens.padding.menu_label,
      padding_right = settings.dimens.padding.menu_label,
      color = colors.sections.item.text,
    },
    click_script = "$CONFIG_DIR/bridge/menus/bin/menus -s " .. i,
  })

  menu_items[i] = menu
end

-- Add bracket around all menu items
sbar.add("bracket", { '/menu\\..*/' }, {
  background = { color = colors.legacy.bg1 }
})

local menu_padding = sbar.add("item", "menu.padding", {
  drawing = false,
  width = settings.dimens.padding.group
})

local function update_menus(env)
  -- Safety check for bridge binary
  local bridge_path = "$CONFIG_DIR/bridge/menus/bin/menus"
  
  sbar.exec("test -x " .. bridge_path, function(test_result)
    if test_result ~= "" then
      print("Warning: Menu bridge binary not found or not executable")
      return
    end
    
    sbar.exec(bridge_path .. " -l", function(menus)
      if not menus or menus == "" then
        return
      end
      
      -- Hide all menu items first
      sbar.set('/menu\\..*/', { drawing = false })
      menu_padding:set({ drawing = true })
      
      local id = 1
      for menu in string.gmatch(menus, '[^\r\n]+') do
        if id <= max_items and menu ~= "" then
          menu_items[id]:set({ 
            label = { string = menu }, 
            drawing = true 
          })
          id = id + 1
        else 
          break 
        end
      end
    end)
  end)
end

menu_watcher:subscribe("front_app_switched", update_menus)

space_menu_swap:subscribe("swap_menus_and_spaces", function(env)
  local drawing = false
  if menu_items[1] then
    local query_result = menu_items[1]:query()
    drawing = query_result and query_result.geometry and query_result.geometry.drawing == "on"
  end
  
  if drawing then
    -- Hide menus, show spaces
    menu_watcher:set({ updates = false })
    sbar.set("/menu\\..*/", { drawing = false })
    menu_padding:set({ drawing = false })
    sbar.set("/space\\..*/", { drawing = true })
    sbar.set("front_app", { drawing = true })
  else
    -- Show menus, hide spaces
    menu_watcher:set({ updates = true })
    sbar.set("/space\\..*/", { drawing = false })
    sbar.set("front_app", { drawing = false })
    update_menus()
  end
end)

return menu_watcher
