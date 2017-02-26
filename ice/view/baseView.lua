local wibox     = require("wibox")
local util      = require("ice.util")
local separator = require("ice.widgets.separator")
local runner    = require("ice.core.Runner")


local base = {}
base.__index = base

function base.create(pContent, pCycle, pSeparator)
   local l_base = {}
   setmetatable(l_base, base)

   if pContent.drawContent == nil and pContent.init == nil and pContent.update == nil and pContent.getState == nil then
      l_base.content = nil -- if these methods don't exist it is not a valid view and the object is unusable
   else
      l_base.content = pContent
   end
   
   l_base.layout = wibox.layout.fixed.horizontal()
   l_base.cycle = pCycle
   l_base.use_separator = pSeparator
   
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

function base:getImage()
   return self.diskIcon
end

function base:addToLayout(pWidget)
   self:getLayout():add(pWidget)
end

function base:showIcon()
   if(self.icon) then
      self.diskIcon = wibox.widget.imagebox(self.icon)
      self:addToLayout(base.createIcon(self.diskIcon, self:getBgColor()))
   end
end

function base.createIcon(pIcon, pBgColor)

   iconMargin = wibox.layout.margin(pIcon, 2, 2)
   iconMargin:set_top(2)
   iconMargin:set_bottom(2)
   iconMargin:set_color(pBgColor)

   return iconMargin
end

function base:init()
   self:showSeparator()
   self:showIcon()
   self:showStatus()
   self:updateStatus()

   if self.content ~= nil then
      vContent = self.content:drawContent()
      self:addToLayout(vContent)
      self.content:init()
   end

   if(self.cycle > 0) then
      runner.create(self.cycle, base.updator(self))
   end
end

function base.updator(pBase)
   function update()
      if pBase.content ~= nil then pBase.content:update(pBase:getImage()) end
      pBase:updateStatus()
   end

   return update
end

function base:updateStatus()
   if(util.WARNING == self.content:getState()) then
      self.statusImage:set_image(theme.warning)
   elseif(util.ERROR == self.content:getState()) then
      self.statusImage:set_image(theme.error)
   else
      self.statusImage:set_image(nil)
   end
end

function base:showStatus()
   self.statusImage = wibox.widget.imagebox()

   imageMargin = wibox.layout.margin(self.statusImage, 2, 2)
   imageMargin:set_top(2)
   imageMargin:set_bottom(25)
   imageMargin:set_color(self:getBgColor())
   
   self:addToLayout(imageMargin)
end

function base:showSeparator()
   if(self.use_separator) then
      vWidget = separator(util.createColor(self:getNextColor()), util.createColor(self:getBgColor()), util.createColor(self:getFgColor()))
      self:addToLayout(vWidget)
   end
end

return base
