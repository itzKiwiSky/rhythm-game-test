return function(width, height, points)
    width = width or 48
    height = height or 48
    points = points or {
        0, 0,
        64, 0,
        64, 64,
        0, 64,
    }

    local canvas = love.graphics.newCanvas(width, height)
    local oldCanvas = love.graphics.getCanvas()
    --local mesh = love.graphics.newMesh(points, "fan")

    love.graphics.setCanvas(canvas)
        --love.graphics.draw(mesh)
        love.graphics.polygon("fill", points)
    love.graphics.setCanvas(oldCanvas)

    return love.graphics.newImage(canvas:newImageData())
end