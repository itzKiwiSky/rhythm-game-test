local ViewManager = {}
ViewManager.views = {}

ViewManager.currentActiveView = ""

function ViewManager.clear()
    loveframes.RemoveAll()
end

function ViewManager.load(path)
    loveframes.RemoveAll()
    --local f = require(path:gsub(".lua", ""))()

    local fileinfo = love.filesystem.getInfo(path)
    
    if fileinfo ~= nil then
        local viewstruct = {}

        local viewfile = love.filesystem.load(path)

        viewstruct.path = path
        viewstruct.lastmod = fileinfo.modtime

        local sucess, err = pcall(viewfile(ViewManager.useSettings))
        if not sucess then
            print(err)
        else
            table.insert(ViewManager.views, #ViewManager.views + 1, viewstruct)
        end
    else
        print("File not found, ignoring it")
    end
end

function ViewManager.reloadViews()
    for _, view in ipairs(ViewManager.views) do
        local fileinfo = love.filesystem.getInfo(view.path)
        if fileinfo.modtime > view.lastmod then
            loveframes.RemoveAll()
            ViewManager.views[_].lastmod = fileinfo.modtime

            local chunk = love.filesystem.load(view.path)

            local sucess, err = pcall(chunk(ViewManager.useSettings))
            if err then
                print(err)
            else
                print("[VIEW] : Updated view")
            end
        end
    end
end

function ViewManager.draw()
    local sucess, err = pcall(loveframes.draw)
    if err then
        print(err)
    end
end

function ViewManager.update(elapsed)
    local sucess, err = pcall(loveframes.update, elapsed)
    if err then
        print(err)
    end
end

function ViewManager.mousepressed(x, y, button)
    local sucess, err = pcall(loveframes.mousepressed, x, y, button)
    if err then
        print(err)
    end
end

function ViewManager.mousereleased(x, y, button)
    local sucess, err = pcall(loveframes.mousereleased, x, y, button)
    if err then
        print(err)
    end
end

function ViewManager.keypressed(k, scancode, isrepeat)
    local sucess, err = pcall(loveframes.keypressed, k, isrepeat)
    if err then
        print(err)
    end
end

function ViewManager.keyreleased(k)
    local sucess, err = pcall(loveframes.keyreleased, k)
    if err then
        print(err)
    end
end

function ViewManager.textinput(t)
    local sucess, err = pcall(loveframes.textinput, t)
    if err then
        print(err)
    end
end



return ViewManager