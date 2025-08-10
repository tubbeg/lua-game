local Sprite = require ("Sprite")
local Deck = require ("Deck")

local startAtX = 50
local endAtX = 700
local startAtY = 300
local deck = Deck:new(startAtX,startAtY,endAtX)

local dummyId = "sprite.png"
local dummyKey = {id = dummyId, prop = {}}
local keys =
    {
        [1] = dummyKey,
        [2] = dummyKey,
        [3] = dummyKey,
        [4] = dummyKey,
        [5] = dummyKey,
        [6] = dummyKey,
        [7] = dummyKey,
        [8] = dummyKey
    }

function love.mousepressed(x, y, button)
    deck:click(x,y,button)
end

function love.load()
    deck:SetNrOfCards(#keys)
    deck:load(keys)
end

function love.update(dt)
    deck:update(dt)
end

function love.draw()
    deck:draw()
end