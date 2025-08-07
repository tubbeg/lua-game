
local tween = require ("3RD-PARTY/tween/tween")
local Sprite = require ("Sprite")
local Utility = require ("utility")

local sprite_list = {}

function StopDrag()
    if not love.mouse.isDown(1) then
        for i,s in ipairs(sprite_list) do
            s:resetDrag()   
        end
    end
end


-- returns nil if no sprite was clicked
-- returns the sprite the was left-clicked if true
function IsLeftClickOnSprite(x,y,button)
    if button == 1 then
        for i,s in ipairs(sprite_list) do
            if s:posOverlap({x=x,y=y}) then
                return s
            end
        end
    end
    return nil
end

function love.mousepressed(x, y, button)
    for i,s in ipairs(sprite_list) do
        s:resetDrag()
    end
    local clickedSprite = IsLeftClickOnSprite(x,y,button) 
    if clickedSprite then clickedSprite:setDrag({x=x,y=y}) end
end

function love.load()
    sprite_list[1] = Sprite:new({x=300,y=300}, "sprite.png")
    sprite_list[2] = Sprite:new({x=500,y=300}, "sprite.png")
end


function love.update(dt)
    for i,s in ipairs(sprite_list) do
        s:updatePos(dt)
    end
    StopDrag()
end

function love.draw()
    --love.graphics.scale( 0.25, 0.25 )
    for i,s in ipairs(sprite_list) do
        s:draw()
    end
end