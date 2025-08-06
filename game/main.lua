

local sprite = {}
local offset = {}
local isDraggingSprite = false

function WithinRange(low,high,value)
    return value > low and value < high
end

function MouseOverlapWithSprite(mousePos)
    local endX = sprite.location.x + sprite.width
    local endY = sprite.location.y + sprite.height
    return
        WithinRange(sprite.location.x, endX, mousePos.x)
        and WithinRange(sprite.location.y, endY, mousePos.y)
end


function love.mousepressed(x, y, button)
    if button == 1 and MouseOverlapWithSprite({x=x,y=y}) then
        isDraggingSprite = true
        offset.x = x - sprite.location.x
        offset.y = y - sprite.location.y
    else
        isDraggingSprite = false
    end
end

function UpdateSpritePos()
    if isDraggingSprite then
        sprite.location.x = love.mouse.getX() - offset.x
        sprite.location.y = love.mouse.getY() - offset.y
    end
end

function love.load()
    sprite.image = love.graphics.newImage("sprite.png")
    sprite.width = sprite.image:getWidth()
    sprite.height = sprite.image:getHeight()
    sprite.location = {x=300, y=300}
end

function love.update(dt)
    UpdateSpritePos()
end

function love.draw()
    --love.graphics.scale( 0.25, 0.25 )
    love.graphics.draw(sprite.image, sprite.location.x ,sprite.location.y)
end