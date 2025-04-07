local Shape = require 'game.src.Modules.Game.Shape'
local Player = {}

function Player:load(x, y)
    self.x, self.y = x or 0, y or 0
    self.sprite = Shape()
end

function Player:draw()
    love.graphics.draw(self.sprite.mesh, self.x, self.y, 0, 64, 64)
end

function Player:update(elapsed)
    
end

return Player