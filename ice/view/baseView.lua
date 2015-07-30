local wibox     = require("wibox")
local util      = require("ice.util")
local separator = require("ice.widgets.separator")
local runner    = require("ice.core.Runner")


local base = {}
base.__index = base

function base.create(pLayout, pContent)
   local l_base = {}
   setmetatable(l_base, base)

   if pContent.drawContent == nil and pContent.init == nil and pContent.update == nil and pContent.getState == nil then
      l_base.content = nil -- if these methods don't exist it is not a valid view and the object is unusable
   else
      l_base.content = pContent
   end
   
   l_base.layout = pLayout
   
   return l_base
end

function base:setBgColor(pBgColor)
   self.bgColor = pBgColor   
end

function base:setFgColor(pFgColor)
   self.fgColor = pFgColor   
end

function base:setNextColor(pNextColor)
   self.nextColor = pNextColor   
end

function base:setIcon(pIcon)
   self.icon = pIcon   
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

   if self.content ~= nil then
      vContent = self.content:drawContent()
      self.layout:add(vContent)
      self.content:init()
   end

   
   runner.create(120, base.updator(self))
end

function base.updator(pBase)
   function update()
      if pBase.content ~= nil then pBase.content:update() end
   end

   return update
end

function base:showStatus()
   if(util.WARNING == self.content:getState()) then
      image = wibox.widget.imagebox(theme.warning)
   end
   if(util.ERROR == self.content:getState()) then
      image = wibox.widget.imagebox(theme.error)
   end

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
