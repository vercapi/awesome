local awful     = require("awful")
local wibox     = require("wibox")
local runner    = require("ice.core.Runner")
local util      = require("ice.util")
local beautiful = require("beautiful")
local separator = require("ice.widgets.separator")
local clockWidget = require("ice.widgets.clockView")

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
   v_layout:add(clockWidget())
   
   return v_layout
end

return clockView
