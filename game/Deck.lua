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
    deck.movingCard = false
    deck.playedCards = {}
    self.__index = self
    return setmetatable(deck, self)
end

function Deck:setSelected()
    self.selected = nil
    local nextKey = nil
    for k,v in pairs(self.cards) do
        local i = math.random(2)
        if i == 2 then
            nextKey =  k
        end
    end
    if not nextKey then
        print("No cards left!")
    else
        self.selected = self.cards[nextKey]
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
    if self.selected then
        if self.selected:IsAtNextPosition() then
            self.movingCard = false
        end
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
    if self.selected and self.center and not self.movingCard then
        self.movingCard = true
        local sel = self.selected
        self.cards = RemoveElement(self.cards, sel)
        sel:play(self.center)
        table.insert(self.playedCards, sel)
        self:setSelected()
        self:setNrOfCards(#self.cards)
        for i,sprite in ipairs(self.cards) do
            sprite:moveTo(self:getNextPos(i))
        end
    end
    if not self.selected then
        print("No cards in hand!")
    end
end

function Deck:GetLeft()
    local b = Utility.GetBefore(self.cards, self.selected)
    if not b then
        local l = Utility.GetLast(self.cards)
        if l then
            self.selected = l
        else
            print("Missing cards in hand!")
        end
    else
        self.selected = b
    end
end

function Deck:GetRight()
    local a = Utility.GetAfter(self.cards, self.selected)
    if not a then
        local f = Utility.GetFirst(self.cards)
        if f then
            self.selected = f
        else
            print("Missing cards in hand!")
        end
    else
        self.selected = a
    end
end

function Deck:changeSelection(direction)
    if self.selected then
        if direction == "left" then
            self:GetLeft()
        else
            self:GetRight()
        end
    end
end

return Deck