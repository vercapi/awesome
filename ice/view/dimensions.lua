local awful          = require("awful")

local dimensions = {}
dimensions.__index = dimensions

function dimensions.get_height_header(p_screen)
   if (p_screen == 1 ) then
      return 44
   end

   if (p_screen == 2) then
      return 22
   end
   
end

return dimensions
