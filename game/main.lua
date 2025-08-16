local Sprite = require ("Sprite")
local Hand = require ("Hand")
local flux = require("3RD-PARTY/flux/flux")

local wParam = {x=800,y=600}
local startAtX = 50
local endAtX = 700
local startAtY = 300
local playTo = {x=wParam.x/2.4, y=wParam.y/6}

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


local hand = Hand:new(#keys,startAtX,startAtY,endAtX,playTo)

function love.keyreleased( key )
   if key == "x" then
        hand:click()
   end
   if key == "z" then
        print("TBD")
   end
   if key == "left" then
        hand:changeSelection("left")
   end
   if key == "right" then
        hand:changeSelection("right")
   end
end

function love.load()
    if love.window.setMode( wParam.x, wParam.y) then
        love.graphics.setDefaultFilter("nearest", "nearest")
        hand:load(keys)
    else
        print("Something went wrong :/")
    end
end

function love.update(dt)
    flux.update(dt)
    hand:update(dt)
end

function love.draw()

    hand:draw()
end