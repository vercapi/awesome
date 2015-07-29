local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local runner    = require("ice.core.Runner")
local diskData  = require("ice.data.disk")
local util      = require("ice.util")
local base      = require("ice.view.baseView")

local disk = {}
disk.__index = disk

function disk.create(pLayout)
   local l_disk = {}
   setmetatable(l_disk, disk)

   l_disk.base = base.create(pLayout, theme.bg_normal, theme.fg_normal, "#002b36", disk:getContentFunction(), theme.disk)
   l_disk.base:init()

   l_disk.disks = diskData.getAllDisks()
   
  return l_disk
end

function disk.getContentFunction(pDisk)
   function drawContent()
      graphLayout = wibox.layout.fixed.vertical()
      
      pDisk:showDiskGraph(graphLayout)
      pDisk:showPercentage(graphLayout)

      return graphLayout
   end

   return drawContent
end

function disk:setCurrentDisk(pMountPoint)
   self.diskMountPoint = pMountPoint
end


function disk:showDiskGraph(pLayout)
   self.diskGraph = awful.widget.progressbar()
   self.diskGraph:set_color(beautiful.fg_normal)
   self.diskGraph:set_background_color(theme.bg_normal)
   self.diskGraph:set_width(100)
   self.diskGraph:set_height(15)
   self.diskGraph:set_ticks(true)
   self.diskGraph:set_ticks_size(15)

   -- Create a whitespacing between the graph and the box
   innerBox = wibox.layout.margin(self.diskGraph, 1, 1)
   innerBox:set_top(1)
   innerBox:set_bottom(1)

   -- Drawing the actual box around the graph
   box = wibox.layout.margin(innerBox, 1, 1)
   box:set_top(1)
   box:set_bottom(1)
   box:set_color(beautiful.fg_normal)

   -- Ensuring the correct placement of the graph+box
   diskmargin = wibox.layout.margin(box, 0, 0)
   diskmargin:set_top(2)
   diskmargin:set_bottom(0)

   pLayout:add(diskmargin)
end

function disk:showPercentage(pLayout)
   self.percentage = wibox.widget.textbox()

   pLayout:add(self.percentage)
end

function disk:start()
   value = self.disks[self.diskMountPoint]:getPercentagFull()
   self.diskGraph:set_value(value)
   self.percentage:set_text(string.format("%u", value*100) .. '% ')
   
   runner.create(120, disk.updator(self))
end

function disk.updator(pDisk)
   function update()
      value = pDisk.disks[pDisk.diskMountPoint]:getPercentagFull()
      pDisk.diskGraph:set_value(value)
      base.updator(pDisk.base)
   end

   return update
end

return disk

