
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local runner      = require("ice.core.Runner")
local networkData = require("ice.data.Interface")
local awful       = require("awful")
local util        = require("ice.util")

local networkView = {}
networkView.__index = networkView

function networkView.create(pLayout)
   local network = {}
   setmetatable(network, networkView)
  
   network.layout = pLayout
   network.devices = networkData.getDevices()
   network.max = 1000

   network:showNetIcon()
   network:showDownload()
   network:showUpload()
   
   return network
end

function networkView:showNetIcon()
   self.netIcon = wibox.widget.imagebox(beautiful.disk)
   self.layout:add(self.netIcon)   
end

function networkView:showDownload()
   vIcon = wibox.widget.imagebox(beautiful.netdown)

   vGraph = awful.widget.graph()   
   vGraph:set_width(70)
   vGraph:set_background_color(beautiful.bg_normal)
   vGraph:set_color(beautiful.fg_normal)
   vGraph:set_scale(true)

   -- Needs to be available on object scope for updating the values
   self.downloadWidget= vGraph

   self.layout:add(vIcon)
   self.layout:add(self.downloadWidget)
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

function networkView:start()
   runner.create(1, networkView.updator(self))
end

function networkView:setIface(pIface)
   self.iface=self.devices[pIface]
end

function networkView.updator(pNetwork)
   function update()
      if(pNetwork.iface ~= nil) then
         vCurrentDownRate = pNetwork.iface:getCurrentRate("RX")
         pNetwork.downloadWidget:add_value(vCurrentDownRate)
         
         vCurrentUpRate = pNetwork.iface:getCurrentRate("SX")
         pNetwork.uploadWidget:add_value(vCurrentUpRate)
      end
      
      pNetwork:updateState()
   end

   return update
end

function networkView:updateState()
   if vState ~= "UP" then
      vAnyIf = networkData.getAnyConnected()
      self:setIface(vAnyIf)
   end

   if(self.iface ~= nil) then
      if self.iface:isWireless() then
         self.netIcon:set_image(beautiful.net_wireless)
      else
         self.netIcon:set_image(beautiful.net_wired)
      end
   else
      self.netIcon:set_image(beautiful.awesome_icon)
   end
   
end

return networkView
