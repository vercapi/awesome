local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local diskData  = require("ice.data.disk")
local util      = require("ice.util")

local disk = {}
disk.__index = disk

function disk.create()
   local l_disk = {}
   setmetatable(l_disk, disk)

   l_disk.disks = diskData.getAllDisks()
   
  return l_disk
end

function disk:drawContent()
   graphLayout = wibox.layout.fixed.vertical()
   
   self:showDiskGraph(graphLayout)
   self:showPercentage(graphLayout)

   return graphLayout   
end

function disk:setCurrentDisk(pMountPoint)
   self.diskMountPoint = pMountPoint
end


function disk:showDiskGraph(pLayout)
   self.diskGraph = wibox.widget.progressbar()
   self.diskGraph:set_color(beautiful.fg_normal)
   self.diskGraph:set_background_color(theme.bg_normal)
   
   self.diskGraph:set_ticks(true)
   self.diskGraph:set_ticks_size(15)

   constraintBox = wibox.container.constraint(self.diskGraph, 'max', 100, 15)
   
   -- Create a whitespacing between the graph and the box
   innerBox = wibox.container.margin(constraintBox, 1, 1)
   innerBox:set_top(1)
   innerBox:set_bottom(1)

   -- Drawing the actual box around the graph
   box = wibox.container.margin(innerBox, 1, 1)
   box:set_top(1)
   box:set_bottom(1)
   box:set_color(beautiful.fg_normal)

   -- Ensuring the correct placement of the graph+box
   diskmargin = wibox.container.margin(box, 0, 0)
   diskmargin:set_top(2)
   diskmargin:set_bottom(0)

   pLayout:add(diskmargin)
end

function disk:showPercentage(pLayout)
   self.percentage = wibox.widget.textbox()

   pLayout:add(self.percentage)
end

function disk:init()
   local value = self.disks[self.diskMountPoint]:getPercentagFull()
   self.diskGraph:set_value(value)
   self:setText(value)
end

function disk:update()
   self.disks[self.diskMountPoint]:update()
   local value = self.disks[self.diskMountPoint]:getPercentagFull()
   self.diskGraph:set_value(value)
   self:setText(value)
end

function disk:setText(pValue)
   self.percentage:set_text(string.format("%g", pValue*100) .. '% ')
end

function disk:getState()
   return util.OK
end

return disk
