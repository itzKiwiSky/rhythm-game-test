local Shape = require 'game.src.Modules.Game.Shape'
local Vec2 = require 'game.src.Modules.Game.Vec2'
local Player = {}

local Direction = Vec2(0, 0)
function Player:load(x, y)
    self.pos = Vec2(x, y)
    self.sprite = Shape(48, 48)
    self.angle = 0
    self.trail = {}
    self.speed = 400
    self.dashSpace = 3.5
    self.canDash = true
    self.dashResetTimer = 2.5
    self.dashTimer = self.dashResetTimer
    self.trailTimer = 0
    self.scale = 1
end

function Player:draw()
    love.graphics.draw(self.sprite, self.pos.x, self.pos.y, math.rad(self.angle), 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)

    for _, t in ipairs(self.trail) do
        love.graphics.setColor(1, 1, 1, t.alpha)
        love.graphics.draw(self.sprite, t.x, t.y, math.rad(t.a), t.scale, t.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end 

function Player:update(elapsed)
    if love.keyboard.isDown("d", "right") then
        Direction.x = Direction.x + 1
    end
    if love.keyboard.isDown("a", "left") then
        Direction.x = Direction.x - 1
    end
    if love.keyboard.isDown("s", "down") then
        Direction.y = Direction.y + 1
    end
    if love.keyboard.isDown("w", "up") then
        Direction.y = Direction.y - 1
    end

    if Direction:isZero() then
        Direction = Direction:normalize()
    end

    self.pos.x = self.pos.x + Direction.x * self.speed * elapsed
    self.pos.y = self.pos.y + Direction.y * self.speed * elapsed

    Direction = Vec2.ZERO()

    --self.angle = math.lerp(self.angle, Direction:angleTo(self.pos), 0.25)

    -- trail --
    if not Direction:isZero() then
        table.push(self.trail, {
            x = self.pos.x,
            y = self.pos.y,
            a = self.angle,
            alpha = 0.7,
            scale = 0.65,
        })
    end
    for _, t in ipairs(self.trail) do
        t.alpha = t.alpha - elapsed * 3.7
        t.scale = t.scale - elapsed * 2.5
        if t.alpha <= 0 or t.scale <= 0 then
            table.remove(self.trail, _)
        end
    end
end

return Player