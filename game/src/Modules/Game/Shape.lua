local Shape = class:extend("Shape")

function Shape:__construct(points)
    points = points or {
        {
            0, 0,
            0, 0,
            1, 1, 1,
        },
        {
            1, 0,
            0, 0,
            1, 1, 1,
        },
        {
            1, 1,
            0, 0,
            1, 1, 1,
        },
        {
            0, 1,
            0, 0,
            1, 1, 1,
        },
    }
    self.mesh = love.graphics.newMesh(points, "fan")
end

return Shape