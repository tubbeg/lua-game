local Sprite = require ("Sprite")

local sprite_list = {}
local draggedSprite = nil -- so that I don't need a search function

function StopDrag()
    if not love.mouse.isDown(1) then
        for i,s in ipairs(sprite_list) do
            draggedSprite = nil
            s:resetDrag()
            s:ResetZindex()
        end
    end
end

-- returns nil if no sprite was left-clicked
-- otherwise returns the sprite 
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
    if clickedSprite then
        draggedSprite = clickedSprite
        clickedSprite:SetZindex(0)
        clickedSprite:setDrag({x=x,y=y})
    end
end

function AddXCards(list,x, startAtX, startAtY, endAtX, key)
    local range = endAtX - startAtX
    local posPerCard = (range/x) + 15
    for i = 0, x do
        local xPos = startAtX + (posPerCard * i)
        local s = Sprite:new({x=xPos,y=startAtY}, key,i + 10, {suit="spades", rank=1})
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

function HandleCollision()
    if draggedSprite then
        for i,s in ipairs(sprite_list) do
            if s ~= draggedSprite then
                if s:HasCollided(draggedSprite) then
                    s:SwapOrigin(draggedSprite)
                    s:DisableCollisionUntilOrigin()
                    SortByZindex()
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
    HandleCollision()
end

function CompareByZIndex (a,b)
    return a.z > b.z
end

-- TODO, make sure that each sprite swaps z-origins
function SortByZindex()
    if draggedSprite then
        table.sort(sprite_list, CompareByZIndex)
    end
end

function love.draw()
    --love.graphics.scale( 0.25, 0.25 )
    for i,s in ipairs(sprite_list) do
        s:draw()
    end
end