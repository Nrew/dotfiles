local colors = {
  -- Rose Pine Base Colors
  base = 0xff191724,           -- Base background
  surface = 0xff1f1d2e,        -- Surface background
  overlay = 0xff26233a,        -- Overlay elements
  muted = 0xff6e6a86,          -- Muted text
  subtle = 0xff908caa,         -- Subtle text
  text = 0xffe0def4,           -- Primary text
  love = 0xffeb6f92,           -- Red/pink accent
  gold = 0xfff6c177,           -- Yellow/gold accent
  rose = 0xffebbcba,           -- Orange/rose accent
  pine = 0xff31748f,           -- Blue accent
  foam = 0xff9ccfd8,           -- Green/cyan accent
  iris = 0xffc4a7e7,           -- Purple accent

  -- Semantic Color Mappings
  black = 0xff191724,          -- Base
  white = 0xffe0def4,          -- Text
  red = 0xffeb6f92,            -- Love
  green = 0xff9ccfd8,          -- Foam
  blue = 0xff31748f,           -- Pine
  yellow = 0xfff6c177,         -- Gold
  orange = 0xffebbcba,         -- Rose
  magenta = 0xffc4a7e7,        -- Iris
  purple = 0xffc4a7e7,         -- Iris
  cyan = 0xff9ccfd8,           -- Foam
  grey = 0xff6e6a86,           -- Muted
  dirty_white = 0xff908caa,    -- Subtle
  dark_grey = 0xff1f1d2e,      -- Surface
  transparent = 0x00000000,    -- Fully transparent

  -- Component-Specific Colors
  bar = {
    bg = 0xf0191724,           -- Base with 94% opacity
    border = 0xff26233a,       -- Overlay
  },
  popup = {
    bg = 0xf01f1d2e,           -- Surface with 94% opacity
    border = 0xff26233a,       -- Overlay
  },
  slider = {
    bg = 0xf01f1d2e,           -- Surface with 94% opacity
    border = 0xff26233a,       -- Overlay
  },
  bg1 = 0xd3191724,            -- Base with 83% opacity
  bg2 = 0xff1f1d2e,            -- Surface (fully opaque)

  -- Alpha utility function
  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then 
      return color 
    end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}

return colors
