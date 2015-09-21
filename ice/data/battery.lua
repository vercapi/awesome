local util      = require("ice.util")


local battery = {}
battery.__index = battery

function battery.create(p_device)
   local l_battery = {}
   setmetatable(l_battery, battery)

   l_battery.device = p_device
   l_battery.parameters = l_battery:get_info()
   
   return l_battery
end

function battery:get_percentage()
     return tonumber(self.parameters.percentage:sub(1, -2))
end

function battery:is_on_battery()
   local raw_state = self.parameters.state
   raw_state = util.trim(raw_state)
   print('raw ', raw_state)
   return raw_state == 'discharging' --discharging doesn't happen with power plugged in
end

function battery:update()
   self.parameters = self:get_info()
end

function battery:get_info()
   local result = io.popen("upower -i " .. self.device .. "|  awk '{ print $0 \"\\n\" }'")
   local all_lines = result:read("*all")
   result:close()

   parameters = {}
   
   for parameter_line in all_lines:gmatch("[^\n]+") do
      local key = nil
      parameter_line = parameter_line:gsub("^%s*(.-)%s*$", "%1")
      for key_value in parameter_line:gmatch("[^:]+") do
         if(key) then
            parameters[key] = key_value
            key = nil
         else
            key = key_value
         end
      end
   end

   return parameters
end


return battery
