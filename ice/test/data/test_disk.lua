package.path = package.path .. ';../../../?.lua'

local disk = require("ice.data.disk")
local util = require("ice.util")

local function test_getAllDisks()
   disks = disk.getAllDisks()
   assert(util.tablelength(disks) > 0, 'Could not find any disks')
end
