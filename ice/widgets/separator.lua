local wibox = require("wibox")
local util  = require("ice.util")

local separator = { mt = {} }

function separator:fit(context, width, height)
   return height, height
end

function separator:draw(wibox, cr, width, height)

   line_width = util.round(height/4)
   
   local drawLine = function(pStart, pColor)
      line_cap=CAIRO_LINE_CAP_BUTT
      red,green,blue,alpha=pColor.red(),pColor.green(),pColor.blue(),1
      startx=10+pStart
      starty=0
      ----------------------------
      y_pos = util.round(height/2)
      x_diff = util.round((height/4)*3)
      ----------------------------
      cr:set_line_width(line_width)
      cr:set_line_cap(line_cap)
      cr:set_source_rgba(red,green,blue,alpha)
      cr:move_to(startx,starty)
      cr:line_to(10+pStart, y_pos)
      cr:line_to(x_diff+pStart, height+line_width)
      cr:stroke()
   end

   local drawSurface = function(pStart, pColor)
      top_left_x=0
      top_left_y=0
      rec_width=line_width*2
      rec_height=height
      red=pColor.red()
      green=pColor.green()
      blue=pColor.blue()
      alpha=1
      ----------------------------
      cr:set_line_width(0)
      cr:rectangle(top_left_x,top_left_y,rec_width,rec_height)
      cr:set_source_rgba(red,green,blue,alpha)
      cr:fill()
   end
   
   drawSurface(0,self._color1)
   
   drawLine(0,self._color2)
   drawLine(line_width,self._color3)
end


function separator:setColors(pColor1, pColor2, pColor3)
   self._color1 = pColor1
   self._color2 = pColor2
   self._color3 = pColor3
end

local function new(pColor1, pColor2, pColor3)

   local widget = wibox.widget.base.make_widget()

   -- Merge separtor with the widget
   for k, v in pairs(separator) do
      if type(v) == "function" then
         widget[k] = v
      end
   end

   widget:setColors(pColor1, pColor2, pColor3)

   return widget
end

function separator.mt:__call(...)
    return new(...)
end

return setmetatable(separator, separator.mt)
