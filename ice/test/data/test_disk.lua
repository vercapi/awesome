package.path = package.path .. ';../../../?.lua'

local disk = require("ice.data.disk")
local util = require("ice.util")

local function test_getAllDisks()
   disks = disk.getAllDisks()
   assert(util.tablelength(disks) > 0, 'Could not find any disks')
end

local function test_getPercentage()
   disk = disk.create("/test", 200, 140)
   assert(disk:getPercentagFull() == 0.7, 'Should be 70 percent')
end

local function test_getPercentage()
   disk = disk.getAllDisks()["/home"]
   assert(disk:getPercentagFull() >= 0, 'Home should not be 0')
end

local function test_getHome()
   disks = disk.getAllDisks()
   assert(disks["/home"] ~= nil, '/home should exist')
   assert(disks["/home"]:getPercentagFull() > 0, 'Percentage fill should be bigger then 0')
end

local function test_update()
   disks = disk.getAllDisks()
   disks["/home"]:update()
   assert(disk:getPercentagFull() > 0, 'Value should be bigger then 0')
end
