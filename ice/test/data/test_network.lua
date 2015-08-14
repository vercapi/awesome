package.path = package.path .. ';../../../?.lua'

local Interface = require("ice.data.network")
local util      = require("ice.util")

-- Test to see if we can find devices
local function test_getDevices()
   devices = Interface.getDevices() 
   assert(util.tablelength(devices) >= 1, 'We should get at least one network device')
end

-- Test environmcannot be fixed towards other machines
local function test_getState()
   devices = Interface.getDevices() 
   vDevice = devices['wlp6s0']
   assert(vDevice:getState() == 'connected', 'device state needs to be connected')
end

local function test_isDown()
   devices = Interface.getDevices() 
   vDevice = devices['wlp6s0']
   assert(not vDevice:isDown(), 'device state needs to be connected')
end

local function test_isup()
   devices = Interface.getDevices() 
   vDevice = devices['wlp6s0']
   assert(vDevice:isUp(), 'device state needs to be connected')
end

local function test_getCurrentRate()
   vDevice = Interface.create('wlp6s0')
   assert(vDevice:getCurrentRate(true) >= 0, 'Rate needs to be a possitve number')
   assert(vDevice:getCurrentRate(false) >= 0, 'Rate needs to be a possitve number')
end

-- Test environmcannot be fixed towards other machines
local function test_isWireless()
   devices = Interface.getDevices() 
   vDevice = devices['wlp6s0']
   assert(vDevice:isWireless(), 'device should be wireless')
end

local function test_update()
   devices = Interface.getDevices() 
   vDevice = devices['wlp6s0']
   vDevice:update()

   assert(vDevice.name == "wlp6s0", "Device should be the same, but it is " .. vDevice.name)
end

local function test_getWirelessStrenght()
   devices = Interface.getDevices() 
   vDevice = devices['wlp6s0']

   assert(vDevice:getWirelessStrenght() > 0, "Wireless strenght should be bigger then 0")
end
