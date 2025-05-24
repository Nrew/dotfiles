sbar = require("sketchybar")    -- Load the Sketchybar module

sbar.begin_config()             -- Begin the configuration
-- sbar.hotload(true)              -- Enable hotloading

require("bar")                  -- Load the bar configuration
require("default")              -- Load the default widgets
require("items")                -- Load the items

sbar.end_config()               -- End the configuration

sbar.event_loop()               -- Start the event loop
