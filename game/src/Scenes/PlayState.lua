PlayState = {}

function PlayState:enter()
    self.player = require 'game.src.Modules.Game.Player'
    self.player:load(90, 90)

    self.camera = camera.new()
    self.camera.targetZoom = 1

end

function PlayState:draw()
    self.camera:attach()
        self.player:draw()
    self.camera:detach()
end

function PlayState:update(elapsed)
    self.camera:zoomTo(math.lerp(self.camera.scale, self.camera.targetZoom, 0.1))
end

function PlayState:keypressed(k)

end

return PlayState