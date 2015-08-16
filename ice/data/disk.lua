local util      = require("ice.util")

local disk = {}
disk.__index = disk

function disk.create(pMountPoint, p_total_space, p_used_space)
   local myDisk = {}
   setmetatable(myDisk, disk)
   myDisk.mountPoint = pMountPoint
   myDisk.total_space = p_total_space
   myDisk.used_space = p_used_space
   
   return myDisk
end

function disk:getPercentagFull()
   local result = self.used_space/self.total_space
   return util.round(result, 2)
end

function disk:update()
   name, self.total_space, self.used_space = disk.getOneDiskInfo(self.mountPoint)
end

function disk.getOneDiskInfo(p_mount_point)
   local result = disk.getRawDiskInfo(p_mount_point)
   line = result:read("*all")
   for mountPoint in line:gmatch("%g+ %w+ %w+") do
      return disk.parseRawDiskInfo(mountPoint)
   end
end

function disk.getAllDisks()
   disks = {}

   local result = disk.getRawDiskInfo("")
   local list = result:read("*all")
   result:close()

   for mountPoint in list:gmatch("%g+ %w+ %w+") do
      
      local name, totalSpace, usedSpace = disk.parseRawDiskInfo(mountPoint)
      local currentDisk = disk.create(name, totalSpace, usedSpace)
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
