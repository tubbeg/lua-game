

--[[

NOTE: The z-index has been removed. The drawing is based on
which element comes first in the table, i.e. the table index

So it's essentially the same thing. I realized that the Deck
class should be responsible for keeping track of the z-index,
and not the individual sprites
]]

local Sprite = require ("Sprite")
local Deck = {}


function Deck:new (startX, startY, endX)
    local deck = {}
    deck.cards = {}
    deck.draggedCard = nil
    deck.position = {startX = startX, startY = startY, endX = endX}
    deck.range = deck.position.endX - deck.position.startX
    deck.px = nil
    deck.nr = nil
    self.__index = self
    return setmetatable(deck, self)
end

function Deck:draw()
    for i,s in ipairs(self.cards) do
        s:draw()
    end
end

function Deck:SetNrOfCards(nr)
    if self.range then
        self.px = (self.range/nr) + 5
        self.nr = nr
    end
end

function Deck:GetNextPos(i)
    local position = {}
    position.y = self.position.startY
    position.x = self.position.startX + (self.px * (i - 1))
    return position
end

function Deck:GetZIndex()
    
end

function Deck:load(keys)
    for i,k in ipairs(keys) do
        local s = Sprite:new(self:GetNextPos(i), k.id, keys.prop)
        table.insert(self.cards, s)
    end
end

function Deck:update(dt)
    for i,s in ipairs(self.cards) do
        s:updatePos(dt)
    end
    self:StopDrag()
    self:HandleCollision()
end

function Deck:ResetDrag()
    for i,s in ipairs(self.cards) do
        s:resetDrag()
    end
end

function Deck:SetCardOnClick(x,y,button)
    if button == 1 then
        for i,s in ipairs(self.cards) do
            if s:posOverlap({x=x,y=y}) then
                self.draggedCard = s
            end
        end
    end
end

function Deck:click(x,y,button)
    self:ResetDrag()
    self:SetCardOnClick(x,y,button)
    if self.draggedCard then
        self.draggedCard:setDrag({x=x,y=y})
    end
end

function Deck:StopDrag()
    if not love.mouse.isDown(1) then
        for i,s in ipairs(self.cards) do
            self.draggedCard = nil
            s:resetDrag()
        end
    end
end

function SortByPos (a,b)
    return a.origin.x > b.origin.x
end

function Deck:UpdateZindex()
    table.sort(self.cards, SortByPos)
end


function Deck:SwapCardsOnCollision(sprite)
    if sprite ~= self.draggedCard then
        if sprite:HasCollided(self.draggedCard) then
            sprite:SwapOrigin(self.draggedCard)
            sprite:DisableCollisionUntilOrigin()
            self:UpdateZindex()
        end
    end
end

function Deck:HandleCollision()
    if self.draggedCard then
        for i,s in ipairs(self.cards) do
            self:SwapCardsOnCollision(s)
        end
    end
end


return Deck