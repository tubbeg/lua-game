local Sprite = require ("Sprite")
local Utility = require("utility")
local Deck = {}

function Deck:new (startX, startY, endX, playLocation)
    local deck = {}
    deck.cards = {}
    deck.position = {startX = startX, startY = startY, endX = endX}
    deck.range = deck.position.endX - deck.position.startX
    deck.px = nil
    deck.nr = nil
    deck.center = playLocation
    deck.selected = nil
    deck.playedCards = {}
    self.__index = self
    return setmetatable(deck, self)
end

function Deck:setSelected()
    self.selected = nil
    local nextCard = Utility.GetRandomElement(self.cards)
    if nextCard then
        self.selected = nextCard
    else
        print("No cards in hand")
    end
end

function Deck:draw()
    for i,s in ipairs(self.cards) do
        if s ~= self.selected then
            s:draw()
        end
    end
    for i,s in ipairs(self.playedCards) do
        s:draw()
    end
    if self.selected then
        self.selected:drawAsSelected()
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
    self:setSelected()
end


function Deck:update(dt)
    for i,s in ipairs(self.cards) do
        s:update(dt)
    end
    for i,s in ipairs(self.playedCards) do
        s:update(dt)
    end
end


function Deck:click()
    if self.selected then
        local sel = self.selected
        self.cards = Utility.RemoveElement(self.cards, sel)
        self:setNrOfCards(#self.cards)
        for i,sprite in ipairs(self.cards) do
            sprite:moveTo(self:getNextPos(i))
        end
        sel:moveTo(self.center)
        table.insert(self.playedCards, sel)
        self:setSelected()
    end
    if not self.selected then
        print("There is not selected card!")
    end
end


function Deck:changeSelection(direction)
    if self.selected then
        if direction == "left" then
            local left = Utility.GetLeft(self.cards, self.selected)
            if left then
                self.selected = left
            else
                print("NO CARDS LEFT")
            end
        else
            local right = Utility.GetRight(self.cards, self.selected)
            if right then
                self.selected = right
            else
                print("NO CARDS LEFT")
            end
        end
    end
end

return Deck