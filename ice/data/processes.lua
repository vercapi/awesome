util = require("ice.util")

local processes = {}
processes.__index = processes
   
function processes.create()
   local l_processes = {}
   setmetatable(l_processes, processes)
   
   return l_processes
end

function processes.get_current_user()
   local result = io.popen("whoami")
   local username = result:read("*all")
   result:close()

   return util.trim(username)
end

function processes.get_pid(pName)
   local result = io.popen("ps aux -U " .. processes.get_current_user() .. " | grep " .. pName  .. " | grep -v grep | awk '{print $2}'")
   local proces_list = result:read("*all")
   result:close()

   local pid = 0
   for value in proces_list:gmatch("%w+") do
      pid = tonumber(value)
   end

   return pid
end

return processes
