local util = require("ice.util")

local network = {}
network.__index = network

--- Constructor object for creating network network objects
-- @param pName the name of the network interface
function network.create(p_name, p_type)
   local inet = {}
   setmetatable(inet, network)
   
   inet.name = p_name
   inet.type = p_type

   inet:update()
   
   return inet
end

function network:isDown()
   return not self:isUp()
end

function network:isUp()
   return 'connected' == self.state
end

function network:getState()   
   return self.state
end

function network:getType()
   return self.type
end
   
function network:isWireless()
   return self.type == 'wifi'
end

function network:update()
   self.state = network.collectState(self.name)
   self.rx_rate, self.tx_rate = network.collectCurrentRate(self.name)
   if self:isWireless() then
      self.wireless_strength = network.collectWirelessStrenght("wlp6s0")
   end
end

function network:getCurrentTXRate()
   return self.tx_rate
end

function network:getCurrentRXRate()
   return self.rx_rate
end

function network:getWirelessStrenght()
   return self.wireless_strength
end

--- Static Device finders ---

function network.getAnyConnected()
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
-- @return A table of all devices in network objects.
function network.getDevices()
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
      local interface = network.create(name, items[1])
      
      interfaces[name] = interface
   end
   
   return interfaces
end

--- Static data collectors

function network.collectWirelessStrenght(p_device)
   local result = io.popen("nmcli d wifi list ifname " .. p_device .. " | grep '^*' | grep -v \"SSID\" | awk '{ print $7}'")
   local stringNumber = result:read("*all")
   result:close()
   
   if stringNumber ~= nil then return tonumber(stringNumber) else return 0 end
end


--- Get the current Receive or Transmission data rate in bytes
-- @param pRXTX set RX or TX
-- @param p_device is the name of device you want the current rate from
-- @return the rate
function network.collectCurrentRate(p_device)
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

function network.collectState(p_device)
   local result = io.popen("nmcli d status | grep '".. p_device  .."' | awk '{print $3}'")
   local state = result:read("*all")
   result:close()

   return util.trim(state)
end

return network
