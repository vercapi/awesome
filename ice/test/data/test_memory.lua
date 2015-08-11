package.path = package.path .. ';../../../?.lua'

local memory = require("ice.data.memory")
local util = require("ice.util")

local function test_getFreeMemory()
   assert(memory.getFreeMemory() > 0, "Memory should not be 0")
end

local function test_getTotalMemory()
   assert(memory.getTotalMemory() > 0, "Memory should not be 0")
end
