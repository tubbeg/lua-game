local Sprite = require ("Sprite")
local Deck = {}

function Deck:new (startX, startY, endX, playLocation)
    local deck = {}
    deck.cards = {}
    deck.position = {startX = startX, startY = startY, endX = endX}
    deck.range = deck.position.endX - deck.position.startX
    deck.px = nil
    deck.nr = nil
    deck.center = playLocation
    deck.selected = 1
    deck.playedCards = {}
    self.__index = self
    return setmetatable(deck, self)
end

function Deck:draw()
    for i,s in ipairs(self.cards) do
        s:draw(self.cards[self.selected])
    end
    for i,s in ipairs(self.playedCards) do
        s:draw(nil)
    end
end

function Deck:setNrOfCards(nr)
    if self.range then
        self.px = (self.range/nr) - 5
        self.nr = nr
    end
end

function Deck:getNextPos(i)
    return
        {
            y=self.position.startY,
            x=self.position.startX + (self.px * (i - 1))
        }
end

function Deck:load(keys)
    self:setNrOfCards(#keys)
    for i,k in ipairs(keys) do
        local s = Sprite:new(k.id, self:getNextPos(i)):load()
        if s then
            table.insert(self.cards, s)
        end
    end
end


function Deck:update(dt)
    for i,s in ipairs(self.cards) do
        s:update(dt)
    end
    for i,s in ipairs(self.playedCards) do
        s:update(dt)
    end
end

function RemoveElement(t,e)
    local newTable = {}
    for i,v in ipairs(t) do
        if v ~= e then
            table.insert(newTable,v)
        end
    end
    return newTable
end

function Deck:click()
    local s = self.cards[self.selected]
    if s and self.center then
        s:play(self.center)
        table.insert(self.playedCards, s)
        self.cards = RemoveElement(self.cards, s)
        if #self.cards >= 1 then
            self.selected = 1
        end
        self:setNrOfCards(#self.cards)
        for i,sprite in ipairs(self.cards) do
            sprite:moveTo(self:getNextPos(i))
        end
    end
end

function Deck:changeSelection(direction)
    local i = #self.cards
    if i > 1 then
        if direction == "left" then
            self.selected = self.selected - 1
            if self.selected < 1 then
                self.selected = i
            end
        else
            self.selected = self.selected + 1
            if self.selected > i then
                self.selected =  1
            end
        end
    end
end

return Deck