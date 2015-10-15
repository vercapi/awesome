package.path = package.path .. ';../../../?.lua'

local processes = require("ice.data.processes")

local function test_get_current_user()
   assert(processes.get_current_user() == "vercapi", "User wrong, check the correct user is in the test")
end

local function test_existing_process()
   assert(processes.get_pid("emacs") > 0, "emacs should be running")
end

local function test_non_existing_process()
   assert(processes.get_pid("no_process") == 0, "this should not be running")
end
