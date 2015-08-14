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
   layout:add(baseView.createIcon(updownIcon, "#002b36"))
   
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

function networkView:init()
   networkView:update(nil)
end

function networkView:update(pBase) 
   if(self.iface ~= nil) then
      vCurrentDownRate = self.iface:getCurrentRate("RX")
      self.downloadGraph:add_value(vCurrentDownRate)
      
      vCurrentUpRate = self.iface:getCurrentRate("SX")
      self.uploadGraph:add_value(vCurrentUpRate)   
   end

   self:updateState()
   self:updateIcon(pBase)
end

function networkView:setIface(pIface)
   if(pIface ~= nil) then
      self.iface = self.devices[pIface]
   end
end

function networkView:updateState()
   if self.iface ~= nil then
      self.iface:update()
      connected = self.iface:isUp()
   else
      connected = false
   end
   
   if not connected then
      self.devices = networkData.getDevices()
      vAnyIf = networkData.getAnyConnected()
      self:setIface(vAnyIf)
   end
end

function networkView:updateIcon(pBase)
   if(pBase ~= nil and self.iface ~= nil) then
      if self.iface:isWireless() then
         self:updateIconStrenght(pBase)
      else
         pBase:set_image(beautiful.net_wired)
      end
   end
end

function networkView:updateIconStrenght(pBase)
   local strength = self.iface:getWirelessStrenght()
   if strength == nil then strength = 0 end
   
   if strength >= 90 then
      pBase:set_image(beautiful.net_wireless_max)
   elseif strength >= 60 then
      pBase:set_image(beautiful.net_wireless_mid)
   elseif strength >= 30 then
      pBase:set_image(beautiful.net_wireless_min)
   else
      pBase:set_image(beautiful.net_wireless)
   end
end

function networkView:getState()
   state = util.OK

   if self.iface == nil or self.iface:isDown() then
      state = util.ERROR
   elseif self.iface:getWirelessStrenght() == nil or self.iface:getWirelessStrenght() < 30 then
      state = util.WARNING
   end

   return state
      
end

return networkView
