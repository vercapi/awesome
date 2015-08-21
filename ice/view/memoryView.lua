local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local memory    = require("ice.data.memory")
local util      = require("ice.util")

local memoryView = {}
memoryView.__index = memoryView
   
function memoryView.create()
   local l_memoryView = {}
   setmetatable(l_memoryView, memoryView)

   l_memoryView.data = memory.create()
   
   return l_memoryView
end

function memoryView:drawContent()
   self.percentage = wibox.widget.textbox()
   return self.percentage
end

function memoryView:init()
   self:update()
end

function memoryView:update()
   self.data:update()
   local free_mem = self.data:getFreeMemory()
   self.percentage:set_markup("<span color='#2aa198'>" .. string.format("%u", free_mem) .. ' MB </span>')
   
end

function memoryView:getState()
   return util.OK
end

return memoryView
