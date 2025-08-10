-- WARNING! THIS CLASS REQUIRES LOVE2D AND FLUX
local Utility = require("utility")
local flux = require("3RD-PARTY/flux/flux")

--meta -class
local Sprite = {}

-- Sprite class constructor
function Sprite:new (position, key, prop)
    local sprite = {}
    sprite.prop = prop -- TBD
    sprite.select = false
    sprite.enableCollision = true
    sprite.enableCollisionAtOrigin = false
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
    sprite.hitbox = {width = sprite.width /2, height = sprite.height * 4}
    self.__index = self
    return setmetatable(sprite, self)
end

function Sprite:StopTween()
    if self.tween then
        self.tween:stop()
    end
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
    if self.enableCollision and sprite.enableCollision and not self.select then
        local xInRange = self.location.x < sprite.location.x + sprite.hitbox.width
        local yInRange = self.location.y < sprite.location.y + sprite.hitbox.height
        local spriteXinRange = sprite.location.x < self.location.x + self.hitbox.width
        local spriteYinRange = sprite.location.y < self.location.y + self.hitbox.height
        return xInRange and yInRange and spriteXinRange and spriteYinRange
    end
    return false
end

function Sprite:TweenToOrigin(dt)
    if not Utility.PosAreEqual(self.location, self.origin) then
        if not self.isTweening then
            self.tween = flux.to(self.location, 0.2, self.origin):ease("linear")
            self.isTweening = true
        end
        flux.update(dt)
    else
        self.isTweening = false
    end
end

function Sprite:SwapOrigin(sprite)
    local newOrigin = {x=sprite.origin.x, y=sprite.origin.y}
    sprite.origin = {x=self.origin.x,y=self.origin.y}
    self.origin = newOrigin
    self:StopTween()
    sprite:StopTween()
end


function Sprite:DisableCollisionUntilOrigin()
    self.enableCollision = false
    self.enableCollisionAtOrigin = true
end


function Sprite:EnableCollison()
    if self.enableCollisionAtOrigin and Utility.PosAreEqual(self.location, self.origin) then
        self.enableCollision = true
        self.enableCollisionAtOrigin = false
    end
end

function Sprite:Select()
    self.select = true
end

function Sprite:Play(pos)
    if self.select then
        self.origin = {x=pos.x, y=pos.y}
        return self.prop
    end
end

function Sprite:updatePos(dt)
    self:EnableCollison()
    if self.isDragging then
        self.isTweening = false
        self.location.x = love.mouse.getX() - self.offset.x
        self.location.y = love.mouse.getY() - self.offset.y
    else
        self:TweenToOrigin(dt)
    end
end


function Sprite:resetDrag() self.isDragging = false end
function Sprite:draw()
    if self.isDragging then
        love.graphics.draw(self.image, self.location.x ,self.location.y, 0, 1.5, 1.5)
    else
        love.graphics.draw(self.image, self.location.x ,self.location.y)
    end
end

return Sprite