local util = require("ice.util")

local Interface = {}
Interface.__index = Interface

--- Constructor object for creating network Interface objects
-- @param pName the name of the network interface
function Interface.create(p_name, p_type)
   local inet = {}
   setmetatable(inet, Interface)
   
   inet.name = p_name
   inet.type = p_type

   inet:update()
   
   return inet
end

function Interface:isDown()
   return not self:isUp()
end

function Interface:isUp()
   return 'connected' == self.state
end

function Interface:getState()   
   return self.state
end

function Interface:getType()
   return self.type
end
   
function Interface:isWireless()
   return self.type == 'wifi'
end

function Interface:update()
   self.state = Interface.calculateState(self.name)
   self.rx_rate, self.tx_rate = Interface.calculateCurrentRate(self.name)
   if self:isWireless() then
      self.wireless_strength = Interface.calculateWirelessStrenght("wlp6s0")
   end
end

function Interface:getCurrentTXRate()
   return self.tx_rate
end

function Interface:getCurrentRXRate()
   return self.rx_rate
end

function Interface:getWirelessStrenght()
   return self.wireless_strength
end

function Interface.getAnyConnected()
   local result = io.popen("ip link show | cut -d' ' -f2,9")
   list = result:read("*all")
   result:close()
   local list = list:match("%w+: UP")

   local network = nil
   if list ~= nil then
      network =  list:gsub(": UP", "")
   end

   return network
end

--- Get all devices.
-- @parameter pDeviceName if it is not nil it will be used in the command to specify a device
-- @return A table of all devices in Interface objects.
function Interface.getDevices()
   if p_device == nil then device_name = "" else device_name = p_device.name end
   
   local interfaces = {}
   local result = io.popen("nmcli d status | grep '".. device_name  .."' | awk '{print $1\" \"$2}' | tail -n+2")
   local list = result:read("*all")
   result:close()
   for info in list:gmatch("%g+ %g+") do
      local items = {}
      local pos = 0
      for item in info:gmatch("%w+") do
         items[pos] = item
         pos = pos +1
      end
      
      local name = items[0]
      local interface = Interface.create(name, items[1])
      
      interfaces[name] = interface
   end
   
   return interfaces
end


function Interface.calculateWirelessStrenght(p_device)
   local result = io.popen("nmcli d wifi list ifname " .. p_device .. " | grep '^*' | grep -v \"SSID\" | awk '{ print $7}'")
   local stringNumber = result:read("*all")
   result:close()
   
   if stringNumber ~= nil then return tonumber(stringNumber) else return 0 end
end


--- Get the current Receive or Transmission data rate in bytes
-- @param pRXTX set RX or TX
-- @param p_device is the name of device you want the current rate from
-- @return the rate
function Interface.calculateCurrentRate(p_device)
   local file_result = io.popen("ifstat | grep " .. p_device .. " | awk '{ print $6\" \"$8}'")
   allText = file_result:read("*all")
   file_result:close()

   local result = -1
   results = {}
   i = 0
   for x in string.gmatch(allText, "%d+") do
      results[i] = x
      i = i + 1
   end
   
   return tonumber(results[0]), tonumber(results[1])
end

function Interface.calculateState(p_device)
   local result = io.popen("nmcli d status | grep '".. p_device  .."' | awk '{print $3}'")
   local state = result:read("*all")
   result:close()

   return util.trim(state)
end

return Interface
