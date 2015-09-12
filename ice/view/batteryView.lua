local batteryView = {}
   batteryView.__index = batteryView
   
   function batteryView.create()
      local l_batteryView = {}
      setmetatable(l_batteryView, batteryView)
      
      return l_batteryView
   end

return batteryView
