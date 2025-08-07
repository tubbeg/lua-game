
local tween = require ("3RD-PARTY/tween/tween")
local Sprite = require ("Sprite")
local Utility = require ("utility")

local sprite = {}

function StopDrag()
    if not love.mouse.isDown(1) then sprite:resetDrag() end
end

function IsLeftClickOnSprite(x,y,button)
    return button == 1 and sprite:posOverlap({x=x,y=y})
end

function love.mousepressed(x, y, button)
    sprite:resetDrag()
    if IsLeftClickOnSprite(x,y,button) then sprite:setDrag({x=x,y=y}) end
end

function love.load()
    sprite = Sprite:new({x=300,y=300}, "sprite.png")
end


function love.update(dt)
    sprite:updatePos(dt)
    StopDrag()
end

function love.draw()
    --love.graphics.scale( 0.25, 0.25 )
    sprite:draw()
end