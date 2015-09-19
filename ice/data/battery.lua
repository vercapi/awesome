local dbus      = require("lua-dbus")
local util      = require("ice.util")

local battery = {}
battery.__index = battery

function battery.create(p_device)
   local l_battery = {}
   setmetatable(l_battery, battery)

   l_battery.listeners = {}
   l_battery.device = p_device
   
   return l_battery
end

function battery:on_event_listener(p_listener)
   table.insert(self.listeners, p_listener)
end


function battery.get_param_callback(p_battery, p_param)
   function param_callback(p_statistic)
      for key, listener in pairs(p_battery.listeners) do
         listener({p_param, p_statistic})
      end
   end

   return param_callback
end

function battery:get_param(p_param, iface, p_path)
   local batter_opts = {bus = 'system',
                        path=p_path,
                        interface=iface,
                        destination='org.freedesktop.UPower'}
   dbus.property.get(p_param, battery.get_param_callback(self, p_param), batter_opts)
end

function battery:get_device_param(p_param)
   self:get_param(p_param, 'org.freedesktop.UPower.Device', self.device)
end

function battery:get_upower_param(p_param)
   self:get_param(p_param, 'org.freedesktop.UPower', '/org/freedesktop/UPower')
end

function battery:get_parameters()
   self:get_device_param('Percentage')
   self:get_device_param('TimeToFull')
   self:get_device_param('TimeToEmpty')
   self:get_upower_param('OnBattery')
end

function battery:registerSignal()
   -- TODO: This needs to be parameterized
   local batter_opts =  {bus = 'system', interface='org.freedesktop.DBus.Properties', path=self.device}
   dbus.on('PropertiesChanged', battery.battery_dbus(self), batter_opts)
end

function battery.battery_dbus(p_battery)
   function battery_dbus(iface, p_values)
      p_battery:get_parameters()
   end
   
   return battery_dbus
end
   
return battery
