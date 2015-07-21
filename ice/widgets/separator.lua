local wibox = require("wibox")
local util  = require("ice.util")

local separator = { mt = {} }

-- Fix this class forowing te example
-- https://github.com/awesomeWM/awesome/blob/d4d5bbcd5d0206c86d390d5aaa1579e00177c85d/lib/wibox/widget/imagebox.lua

function separator:fit(width, height)
   return height, height
end

function separator:draw(wibox, cr, width, height)

   line_width = 10
   
   local drawLine = function(pStart, pColor)
      --line_width=10
      line_cap=CAIRO_LINE_CAP_BUTT
      red,green,blue,alpha=pColor.red(),pColor.green(),pColor.blue(),1
      startx=10+pStart
      starty=0
      ----------------------------
      cr:set_line_width(line_width)
      cr:set_line_cap(line_cap)
      cr:set_source_rgba(red,green,blue,alpha)
      cr:move_to(startx,starty)
      cr:line_to(10+pStart,20)
      cr:line_to(30+pStart, height+4)
      cr:stroke()
   end

   local drawSurface = function(pStart, pColor)
      --line_width=0
      top_left_x=0
      top_left_y=0
      rec_width=25
      rec_height=50
      red=pColor.red()
      green=pColor.green()
      blue=pColor.blue()
      alpha=1
      ----------------------------
      cr:set_line_width(line_width)
      cr:rectangle(top_left_x,top_left_y,rec_width,rec_height)
      cr:set_source_rgba(red,green,blue,alpha)
      cr:fill()
   end
   
   drawSurface(0,self._color1)
   
   drawLine(0,self._color2)
   drawLine(10,self._color1)
end


function separator:setColors(pColor1, pColor2)
   self._color1 = pColor1
   self._color2 = pColor2
end

local function new(pColor1, pColor2)

   local widget = wibox.widget.base.make_widget()

   -- Merge separtor with the widget
   for k, v in pairs(separator) do
      if type(v) == "function" then
         widget[k] = v
      end
   end

   widget:setColors(pColor1, pColor2)

   return widget
end

function separator.mt:__call(...)
    return new(...)
end

return setmetatable(separator, separator.mt)
