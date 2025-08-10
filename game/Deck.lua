

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
    deck.isPlayingCard = false -- multiple cards cannot be played at the same time
    self.__index = self
    return setmetatable(deck, self)
end

function Deck:draw()
    if not self.draggedCard then
        for i,s in ipairs(self.cards) do
            s:draw()
        end
    else
        for i,s in ipairs(self.cards) do
            if s ~= self.draggedCard then
                s:draw()
            end
        end
        self.draggedCard:draw()
    end
end

function Deck:SetNrOfCards(nr)
    if self.range then
        self.px = (self.range/nr) - 5
        self.nr = nr
    end
end

function Deck:GetNextPos(i)
    local position = {}
    position.y = self.position.startY
    position.x = self.position.startX + (self.px * (i - 1))
    return position
end

function Deck:load(keys)
    for i,k in ipairs(keys) do
        local s = Sprite:new(self:GetNextPos(i), k.id, keys.prop)
        table.insert(self.cards, s)
    end
end

-- I could also set the element to nil
-- but it causes a bug where other cards
-- also disappear. It might have to do something
-- with the sorting function
function RemoveElement(t,index)
    local newTable = {}
    for i,v in ipairs(t) do
        if i ~= index then
            table.insert(newTable,v)
        end
    end
    return newTable
end


function Deck:RemoveCard(index,s)
    if s:AnimationComplete() then
        self.cards = RemoveElement(self.cards, index)
        self:SetNrOfCards(#self.cards)
        for j,card in ipairs(self.cards) do
            card.origin = self:GetNextPos(j)
        end
        self.isPlayingCard = false
    end
end

function Deck:update(dt)
    for i,s in ipairs(self.cards) do
        s:Update(dt)
        self:RemoveCard(i,s)
    end
    self:StopDrag()
    self:HandleCollision()
end

function Deck:ResetDrag()
    for i,s in ipairs(self.cards) do
        s:resetDrag()
    end
end

function Deck:SetCardOnLeftClick(x,y,button)
    if button == 1 then
        for i,s in ipairs(self.cards) do
            if s:posOverlap({x=x,y=y}) then
                self.draggedCard = s
            end
        end
    end
end


function PlayAnimation(card)
    -- TBD
end

function Deck:PlayCard(s)
    if not self.isPlayingCard then
        self.isPlayingCard = true
        s:Play({x=300, y=100})
    end
end


function Deck:SelectCardOnRightClick(x,y,button)
    if button == 2 then
        for i,s in ipairs(self.cards) do
            if s:posOverlap({x=x,y=y}) then
                self:PlayCard(s)
            end
        
        end 
    end
end

function Deck:click(x,y,button)
    self:ResetDrag()
    if not self.isPlayingCard then
        self:SetCardOnLeftClick(x,y,button)
        self:SelectCardOnRightClick(x,y,button)
        if self.draggedCard and not self.isPlayingCard then
            self.draggedCard:setDrag({x=x,y=y})
        end
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
    if self.draggedCard and not self.isPlayingCard then
        for i,s in ipairs(self.cards) do
            self:SwapCardsOnCollision(s)
        end
    end
end


return Deck