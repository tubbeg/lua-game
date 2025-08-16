local Sprite = require ("Sprite")
local Utility = require("utility")
local Discard = {}

-- TBD
function Discard:new (startX, startY, endX, playLocation)
    self.__index = self
    return setmetatable(Discard, self)
end


return Discard