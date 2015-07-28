local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local runner    = require("ice.core.Runner")
local diskData  = require("ice.data.disk")
local separator = require("ice.widgets.separator")
local util      = require("ice.util")

local disk = {}
disk.__index = disk

function disk.create(pLayout)
   local l_disk = {}
   setmetatable(l_disk, disk)

   l_disk.layout = pLayout

   l_disk.disks = diskData.getAllDisks()

   l_disk:showSeparator()
   l_disk:showDiskIcon()
   l_disk:showPercentage()
   l_disk:showDiskGraph()
   
  return l_disk
end


function disk:setCurrentDisk(pMountPoint)
   self.diskMountPoint = pMountPoint
end

function disk:showDiskIcon()
   self.diskIcon = wibox.widget.imagebox(theme.disk)
   self.layout:add(self.diskIcon)
end


function disk:showDiskGraph()
   self.diskGraph = awful.widget.progressbar()
   self.diskGraph:set_color(beautiful.fg_normal)
   self.diskGraph:set_background_color(theme.bg_normal)
   self.diskGraph:set_width(100)
   self.diskGraph:set_height(22)
   self.diskGraph:set_ticks(true)
   self.diskGraph:set_ticks_size(20)

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
   diskmargin = wibox.layout.margin(box, 2, 7)
   diskmargin:set_top(6)
   diskmargin:set_bottom(20)
      
   self.layout:add(diskmargin)
end

function disk:showPercentage()
   self.percentage = wibox.widget.textbox()
   self.percentage:set_text("60%")

   textMargin = wibox.layout.margin(self.percentage, 0, 0)
   textMargin:set_bottom(16)

   self.layout:add(textMargin)   
end


function disk:showSeparator()
   vWidget = separator(util.createColor("#002b36"), util.createColor("#eee8d5"))

   self.layout:add(vWidget)
end


function disk:start()
   value = self.disks[self.diskMountPoint]:getPercentagFull()
   self.diskGraph:set_value(value)
   
   runner.create(120, disk.updator(self))
end

function disk.updator(pDisk)
   function update()
      value = pDisk.disks[pDisk.diskMountPoint]:getPercentagFull()
      pDisk.diskGraph:set_value(value)
   end

   return update
end

return disk

