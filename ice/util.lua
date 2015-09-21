local util = {}
local io   = { open = io.open, lines = io.lines }

util.WARNING = "WARNING"
util.ERROR = "ERROR"
util.OK = "OK"

function util.wrequire(table, key)
   local module = rawget(table, key)
   return module or require(table._NAME .. '.' .. key)
end

function util.tablelength(T)
   local count = 0
   for _ in pairs(T) do count = count + 1 end
   return count
end

function util.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function util.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function util.cairoColorRGB(pRGBValue)
   return pRGBValue/255
end

function util.cairoColorHEX(pHexValue)
   return util.cairoColorRGB(tonumber(pHexValue, 16))
end

function util.createColor(pHexValue)
   local self = {hexValue = pHexValue}

   local red = function()
      vHex = string.sub(self.hexValue, 2, 3)
      return util.cairoColorHEX(vHex)
   end

   local green = function()
      vHex = string.sub(self.hexValue, 4, 5)
      return util.cairoColorHEX(vHex)
   end

   local blue = function()
      vHex = string.sub(self.hexValue, 6, 7)
      return util.cairoColorHEX(vHex)
  end

  return {red = red, green = green, blue = blue}
end

function util.linesFromFile(pFile)
   lines = {}

   for line in io.lines(pFile) do
      lines[#lines + 1] = line
   end

   return lines
end

-- Remove leading and trailing whitespace
function util.trim(p_string)
   return p_string:gsub("^%s*(.-)%s*$", "%1")
end

return util
