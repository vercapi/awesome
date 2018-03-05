local awful     = require("awful")
local wibox     = require("wibox")
local runner    = require("ice.core.Runner")
local util      = require("ice.util")
local beautiful = require("beautiful")
local separator = require("ice.widgets.separator")
local clockWidget = require("ice.widgets.clockView")
local gears     = require("gears")

local clockView = {}
clockView.__index = clockView

function clockView.create()

   clockIcon = wibox.widget.imagebox()
   clockIcon:set_image(beautiful.clock)
   
   iconMargin = wibox.container.margin(clockIcon, 0, 0)
   iconMargin:set_top(3)
   iconMargin:set_bottom(3)
   iconMargin:set_right(5)
   iconMargin:set_left(5)

   v_layout =  wibox.layout.fixed.horizontal()
   v_layout:add(iconMargin)
   v_widget = clockWidget()
   v_layout:add(v_widget)

   v_clock_timer = gears.timer({timeout = 60})
   v_clock_timer:connect_signal("timeout", function() v_widget:refresh()  end) 
   v_clock_timer:start()
   v_clock_timer:emit_signal("timeout") 
   
   return v_layout
end

return clockView
