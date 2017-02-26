local awful     = require("awful")
local wibox     = require("wibox")
local runner    = require("ice.core.Runner")
local util      = require("ice.util")
local beautiful = require("beautiful")
local separator = require("ice.widgets.separator")

local clockView = {}
clockView.__index = clockView

function clockView.create()
   v_layout =  wibox.layout.fixed.horizontal()
   
   local clock = {}
   setmetatable(clock, clockView)

   -- Widget is defined localy because it's not a reusable piece of code
   local clockWidget = wibox.widget.base.make_widget()
   
   clockWidget.fit = function(clockWidget, width, height)
       return 70, height
   end
   
   clockWidget.draw = function(clockWidget, wibox, cr, width, height)

      -- Technically draw text
      local drawText = function(pSize, pPos, pText)
         font=beautiful.font
         font_size=pSize
         text=pText
         xpos,ypos=0,pPos
         color = util.createColor("#006395")
         red,green,blue,alpha=color.red(),color.green(),color.blue(),1
         font_slant=CAIRO_FONT_SLANT_NORMAL
         font_face=CAIRO_FONT_WEIGHT_NORMAL
         ----------------------------------
         cr:select_font_face (font, font_slant, font_face);
         cr:set_font_size (font_size)
         cr:set_source_rgba (red,green,blue,alpha)
         cr:move_to (xpos,ypos)
         cr:show_text (text)
         
         cr:stroke ()
      end

      drawText(20, 17, os.date('%H:%M'))
      drawText(12, 30, os.date('%A'))
      drawText(12, 40, os.date('%d/%b/%y'))
   end
          
   clockIcon = wibox.widget.imagebox()
   clockIcon:set_image(beautiful.clock)
   iconMargin = wibox.layout.margin(clockIcon, 0, 0)
   iconMargin:set_top(3)
   iconMargin:set_bottom(3)
   iconMargin:set_right(5)
   iconMargin:set_left(5)

   v_layout:add(iconMargin)
   
   v_layout:add(clockWidget)

   return v_layout
end

return clockView
