
local naughty = require("naughty")
local gears = require("gears")
local cp = {timer = timer}

local SIGNAL = "timeout"


local Runner = {}
Runner.__index = Runner

-- pTimeout for the refresh in seconds
function Runner.create(pTimeout, pFunction)

   gears.timer {
     timeout   = pTimeout,
      autostart = true,
     callback  = pFunction
  }

end

return Runner
