local dbus      = require("lua-dbus")
local util      = require("ice.util")

local battery = {}
battery.__index = battery

function battery.create()
   local l_battery = {}
   setmetatable(l_battery, battery)

   l_battery.listeners = {}
   
   return l_battery
end

function battery:on_battery_listener(p_listener)
   table.insert(self.listeners, p_listener)
   print("after ", util.tablelength(self.listeners))
end

function battery:registerSignal()
   -- TODO: This needs to be parameterized
   local batter_opts =  {bus = 'system', interface='org.freedesktop.DBus.Properties', path="/org/freedesktop/UPower/devices/battery_BAT1"}
   dbus.on('PropertiesChanged', battery.battery_dbus(self), batter_opts)
end

function battery.battery_dbus(p_battery)
   function battery_dbus(thing, other)
      -- TODO: Convert this raw format to a doucmented object
      for key, func in pairs(p_battery.listeners) do
         func(other)
      end
   end

   return battery_dbus
end

   
return battery
