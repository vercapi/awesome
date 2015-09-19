package.path = package.path .. ';../../../?.lua'

local battery = require("ice.data.battery")
local util    = require("ice.util")
local dbus    = require("lua-dbus")
local clock   = os.clock

local function init()
   dbus.init()
end

function sleep(n)
   local t0 = clock()
   while clock() - t0 <= n do end
end


local function stop()
   dbus.exit()
end

local loop = function ()
    dbus.poll()
    sleep(0.3)
end

local function printer(p_table)
   for key, value in pairs(p_table) do
      print("Param ", key, value)
   end
end

local function test_battery()
   init()

   v_battery = battery.create("/org/freedesktop/UPower/devices/battery_BAT1")
   v_battery:on_event_listener(printer)
   v_battery:registerSignal()
--   v_battery:get_parameters()
   while true do
      loop()
   end
   stop()
end

test_battery()
