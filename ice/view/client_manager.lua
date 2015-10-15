local capi = {client = client}
local processes = require("ice.data.processes")
local awful = require("awful")

local client_manager = {}
client_manager.__index = client_manager

function client_manager.spawn(p_command)
   
   local pid = processes.get_pid(p_command)
   if pid > 0 then
      cl = client_manager.get_client(pid)
      awful.client.jumpto(cl, false)
   else
      awful.client.spawn(p_command)
   end
end

function client_manager.get_client(p_pid)
   local clients = capi.client.get()

   for k, cl in pairs(clients) do
      if cl.pid == p_pid then
         return cl
      end
   end
end

return client_manager
