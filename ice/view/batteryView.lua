local wibox     = require("wibox")
local beautiful = require("beautiful")
local battery   = require("ice.data.battery")
local util      = require("ice.util")

local batteryView = {}
batteryView.__index = batteryView

function batteryView.create(p_device)
   local l_batteryView = {}
   setmetatable(l_batteryView, batteryView)

   l_batteryView.battery = battery.create(p_device)
  
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
   self:update()
end

function batteryView:update()
   self.battery:update()
   
   local on_battery = self.battery:is_on_battery()
   local percentage = self.battery:get_percentage()
   
   if(not on_battery) then
      self.batteryIcon:set_image(beautiful.bat_power)
   else
      if percentage >= 90 then
         self.batteryIcon:set_image(beautiful.bat_full)
      elseif percentage >= 50 then
         self.batteryIcon:set_image(beautiful.bat_half)
      elseif percentage >= 25 then
         self.batteryIcon:set_image(beautiful.bat_low)
      else
         self.batteryIcon:set_image(beautiful.bat_empty)
      end
   end
end

function batteryView:getState()
   local on_battery = self.battery:is_on_battery()
   local percentage = self.battery:get_percentage()

   local state = util.OK
   if(on_battery) then
      if(percentage <= 10) then
         state = util.ERROR
      elseif(percentage <= 15) then
         state = util.WARNING
      end
   end

   return state
end

return batteryView
