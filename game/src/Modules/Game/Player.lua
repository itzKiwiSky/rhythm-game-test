local Shape = require 'game.src.Modules.Game.Shape'
local Vec2 = require 'game.src.Modules.Game.Vec2'
local Player = {}

local Direction = Vec2(0, 0)
function Player:load(x, y)
    self.pos = Vec2(x, y)
    self.sprite = Shape(32, 32)
    self.angle = 0
    self.trail = {}
    self.speed = 400
    self.dashDirection = 1
    self.canDash = true
    self.dashResetTimer = 2.5
    self.dashTimer = self.dashResetTimer
    self.trailTimer = 0
    self.scale = 1

    self.fx = {}
end

function Player:draw()
    for _, f in ipairs(self.fx) do
        love.graphics.setColor(1, 1, 1, f.alpha)
            love.graphics.setLineWidth(f.lw)
                love.graphics.circle("line", f.x, f.y, f.r)
            love.graphics.setLineWidth(1)
        love.graphics.setColor(1, 1, 1, 1)
    end

    for _, t in ipairs(self.trail) do
        love.graphics.setColor(1, 1, 1, t.alpha)
            love.graphics.draw(self.sprite, t.x, t.y, math.rad(t.a), t.scale, t.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(self.sprite, self.pos.x, self.pos.y, self.angle, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end 

function Player:update(elapsed)
    if love.keyboard.isDown("d", "right") then
        Direction.x = Direction.x + self.dashDirection
    end
    if love.keyboard.isDown("a", "left") then
        Direction.x = Direction.x - self.dashDirection
    end
    if love.keyboard.isDown("s", "down") then
        Direction.y = Direction.y + self.dashDirection
    end
    if love.keyboard.isDown("w", "up") then
        Direction.y = Direction.y - self.dashDirection
    end

    if Direction:isZero() then
        Direction = Direction:normalize()
    end


    self.angle = math.lerp(self.angle, math.atan2(Direction.y, Direction.x), 0.065)

    self.pos.x = self.pos.x + Direction.x * self.speed * elapsed
    self.pos.y = self.pos.y + Direction.y * self.speed * elapsed

    Direction = Vec2.ZERO()

    -- dash --
    if not self.canDash then
        self.dashDirection = 1
        self.dashTimer = self.dashTimer - elapsed
        if self.dashTimer <= 0 then
            self.canDash = true
            self.dashTimer = self.dashResetTimer
        end
    end

    -- circle effect --
    for _, f in ipairs(self.fx) do
        f.r = f.r + 20 * elapsed
        f.alpha = f.alpha - 1 * elapsed
        f.lw = f.lw - 6 * elapsed
        if f.alpha <= 0 then
            table.remove(self.fx, _)
        end
    end

    -- trail --
    self.trailTimer = self.trailTimer + elapsed
    if self.trailTimer >= 0.05 then
        table.push(self.trail, {
            x = self.pos.x,
            y = self.pos.y,
            a = self.angle,
            alpha = 0.7,
            scale = 0.65,
        })
        self.trailTimer = 0
    end
    for _, t in ipairs(self.trail) do
        t.alpha = t.alpha - elapsed * 0.7
        t.scale = t.scale - elapsed * 0.5
        if t.alpha <= 0 or t.scale <= 0 then
            table.remove(self.trail, _)
        end
    end
end

function Player:keypressed(k)
    if k == "space" and self.canDash then
        table.push(self.fx, {
            x = self.pos.x,
            y = self.pos.y,
            alpha = 1,
            r = 32,
            lw = 6,
        })
        self.dashDirection = 32 * 5
        self.canDash = false
        self.dashTimer = self.dashResetTimer
    end
end

return Player