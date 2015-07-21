local disk = {}
disk.__index = disk

function disk.create(pMountPoint)
   local myDisk = {}
   setmetatable(myDisk, disk)
   
   return myDisk
end

function disk:setTotalSpace(pTotalSpace)
   self.totalSpace = pTotalSpace
end

function disk:setSpaceUsed(pSpaceUsed)
   self.spaceUsed = pSpaceUsed
end

function disk.getAllDisks()
   disks = {}

   result = io.popen("df | grep '/' | awk '{print $1\" \"$2\" \"$3}'")
   list = result:read("*all")
   result:close()

   for mountPoint in list:gmatch("%g+ %w+ %w+") do
      local values = {}
      local pos = 1
      for value in mountPoint:gmatch("%g+") do
         values[pos] = value
         pos = pos +1
      end

      currentDisk = disk.create(values[1])
      currentDisk:setTotalSpace(values[2])
      currentDisk:setSpaceUsed(values[3])
      disks[values[1]] = currentDisk
   end

   return disks
end

return disk
