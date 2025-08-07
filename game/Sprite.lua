-- WARNING! THIS CLASS REQUIRES LOVE2D
local Utility = require("utility")
local flux = require("3RD-PARTY/flux/flux")

--meta -class
local Sprite = {}

-- Sprite class constructor
function Sprite:new (position, key)
    local sprite = {}
    sprite.isDragging = false
    sprite.isTweening = false
    sprite.tween = nil
    sprite.offset = {}
    sprite.location = {}
    sprite.origin = {}
    sprite.location.x = position.x
    sprite.location.y = position.y
    sprite.origin.x = position.x
    sprite.origin.y = position.y
    sprite.image = love.graphics.newImage(key)
    sprite.width = sprite.image:getWidth()
    sprite.height = sprite.image:getHeight()
    self.__index = self
    return setmetatable(sprite, self)
end


function Sprite:posOverlap(pos)
    local endX = self.location.x + self.width
    local endY = self.location.y + self.height
    local withinY = Utility.InRange(self.location.y, endY, pos.y)
    local withinX = Utility.InRange(self.location.x, endX, pos.x)
    return withinX and withinY
end


function Sprite:setDrag(pos)
    self.isDragging = true
    self.offset.x = pos.x - self.location.x
    self.offset.y = pos.y - self.location.y
end

function Sprite:TweenToOrigin(dt)
    if not Utility.PosAreEqual(self.location, self.origin) then
        if not self.isTweening then
            flux.to(self.location, 0.25, self.origin):ease("linear"):delay(0.3)
            self.isTweening = true
        end
        flux.update(dt)
    else
        self.isTweening = false
    end
end

function Sprite:updatePos(dt)
    if self.isDragging then
        self.isTweening = false
        self.location.x = love.mouse.getX() - self.offset.x
        self.location.y = love.mouse.getY() - self.offset.y
    else
        self:TweenToOrigin(dt)
    end
end

function Sprite:resetDrag() self.isDragging = false end
function Sprite:draw() love.graphics.draw(self.image, self.location.x ,self.location.y) end

return Sprite