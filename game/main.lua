local Sprite = require ("Sprite")

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
    if clickedSprite ~= nil then
        clickedSprite:setDrag({x=x,y=y})
    end
end

function AddXCards(list,x, startAtX, startAtY, endAtX, key)
    local range = endAtX - startAtX
    local posPerCard = (range/x) + 15
    for i = 0, x do
        local xPos = startAtX + (posPerCard * i)
        local s = Sprite:new({x=xPos,y=startAtY}, key)
        table.insert(list, s)
    end
end

function love.load()
    AddXCards(sprite_list, 5, 100, 300, 400, "sprite.png")
end

function GetDraggedSprite(list)
    for i,s in ipairs(list) do
        if s.isDragging then
            return s
        end
    end
    return nil
end



function HandleCollision(l, dt)
    local draggedSprite = GetDraggedSprite(l)
    if draggedSprite then
        for i,s in ipairs(sprite_list) do
            if s ~= draggedSprite then
                if s:HasCollided(draggedSprite) then
                    s:SwapOrigin(draggedSprite, s)
                    s:TweenToOrigin(dt)
                end
            end
        end
    end
end

function love.update(dt)
    for i,s in ipairs(sprite_list) do
        s:updatePos(dt)
    end
    StopDrag()
    HandleCollision(sprite_list, dt)
end

function love.draw()
    --love.graphics.scale( 0.25, 0.25 )
    for i,s in ipairs(sprite_list) do
        s:draw()
    end
end