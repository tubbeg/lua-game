
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


function Utility.GetLeft(t,e)
    local b = Utility.GetBefore(t, e)
    if not b then
        return Utility.GetLast(t)
    end
    return b
end

function Utility.GetRight(t,e)
    local a = Utility.GetAfter(t,e)
    if not a then
        return Utility.GetFirst(t)
    end
    return a
end

function Utility.RemoveElement(t,e)
    local newTable = {}
    for i,v in ipairs(t) do
        if v ~= e then
            table.insert(newTable,v)
        end
    end
    return newTable
end


function Utility.GetAllKeys(t)
    local listOfKeys = {}
    for k,v in pairs(t) do
        table.insert(listOfKeys, k)
    end
    return listOfKeys
end


function Utility.GetRandomElement(t)
    local allKeys = Utility.GetAllKeys(t)
    local len = #allKeys
    local randomNumber = math.random(len)
    local nextKey = allKeys[randomNumber]
    if nextKey then
        return t[nextKey]
    end
    return nil
end

return Utility