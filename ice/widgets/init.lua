
local wrequire = require("ice.util").wrequire
local setmetatable = setmetatable

local view = { _NAME = "ice.widgets"}

return setmetatable(view, {__index = wrequire})
