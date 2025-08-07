-- WARNING! THIS CLASS REQUIRES LOVE2D AND FLUX
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
    sprite.hitbox = {width = sprite.width /2, height = sprite.height /2}
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


-- simple AABB collision
function Sprite:HasCollided(sprite)
    local xInRange = self.location.x < sprite.location.x + sprite.hitbox.width
    local yInRange = self.location.y < sprite.location.y + sprite.hitbox.height
    local spriteXinRange = sprite.location.x < self.location.x + self.hitbox.width
    local spriteYinRange = sprite.location.y < self.location.y + self.hitbox.height
    return xInRange and yInRange and spriteXinRange and spriteYinRange
end

function Sprite:TweenToOrigin(dt)
    if not Utility.PosAreEqual(self.location, self.origin) then
        if not self.isTweening then
            flux.to(self.location, 0.2, self.origin):ease("linear"):delay(0.1)
            self.isTweening = true
        end
        flux.update(dt)
    else
        self.isTweening = false
    end
end

function Sprite:SwapOrigin(sprite)
    local newOrigin = {x=sprite.origin.x, y=sprite.origin.y}
    sprite.origin = self.origin
    self.origin = newOrigin
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