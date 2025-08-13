local Utility = require("utility")
local flux = require("3RD-PARTY/flux/flux")
local peachy = require("peachy")

--meta -class
local Sprite = {}

local tempPath = "assets/aseprite/"



-- Sprite class constructor
function Sprite:new (key, position)
    local sprite = {}
    local p = {current=position, next=nil, isTween=false}
    sprite.key = key
    sprite.image = nil
    sprite.selImage = peachy.new(tempPath .. "selected-card.json", love.graphics.newImage(tempPath .. "selected-card.png"), "sel")
    sprite.position = p
    sprite.isPlayed = false
    self.__index = self
    return setmetatable(sprite, self)
end

function Sprite:moveTo(nextPosition)
    self.position.next = nextPosition
end

function Sprite:play(nextPosition)
    self.isPlayed = true
    self:moveTo(nextPosition)
end

function Sprite:tweenToPosition(dt)
    if self.position.next then
        if not Utility.PosAreEqual(self.position.current, self.position.next) then
            if not self.position.isTween then
                flux.to(self.position.current, 0.2, self.position.next):ease("linear")
                self.position.isTween = true
            end
            flux.update(dt)
        else
            self.position.isTween = false
            --self.position.next = nil
        end
    end
end

function Sprite:load()
    if self.key then
        self.image = love.graphics.newImage(self.key)
        return self
    end
    return self
end

function Sprite:update(dt)
    self.selImage:update(dt)
    self:tweenToPosition(dt)
end

function Sprite:draw(selectedSprite)
    if self == selectedSprite and not self.isPlayed then
        local width,height = self.image:getDimensions()
        local x,y = self.position.current.x, self.position.current.y
        --love.graphics.setColor( 0, 200, 255)
        --love.graphics.rectangle( "fill", x - 2, y - 2, width + 4, height + 4, 0.1, 0.1, 5)
        --love.graphics.setColor( 255, 255, 255)
        love.graphics.draw(self.image, self.position.current.x ,self.position.current.y, 0, 1.3,1.3)
        self.selImage:draw(self.position.current.x, self.position.current.y, 0, 1.3,1.3)
        
    else
        love.graphics.draw(self.image, self.position.current.x ,self.position.current.y, 0, 1.3, 1.3)
    end
end

return Sprite