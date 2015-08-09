package.path = package.path .. ';../../../?.lua'

local cpu = require("ice.data.cpu")
local util = require("ice.util")

local function test_getLoad()
   print("format: " .. string.format("%u", cpu.getLoad()) .. '% ')
   assert(cpu.getLoad() > 0, "cpu should show some load")
end

local function test_countCores()
   assert(cpu.countCores() > 0, "at least one core should exist")
end
