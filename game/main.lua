
local tween = require ("3RD-PARTY/tween/tween")

local sprite = {}
local offset = {}
local isDraggingSprite = false


local label = { x=200, y=0, text = "hello there", r=nil }
local tweenCard = {} 


function PosAreEqual(pos1,pos2) return pos1.y == pos2.y and pos1.x == pos2.x end
function InRange(startRange,endRange,value) return value > startRange and value < endRange end

function MouseOverlapWithSprite(mousePos)
    local endX = sprite.location.x + sprite.width
    local endY = sprite.location.y + sprite.height
    local withinY = InRange(sprite.location.y, endY, mousePos.y)
    local withinX = InRange(sprite.location.x, endX, mousePos.x)
    return withinX and withinY
end

function ResetDrag()
    if not love.mouse.isDown(1) then
        isDraggingSprite = false
    end
end

function IsLeftClickOnSprite(x,y,button)
    return button == 1 and MouseOverlapWithSprite({x=x,y=y})
end

function love.mousepressed(x, y, button)
    isDraggingSprite = false
    if IsLeftClickOnSprite(x,y,button) then
        isDraggingSprite = true
        offset.x = x - sprite.location.x
        offset.y = y - sprite.location.y
    end
end

function UpdateSpritePos(dt)
    if isDraggingSprite then
        sprite.tweening = false
        sprite.location.x = love.mouse.getX() - offset.x
        sprite.location.y = love.mouse.getY() - offset.y
    else
        if not PosAreEqual(sprite.location, sprite.origin) then
            if not sprite.tweening then
                tweenCard = tween.new(1, sprite.location, sprite.origin)
                sprite.tweening = true
            end
            tweenCard:update(dt)
        else
            sprite.tweening = false
        end
    end
end

function love.load()
    local pos = {x=300, y=300}
    sprite.image = love.graphics.newImage("sprite.png")
    sprite.width = sprite.image:getWidth()
    sprite.height = sprite.image:getHeight()
    sprite.location = pos
    sprite.origin = {x=pos.x, y=pos.y}
    sprite.tweening = false
    local font = love.graphics.newFont(14)
    label.r = love.graphics.newText(font, label.text)
end


function love.update(dt)
    UpdateSpritePos(dt)
    ResetDrag()
end

function love.draw()
    --love.graphics.scale( 0.25, 0.25 )
    love.graphics.draw(label.r, label.x, label.y)
    love.graphics.draw(sprite.image, sprite.location.x ,sprite.location.y)
end