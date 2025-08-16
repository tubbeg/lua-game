local Sprite = require ("Sprite")
local Utility = require("utility")
local Hand = {}


function Hand:new (nr,startX, startY, endX, playLocation)
    local hand = {}
    hand.cards = {}
    hand.position = {startX = startX, startY = startY, endX = endX}
    hand.nr = nr
    hand.center = playLocation
    hand.selected = nil
    self.__index = self
    return setmetatable(hand, self)
end

function Hand:setSelected()
    self.selected = nil
    local nextCard = Utility.GetRandomElement(self.cards)
    if nextCard then
        self.selected = nextCard
    end
end

function Hand:draw()
    for i,s in ipairs(self.cards) do
        if s ~= self.selected then
            s:draw()
        end
    end
    if self.selected then
        self.selected:drawAsSelected()
    end
end

function Hand:getNextPos(i)
    local range = self.position.endX - self.position.startX
    local px = (range/self.nr) - 5
    return
        {
            y=self.position.startY,
            x=self.position.startX + (px * (i - 1))
        }
end

function Hand:load(keys)
    for i,k in ipairs(keys) do
        local s = Sprite:new(k.id, self:getNextPos(i)):load()
        if s then
            table.insert(self.cards, s)
        end
    end
    self:setSelected()
end


function Hand:update(dt)
    for i,s in ipairs(self.cards) do
        s:update(dt)
    end
end


function Hand:PlaySelectedCard()
    local selectedCard = self.selected
    self.selected = nil
    self.cards = Utility.RemoveElement(self.cards, selectedCard)
    self.nr = self.nr - 1
    for i,sprite in ipairs(self.cards) do
        sprite:moveTo(self:getNextPos(i))
    end
    selectedCard:moveTo(self.center)
    self:setSelected()
    return selectedCard
end

function Hand:click()
    if self.selected then
        return self:PlaySelectedCard()
    end
    return nil
end

function Hand:GetCardFromDir(direction)
    if direction == "left" then
        return Utility.GetLeft(self.cards, self.selected)
    end
    return Utility.GetRight(self.cards, self.selected)
end


function Hand:changeSelection(direction)
    if self.selected then
        local card = self:GetCardFromDir(direction)
        if card then
            self.selected = card
        end
    end
end

return Hand