local Utility = require("utility")
local flux = require("3RD-PARTY/flux/flux")
local peachy = require("peachy")

--meta -class
local Sprite = {}

local tempPath = "assets/aseprite/"



-- Sprite class constructor
function Sprite:new (key, position)
    local sprite = {}
    sprite.key = key
    sprite.image = nil
    sprite.selImage = peachy.new(tempPath .. "selected-card.json", love.graphics.newImage(tempPath .. "selected-card.png"), "sel")
    sprite.position = {current=position, next=nil, isTween=false}
    self.__index = self
    return setmetatable(sprite, self)
end

function Sprite:moveTo(nextPosition)
    flux.to(self.position.current, 1, nextPosition)
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
end

function Sprite:drawAsSelected()
    love.graphics.draw(self.image, self.position.current.x ,self.position.current.y, 0, 1.3,1.3)
    self.selImage:draw(self.position.current.x, self.position.current.y, 0, 1.3,1.3)
    
end


function Sprite:draw(selectedSprite)
    love.graphics.draw(self.image, self.position.current.x ,self.position.current.y, 0, 1.3, 1.3)
end

return Sprite