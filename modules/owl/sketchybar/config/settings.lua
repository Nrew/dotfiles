local icons = require("icons")

-- Dimension and spacing constants
local dimens = {
  -- Padding values for various UI components
  padding = {
    background = 8,              -- Padding for background elements
    icon = 8,                    -- Padding around icons
    label = 8,                   -- Padding around labels
    bar = 5,                     -- Padding for the main bar
    item = 8,                    -- Padding for generic items
    popup = 8,                   -- Padding for popup windows
  },

  -- Graphical properties (sizes, radii, offsets)
  graphics = {
    bar = {
      height = 40,               -- Height of the main bar
      offset = 0,                -- Vertical offset from screen edge
      corner_radius = 15,        -- Corner radius for rounded corners
      margin = 0,                -- Margin around the bar
    },
    background = {
      height = 24,               -- Height of item backgrounds
      corner_radius = 9,         -- Corner radius for backgrounds
    },
    slider = {
      height = 20,               -- Height of slider components
    },
    popup = {
      width = 200,               -- Default popup width
      large_width = 300,         -- Width for larger popups
    },
    border = {
      width = 1,                 -- Border width for UI elements
    }
  },

  -- Text-related dimensions
  text = {
    icon = 14.0,                 -- Default icon font size
    label = 12.0,                -- Default label font size
  },

  -- Alpha (transparency) values
  alphas = {
    bar = {
      background = 0.35,         -- Bar background transparency
      border = 0.5,              -- Bar border transparency
    },
    background = {
      border = 0.7,              -- Background border transparency
      border_image = 0.6,        -- Background image border transparency
    },
  },

  -- Visual effects
  effects = {
    blur_radius = 35,            -- Blur radius for background effects
  },
}

-- Font configuration
local fonts = {
  text = "JetBrains Mono Nerd Font",     -- Primary text font
  numbers = "JetBrains Mono Nerd Font",  -- Numbers font
  weather = "Symbols Nerd Font",         -- Weather symbols font

  -- Dynamic font helper for app icons
  icons = function(size)
    local font = "sketchybar-app-font:Regular:"
    return size and (font .. size) or (font .. dimens.text.icon)
  end,

  -- Font styles
  styles = {
    regular = "Regular",
    semibold = "Semibold",
    bold = "Bold",
    heavy = "Heavy",
    black = "Black",
  }
}

return {
  fonts = fonts,
  dimens = dimens,
  alphas = dimens.alphas,        
  text = icons.text.nerdfont,
  apps = icons.apps,
}
