
local wrequire = require("ice.util").wrequire
local setmetatable = setmetatable

local core = { _NAME = "ice.core"}

return setmetatable(core, {__index = wrequire})


