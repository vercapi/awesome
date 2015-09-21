package.path = package.path .. ';../../../?.lua'

local battery = require("ice.data.battery")
local util    = require("ice.util")

local function test_get_percentage()
   local battery = battery.create('/org/freedesktop/UPower/devices/battery_BAT1')

   local perc = battery:get_percentage()
   assert(perc <= 100 and perc >= 0, "Should be number between 0 and 100: " .. tostring(perc))
end

local function test_is_on_battery()
   local battery = battery.create('/org/freedesktop/UPower/devices/battery_BAT1')

   local is_battery = battery:is_on_battery()
   assert(is_battery, "Should be on battery, when on powersupply expect this to fail")
end


