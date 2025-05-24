local M = {}

local function with_alpha(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then return color end
  return (color & 0x00FFFFFF) | (math.floor(alpha * 255.0) << 24)
end

local rosepine = {
  base = 0xFF191724,
  surface = 0xFF1F1D2E,
  overlay = 0xFF26233A,
  muted = 0xFF6E6A86,
  subtle = 0xFF908CAA,
  text = 0xFFE0DEF4,
  love = 0xFFEB6F92,
  gold = 0xFFF6C177,
  rose = 0xFFEBBCBA,
  pine = 0xFF31748F,
  foam = 0xFF9CCFD8,
  iris = 0xFFC4A7E7,
}

M.sections = {
  bar = {
    bg = with_alpha(rosepine.base, 0.94),
    border = rosepine.overlay,
  },
  item = {
    bg = rosepine.surface,
    border = rosepine.overlay,
    text = rosepine.text,
  },
  popup = {
    bg = with_alpha(rosepine.surface, 0.94),
    border = rosepine.overlay,
  },
  apple = rosepine.love,
  media = { label = rosepine.text },
  calendar = { label = rosepine.text },
  spaces = {
    icon = {
      color = rosepine.muted,
      highlight = rosepine.gold,
    },
    label = {
      color = rosepine.muted,
      highlight = rosepine.gold,
    },
    indicator = rosepine.iris,
  },
  widgets = {
    battery = {
      low = rosepine.love,
      mid = rosepine.gold,
      high = rosepine.foam,
    },
    wifi = { icon = rosepine.text },
    volume = {
      icon = rosepine.pine,
      popup = {
        item = rosepine.text,
        highlight = rosepine.subtle,
        bg = with_alpha(rosepine.surface, 0.94),
      },
      slider = {
        highlight = rosepine.text,
        bg = with_alpha(rosepine.surface, 0.94),
        border = rosepine.overlay,
      },
    },
    messages = { icon = rosepine.love },
  },
}

M.legacy = {
  white = rosepine.text,
  red = rosepine.love,
  green = rosepine.foam,
  blue = rosepine.pine,
  yellow = rosepine.gold,
  orange = rosepine.rose,
  grey = rosepine.muted,
  bg1 = with_alpha(rosepine.base, 0.83),
  bg2 = rosepine.surface,
}

M.with_alpha = with_alpha
M.transparent = 0x00000000

return M
