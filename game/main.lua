local Sprite = require ("Sprite")
local Deck = require ("Deck")
local flux = require("3RD-PARTY/flux/flux")

local wParam = {x=800,y=600}
local startAtX = 50
local endAtX = 700
local startAtY = 300
local playTo = {x=wParam.x/2.4, y=wParam.y/6}
local deck = Deck:new(startAtX,startAtY,endAtX,playTo)

local dummyId = "assets/aseprite/bomb.png"
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

function love.keyreleased( key )
   if key == "x" then
        deck:click()
   end
   if key == "z" then
        print("TBD")
   end
   if key == "left" then
        deck:changeSelection("left")
   end
   if key == "right" then
        deck:changeSelection("right")
   end
   if key == "z" then
        print("TBD")
   end
end

function love.load()
    if love.window.setMode( wParam.x, wParam.y) then
        love.graphics.setDefaultFilter("nearest", "nearest")
        deck:load(keys)
    else
        print("Something went wrong :/")
    end
end

function love.update(dt)
    flux.update(dt)
    deck:update(dt)
end

function love.draw()

    deck:draw()
end