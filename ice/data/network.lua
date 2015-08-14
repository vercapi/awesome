local Interface = {}
Interface.__index = Interface

--- Constructor object for creating network Interface objects
-- @param pName the name of the network interface
function Interface.create(pName)
   local inet = {}
   setmetatable(inet, Interface)
   inet.name = pName
   return inet
end

function Interface:isDown()
   return not self:isUp()
end

function Interface:isUp()
   return 'connected' == self:getState()
end

function Interface:getState()   
   return self.state
end

function Interface:setState(pState)
   self.state = pState
end

function Interface:setType(pType)
   self.type = pType
end

function Interface:getType()
   return self.type
end

--- Get the current Receive or Transmission data rate in bytes
-- @param pRXTX set RX or TX
-- @return the rate
function Interface:getCurrentRate(pRXTX)
   result = io.popen("ifstat | grep " .. self.name .. " | awk '{ print $6\" \"$8}'")
   allText = result:read("*all")
   result:close()

   result = -1
   results = {}
   i = 0
   for x in string.gmatch(allText, "%d+") do
      results[i] = x
      i = i + 1
   end
   
   if pRXTX == "RX" then
      result = results[0]
   else
      result = results[1]
   end

   if result == nil then
      result = 0
   end
   
   return tonumber(result)
end

function Interface:getWirelessStrenght()
   -- TODO:only when this actually is a wireless connection
   local result = io.popen("nmcli d wifi list ifname " .. self.name .. " | grep '^*' | grep -v \"SSID\" | awk '{ print $7}'")
   local stringNumber = result:read("*all")
   result:close()


   
   if stringNumber ~= nil then return tonumber(stringNumber) else return 0 end
end
   
function Interface:isWireless()
   return self:getType() == 'wifi'
end

function Interface:update()
   device = Interface.getDevices(self.device)[0]
   self = device
end

function Interface.getAnyConnected()
   vResult = io.popen("ip link show | cut -d' ' -f2,9")
   vList = vResult:read("*all")
   vResult:close()
   vList = vList:match("%w+: UP")

   vNetwork = nil
   if vList ~= nil then
      vNetwork =  vList:gsub(": UP", "")
   end

   return vNetwork
end

--- Get all devices.
-- @parameter pDeviceName if it is not nil it will be used in the command to specify a device
-- @return A table of all devices in Interface objects.
function Interface.getDevices(pDeviceName)
   if pDeviceName == nil then pDeviceName = "" end
   
   local interfaces = {}
   local result = io.popen("nmcli d status | grep '".. pDeviceName  .."' | awk '{print $1\" \"$2\" \"$3}' | tail -n+2")
   local list = result:read("*all")
   result:close()
   for info in list:gmatch("%g+ %g+ %g+") do
      local items = {}
      local pos = 0
      for item in info:gmatch("%w+") do
         items[pos] = item
         pos = pos +1
      end

      local name = items[0]
      interface = Interface.create(name)
      interface:setType(items[1])
      interface:setState(items[2])
      
      interfaces[name] = interface
   end
   
   return interfaces
end

return Interface


