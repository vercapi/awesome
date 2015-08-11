local util      = require("ice.util")

local memory = {}
memory.__index = memory
   

function memory.getFreeMemory()
   return memory.getMemoryInfo("MemFree")
end

function memory.getTotalMemory()
   return memory.getMemoryInfo("MemTotal")
end


function memory.getMemoryInfo(pParameter)

   local result = io.popen("cat /proc/meminfo | grep '" .. pParameter  .. "' | awk '{print $2}'")
   local stringInfo = result:read("*all")
   result:close()

   number = tonumber(stringInfo)/1024 -- Information is in kb chaning it to mb
   return util.round(number, 0)
   
end

return memory
