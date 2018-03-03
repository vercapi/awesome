local awful     = require("awful")
local wibox     = require("wibox")
local runner    = require("ice.core.Runner")
local util      = require("ice.util")
local beautiful = require("beautiful")
local separator = require("ice.widgets.separator")
local base = require("wibox.widget.base")

local clockView = { mt = {} }
clockView.__index = clockView

function clockView:fit(context, width, height)
   return 70, height
end

function clockView:draw (wibox, cr, width, height)

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

   drawText(12, 17, os.date('%H:%M:%S'))
   drawText(12, 30, os.date('%A'))
   drawText(12, 40, os.date('%d/%b/%y'))
end

local function new()
   local widget = base.make_widget()

   -- Merge separtor with the widget
   for k, v in pairs(clockView) do
      if type(v) == "function" then
         widget[k] = v
      end
   end
   
   return widget
end

function clockView.mt:__call(...)
    return new(...)
end
          
return setmetatable(clockView, clockView.mt)
