require("install.sbar")         -- Load the Sketchybar installation

sbar = require("sketchybar")    -- Load the Sketchybar module

sbar.begin_config()             -- Begin the configuration
sbar.hotload(true)              -- Enable hotloading

require("constants")            -- Load the constants
require("config")               -- Load the configuration
require("bar")                  -- Load the bar configuration
require("default")              -- Load the default widgets
require("items")                -- Load the items

sbar.end_config()               -- End the configuration

sbar.event_loop()               -- Start the event loop