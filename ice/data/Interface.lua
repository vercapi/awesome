--[[

-- This contains all the method to get information back from the network interfaces

--]]

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

--- Get the state of a network Interface
-- @return State of network Interface
function Interface:getState()   
   result = io.popen("ip link show " .. self.name  .. " | grep -oh 'state [A-Z]*'")
   rawState = result:read("*all")
   result:close()

   state, numReplaced = rawState:gsub("state ", "")
   return state
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
   
   return result
end

function Interface:WirelessStrenght()
   result = io.popen("nmcli d wifi list ifname " .. self.name .. " | grep '^*' | grep -v \"SSID\" | awk '{ print $2\" \"$7}'")
   list = result:read("*all")
   result:close()
end
   
function Interface:isWireless()
   vResult = io.popen("nmcli d wifi list ifname " .. self.name)
   vText = vResult:read("*all")
   vResult:close()

   vIsWireless = false
   if not string.find(vText, "Error") then
      vIsWireless = true
   end

   return vIsWireless
end

--- Get all devices.
-- @return A table of all devices in Interface objects.
function Interface.getDevices()
   interfaces = {}
   result = io.popen("ip link show | cut -d' ' -f2")
   list = result:read("*all")
   result:close()
   for ifName in list:gmatch("%w+:") do
      name, numReplaced = ifName:gsub(":", "")
      interface = Interface.create(name)
      interfaces[name] = interface
   end
   
   return interfaces
end

return Interface


