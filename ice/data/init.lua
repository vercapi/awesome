
local wrequire = require("ice.util").wrequire
local setmetatable = setmetatable

local data = { _NAME = "ice.data"}

return setmetatable(data, {__index = wrequire})

