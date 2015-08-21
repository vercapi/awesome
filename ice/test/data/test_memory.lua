package.path = package.path .. ';../../../?.lua'

local memory = require("ice.data.memory")
local util = require("ice.util")

local function test_getFreeMemory()
   local m = memory.create()
   assert(m:getFreeMemory() > 0, "Memory should not be 0")
end

local function test_getTotalMemory()
      local m = memory.create()
   assert(m:getTotalMemory() > 0, "Memory should not be 0")
end
