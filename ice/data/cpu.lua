local util      = require("ice.util")

local cpu = {}
cpu.__index = cpu
   
function cpu.countCores()

   local result = io.popen("nproc")
   local stringCount = result:read("*all")
   result:close()
   
   local count = tonumber(stringCount)
      
   return count
end

function cpu.getLoad()
   local load = 0

   local result = io.popen("cat /proc/loadavg | awk '{print $1}'")
   local stringLoad = result:read("*all")
   result.close()

   load = tonumber(stringLoad)

   return util.round(load, 2)
end

return cpu
