-----------------------------------------------------------------------------------------------------------------------
--                                                   RedFlat library                                                 --
-----------------------------------------------------------------------------------------------------------------------

local wrequire = require("newflat.util").wrequire
local setmetatable = setmetatable

local lib = { _NAME = "newflat.gauge.tag" }

return setmetatable(lib, { __index = wrequire })
