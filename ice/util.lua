local util = {}

function util.wrequire(table, key)
   local module = rawget(table, key)
   return module or require(table._NAME .. '.' .. key)
end

function util.tablelength(T)
   local count = 0
   for _ in pairs(T) do count = count + 1 end
   return count
end

return util
