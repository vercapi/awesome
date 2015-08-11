local wibox       = require("wibox")
local beautiful   = require("beautiful")
local runner      = require("ice.core.Runner")
local networkData = require("ice.data.network")
local baseView    = require("ice.view.baseView")
local awful       = require("awful")
local util        = require("ice.util")

local networkView = {}
networkView.__index = networkView

function networkView.create()
   local network = {}
   setmetatable(network, networkView)
  
   network.devices = networkData.getDevices()
   network.max = 1000

   return network
end

function networkView:drawContent()
   layout = wibox.layout.fixed.horizontal()

   self.downloadGraph = networkView.createGraph()
   networkView.addGraph(self.downloadGraph, layout)
   
   updownIcon = wibox.widget.imagebox(theme.netupdown)
   layout:add(baseView.createIcon(updownIcon))
   
   self.uploadGraph = networkView.createGraph()
   networkView.addGraph(self.uploadGraph, layout)
   
   return layout
end

function networkView.createGraph()
   graph = awful.widget.graph()   
   graph:set_width(70)
   graph:set_background_color("#002b36")
   graph:set_color("#b58900")
   graph:set_scale(true)

   return graph
end

function networkView.addGraph(pGraph, pLayout)
   margin = wibox.layout.margin(pGraph, 2, 2)
   margin:set_top(5)
   margin:set_bottom(5)

   pLayout:add(margin)
end

function networkView:showUpload()
   vIcon = wibox.widget.imagebox(beautiful.netup)

   vGraph = awful.widget.graph()   
   vGraph:set_width(70)
   vGraph:set_background_color(beautiful.bg_normal)
   vGraph:set_color(beautiful.fg_normal)
   vGraph:set_scale(true)

   -- Needs to be available on object scope for updating the values
   self.uploadWidget= vGraph

   self.layout:add(vIcon)
   self.layout:add(self.uploadWidget)
end

function networkView:init()
   networkView:update()
end

function networkView:update()
   if(self.iface ~= nil) then
      vCurrentDownRate = self.iface:getCurrentRate("RX")
      self.downloadGraph:add_value(vCurrentDownRate)
      
      vCurrentUpRate = self.iface:getCurrentRate("SX")
      self.uploadGraph:add_value(vCurrentUpRate)   
   end

   networkView:updateState()   
end

function networkView:setIface(pIface)
   self.iface = self.devices[pIface]
end
      
function networkView:updateState()
   if self.iface ~= nil then
      vState = self.iface:getState()
   else
      vState = nil
   end
   
   if vState ~= "UP" then
      vAnyIf = networkData.getAnyConnected()
      --self:setIface(vAnyIf)
   end

   -- if(self.iface ~= nil) then
   --    if self.iface:isWireless() then
   --       self.netIcon:set_image(beautiful.net_wireless)
   --    else
   --       self.netIcon:set_image(beautiful.net_wired)
   --    end
   -- else
   --    self.netIcon:set_image(beautiful.awesome_icon)
   -- end   
end

function networkView:getState()
   return util.OK
end

return networkView
