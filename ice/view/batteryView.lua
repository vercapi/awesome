local wibox     = require("wibox")
local beautiful = require("beautiful")
local battery   = require("ice.data.battery")

local batteryView = {}
batteryView.__index = batteryView

function batteryView:update(p_parameters)
   
   if(p_parameters.OnBattery ~= nil) then
      self.on_battery = p_parameters.OnBattery
   end
   
   if(self.on_battery == 'false') then
      self.batteryIcon:set_image(beautiful.bat_power)
   else
      self.batteryIcon:set_image(beautiful.bat_half)
   end
end

function batteryView:get_update(p_battery_view)
   function updator(p_parameters)
      p_battery_view:update(p_parameters)
   end

   return updator
end

function batteryView.create(p_device)
   local l_batteryView = {}
   setmetatable(l_batteryView, batteryView)

   l_batteryView.battery = battery.create(p_device)
   l_batteryView.battery:on_event_listener(l_batteryView:get_update(self))
   --   l_batteryView.battery:registerSignal()
   l_batteryView.battery:get_upower_param("OnBattery")

   l_batteryView.percentage = 0
   l_batteryView.on_battery = 'true'
  
   return l_batteryView
end

function batteryView:drawContent()
   layout = wibox.layout.fixed.horizontal()
   
   self.batteryIcon = wibox.widget.imagebox()
   self.batteryIcon:set_image(beautiful.bat_empty)

   iconMargin = wibox.layout.margin(self.batteryIcon, 2, 2)
   iconMargin:set_top(2)
   iconMargin:set_bottom(2)

   layout:add(iconMargin)
   return layout
end

function batteryView:init()
   
end

function batteryView:getState()
   
end

return batteryView
