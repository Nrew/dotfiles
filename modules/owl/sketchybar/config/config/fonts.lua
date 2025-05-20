local dimens <const> = require("config.dimens")

return {
  text = "Jetbrains Mono Nerd Font",
  numbers = "Jetbrains Mono Nerd Font",
  weather = "Symbols Nerd Font",
  icons = function(size)
    local font = "sketchybar-app-font:Regular:"
    return size and font .. size or font .. dimens.text.icon
  end,
  styles = {
    regular = "Regular",
    semibold = "Semibold",
    bold = "Bold",
    heavy = "Heavy",
    black = "Black",
  }
}
