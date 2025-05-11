local colors <const> = {
    -- Rose Pine colors
    base = 0xff191724,           -- base
    surface = 0xff1f1d2e,        -- surface
    overlay = 0xff26233a,        -- overlay
    muted = 0xff6e6a86,          -- muted
    subtle = 0xff908caa,         -- subtle
    text = 0xffe0def4,           -- text
    love = 0xffeb6f92,           -- red
    gold = 0xfff6c177,           -- yellow
    rose = 0xffebbcba,           -- orange
    pine = 0xff31748f,           -- blue
    foam = 0xff9ccfd8,           -- green/cyan
    iris = 0xffc4a7e7,           -- purple
    
    -- Legacy mappings for backwards compatibility
    black = 0xff191724,
    white = 0xffe0def4,
    red = 0xffeb6f92,
    green = 0xff9ccfd8,
    blue = 0xff31748f,
    yellow = 0xfff6c177,
    orange = 0xffebbcba,
    magenta = 0xffc4a7e7,
    purple = 0xffc4a7e7,
    other_purple = 0xff26233a,
    cyan = 0xff9ccfd8,
    grey = 0xff6e6a86,
    dirty_white = 0xff908caa,
    dark_grey = 0xff1f1d2e,
    transparent = 0x00000000,
    
    bar = {
      bg = 0xf0191724,    -- base with transparency
      border = 0xff26233a, -- overlay
    },
    popup = {
      bg = 0xf01f1d2e,    -- surface with transparency
      border = 0xff26233a, -- overlay
    },
    slider = {
      bg = 0xf01f1d2e,    -- surface with transparency
      border = 0xff26233a, -- overlay
    },
    bg1 = 0xd3191724,     -- base with some transparency
    bg2 = 0xff1f1d2e,     -- surface
  
    with_alpha = function(color, alpha)
      if alpha > 1.0 or alpha < 0.0 then return color end
      return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end,
  }
  
  return colors