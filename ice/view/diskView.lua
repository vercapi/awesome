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

   graphLayout = wibox.layout.fixed.vertical()
   
   l_disk:showSeparator()
   l_disk:showDiskIcon()
   l_disk:showStatus()
   l_disk:showDiskGraph(graphLayout)
   l_disk:showPercentage(graphLayout)
   l_disk.layout:add(graphLayout)
   
  return l_disk
end


function disk:setCurrentDisk(pMountPoint)
   self.diskMountPoint = pMountPoint
end

function disk:showDiskIcon()
   local iconLayout = wibox.layout.fixed.vertical()
   
   self.diskIcon = wibox.widget.imagebox(theme.disk)
   self.diskName = wibox.widget.textbox("HD")
   self.diskName:set_font('SquareFont 5')

   iconLayout:add(self.diskIcon)
   iconLayout:add(self.diskName)

   iconMargin = wibox.layout.margin(iconLayout, 2, 2)
   iconMargin:set_top(2)
   iconMargin:set_bottom(2)
   
   self.layout:add(iconMargin)
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


function disk:showSeparator()
   vWidget = separator(util.createColor("#002b36"), util.createColor(theme.bg_normal), util.createColor(theme.fg_normal))

   self.layout:add(vWidget)
end

function disk:showStatus()
   image = wibox.widget.imagebox(theme.warning)
   imageMargin = wibox.layout.margin(image, 2, 2)
   imageMargin:set_top(2)
   imageMargin:set_bottom(25)
   self.layout:add(imageMargin)
end


function disk:start()
   value = self.disks[self.diskMountPoint]:getPercentagFull()
   self.diskGraph:set_value(value)
   self.percentage:set_text(string.format("%u", value*100) .. '%')
   
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

