package.path = package.path .. ';../../../?.lua'

local disk = require("ice.data.disk")
local util = require("ice.util")

local function test_getAllDisks()
   disks = disk.getAllDisks()
   assert(util.tablelength(disks) > 0, 'Could not find any disks')
end


local function test_getPercentage()
   disk = disk.create("/test")
   disk:setSpaceUsed(140)
   disk:setTotalSpace(200)
   assert(disk:getPercentagFull() == 70, 'Should be 70 percent')
end

local function test_getHome()
   disks = disk.getAllDisks()
   for key, value in pairs(disks) do
      print("k: " .. value:getPercentagFull() .. ' - ' .. value.spaceUsed)
   end
   assert(disks["/home"] ~= nil, '/home should exist')
end
