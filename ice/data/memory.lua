local util      = require("ice.util")

local memory = {}
memory.__index = memory


function memory.create()
   local l_memory = {}
   setmetatable(l_memory, memory)

   l_memory.total, l_memory.free = memory.getMemoryInfo()

   return l_memory
end

function memory:getFreeMemory()
   return self.free
end

function memory:getTotalMemory()
   return self.total
end

function memory:update()
   self.total, self.free = memory.getMemoryInfo()
end

function memory.getMemoryInfo()

   local result = io.popen("cat /proc/meminfo | grep 'MemFree\\|MemTotal' | awk '{print $2}'")
   local stringInfo = result:read("*all")
   result:close()

   local values = {}
   local pos = 0
   for value in stringInfo:gmatch("%g+") do
      values[pos] = value
      pos = pos +1
   end

   totalMemory = memory.format(values[0])
   freeMemory = memory.format(values[1])

   return totalMemory, freeMemory
end

function memory.format(pString)
   return util.round(tonumber(pString)/1024)
end

return memory
