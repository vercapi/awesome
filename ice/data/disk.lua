local util      = require("ice.util")

local disk = {}
disk.__index = disk

function disk.create(pMountPoint)
   local myDisk = {}
   setmetatable(myDisk, disk)
   myDisk.mountPoint = pMountPoint
   
   return myDisk
end

function disk:setTotalSpace(pTotalSpace)
   self.totalSpace = pTotalSpace
end

function disk:setSpaceUsed(pSpaceUsed)
   self.spaceUsed = pSpaceUsed
end

function disk:getPercentagFull()
   local result = self.spaceUsed/self.totalSpace
   return util.round(result, 2)
end

function disk:updateDisk()
   local result = disk.getRawDiskInfo(self.mountPoint)
   line = result:read("*all")
   for mountPoint in line:gmatch("%g+ %w+ %w+") do
      name, totalSpace, usedSpace = disk.parseRawDiskInfo(mountPoint)
      self:setTotalSpace(totalSpace)
      self:setSpaceUsed(usedSpace)
   end
end

function disk.getAllDisks()
   disks = {}

   local result = disk.getRawDiskInfo("")
   local list = result:read("*all")
   result:close()

   for mountPoint in list:gmatch("%g+ %w+ %w+") do
      
      local name, totalSpace, usedSpace = disk.parseRawDiskInfo(mountPoint)
      local currentDisk = disk.create(name)
      currentDisk:setTotalSpace(totalSpace)
      currentDisk:setSpaceUsed(usedSpace)
      disks[name] = currentDisk   
   end

   return disks
end

function disk.getRawDiskInfo(pMountPoint)
   local result = io.popen("df ".. pMountPoint ..  "| grep '/' | awk '{print $6\" \"$2\" \"$3}'")
   return result
end

function disk.parseRawDiskInfo(pMountPoint)
   local values = {}
   local pos = 1
   for value in pMountPoint:gmatch("%g+") do
      values[pos] = value
      pos = pos +1
   end
   
   return values[1], values[2], values[3]
end

return disk
