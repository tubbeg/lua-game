
local Utility = {}

function Utility.PosAreEqual(pos1,pos2) return pos1.y == pos2.y and pos1.x == pos2.x end
function Utility.InRange(startRange,endRange,value) return value > startRange and value < endRange end


function Utility.GetFirst(t)
    for k,v in pairs(t) do
        return v
    end
    return nil
end

function Utility.GetLast(t)
    local last = nil
    for k,v in pairs(t) do
        last = k
    end
    if last then
        return t[last]
    end
    return nil
end

function Utility.GetAfter(t,e)
    local hasElement = false
    for k,v in pairs(t) do
        if hasElement then
            return v
        end
        if v == e then
            hasElement = true
        end
    end
    return nil
end

function Utility.GetBefore(t,e)
    local before = nil
    for k,v in pairs(t) do
        if v == e then
            return before
        end
        before = v
    end
    return before
end

return Utility