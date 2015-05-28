
local wrequire = require("ice.util").wrequire
local setmetatable = setmetatable

local view = { _NAME = "ice.view"}

return setmetatable(view, {__index = wrequire})


