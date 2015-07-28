
local naughty = require("naughty")
local cp = {timer = timer}

local SIGNAL = "timeout"


local Runner = {}
Runner.__index = Runner

-- pTimeout for the refresh in seconds
function Runner.create(pTimeout, pFunction)
   local runner = {}
   setmetatable(runner, Runner)
   runner.listeners = {}

   runner.myTimer = cp.timer({timeout = pTimeout})
   runner.myTimer:connect_signal(SIGNAL, pFunction)
   runner.myTimer:start()
   
   return runner
end

return Runner
