local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local cpu       = require("ice.data.cpu")
local util      = require("ice.util")

local cpuView = {}
cpuView.__index = cpuView
   
function cpuView.create(pBgColor, pFgColor)
   local l_cpuView = {}
   setmetatable(l_cpuView, cpuView)

   l_cpuView.bg_color = pBgColor
   l_cpuView.fg_color = pFgColor
   
   return l_cpuView
end


function cpuView:drawContent()
   local graphLayout = wibox.layout.fixed.vertical()

   self:drawGraph(graphLayout)
   self:drawPercentage(graphLayout)
   
   return graphLayout
end

function cpuView:drawGraph(pLayout)
   self.cpuGraph = wibox.widget.graph()
   self.cpuGraph:set_width(70)
   self.cpuGraph:set_background_color(self.bg_color)
   self.cpuGraph:set_color(self.fg_color)
   self.cpuGraph:set_scale(true)

   -- Ensuring the correct placement of the graph+box
   cpu_margin = wibox.container.margin(self.cpuGraph, 0, 0)
   cpu_margin:set_top(2)
   cpu_margin:set_bottom(0)
   
   pLayout:add(cpu_margin)
end

function cpuView:drawPercentage(pLayout)
   self.percentage = wibox.widget.textbox()
   

   pLayout:add(self.percentage)
end

function cpuView:init()
   self:update()
end

function cpuView:update()
   local load = cpu.getLoad()
   self.cpuGraph:add_value(load)
   self.percentage:set_markup("<span color='#268bd2'>" .. string.format("%g", load) .. '%  </span>')
end


function cpuView:getState()
   return util.OK
end

return cpuView
