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
   vDevice = Interface.create('wlp6s0')
   assert(vDevice:getState() == 'UP', 'device state needs to be UP')
end

local function test_getCurrentRate()
   vDevice = Interface.create('wlp6s0')
   assert(vDevice:getCurrentRate(true) >= 0, 'Rate needs to be a possitve number')
   assert(vDevice:getCurrentRate(false) >= 0, 'Rate needs to be a possitve number')
end
