
local Utility = {}

function Utility.PosAreEqual(pos1,pos2) return pos1.y == pos2.y and pos1.x == pos2.x end
function Utility.InRange(startRange,endRange,value) return value > startRange and value < endRange end



return Utility