local Utility = require("utility")
local flux = require("3RD-PARTY/flux/flux")
local peachy = require("peachy")

--meta -class
local Sprite = {}

local tempPath = "assets/aseprite/"
local selectedPath =
    {
        config=tempPath .. "selected-card.json",
        image=tempPath .. "selected-card.png"
    }


-- Sprite class constructor
function Sprite:new (key, position)
    local sprite = {}
    sprite.key = key
    sprite.image = {}
    sprite.position = {x=position.x, y=position.y}
    self.__index = self
    return setmetatable(sprite, self)
end

function Sprite:moveTo(nextPosition)
    flux.to(self.position, 1, nextPosition)
end

function Sprite:load()
    if self.key then
        local selectImage = love.graphics.newImage(selectedPath.image)
        self.image.card = love.graphics.newImage(self.key)
        self.image.select = peachy.new(selectedPath.config, selectImage, "sel")
        return self
    end
    return self
end

function Sprite:update(dt)
    if self.image.select then
        self.image.select:update(dt)
    end
end

function Sprite:drawAsSelected()
    if self.image.card and self.image.select then
        love.graphics.draw(self.image.card, self.position.x ,self.position.y, 0, 1.3,1.3)
        self.image.select:draw(self.position.x, self.position.y, 0, 1.3,1.3)
    end
    
end

function Sprite:draw()
    love.graphics.draw(self.image.card, self.position.x ,self.position.y, 0, 1.3, 1.3)
end

return Sprite