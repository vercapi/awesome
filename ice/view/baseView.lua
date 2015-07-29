local wibox     = require("wibox")
local util      = require("ice.util")
local separator = require("ice.widgets.separator")


local base = {}
base.__index = base

function base.create(pLayout, pBgColor, pFgColor, pNextColor, pContentFunction, pIcon)
   local l_base = {}
   setmetatable(l_base, base)

   l_base.layout = pLayout
   l_base.bgColor = pBgColor
   l_base.fgColor = pFgColor
   l_base.nextColor = pNextColor
   l_base.contentFunction = pContentFunction
   l_base.icon = pIcon
   
   return l_base
end

function base:getLayout()
   return self.layout
end


function base:getBgColor()
   return self.bgColor
end


function base:getFgColor()
   return self.fgColor
end


function base:getNextColor()
   return self.nextColor
end

function base:showIcon()
   local iconLayout = wibox.layout.fixed.vertical()
   
   self.diskIcon = wibox.widget.imagebox(self.icon)

   iconLayout:add(self.diskIcon)

   iconMargin = wibox.layout.margin(iconLayout, 2, 2)
   iconMargin:set_top(2)
   iconMargin:set_bottom(2)
   
   self:getLayout():add(iconMargin)
end

function base:init()
   self:showSeparator()
   self:showIcon()
   self:showStatus()
   vContent = self.contentFunction()
   self.layout:add(vContent)
end

function base.updator(pBase)
   
end

function base:showStatus() 
   image = wibox.widget.imagebox(theme.warning)
   imageMargin = wibox.layout.margin(image, 2, 2)
   imageMargin:set_top(2)
   imageMargin:set_bottom(25)
   self.layout:add(imageMargin)
end

function base:showSeparator()
   vWidget = separator(util.createColor("#002b36"), util.createColor(theme.bg_normal), util.createColor(theme.fg_normal))

   self:getLayout():add(vWidget)
end

return base
