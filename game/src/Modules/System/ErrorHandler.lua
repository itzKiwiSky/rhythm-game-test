function love.errorhandler(msg)
    local utf8 = require 'utf8'
    local nfs = require 'libraries.nativefs'
    local fontcache = require 'src.Components.Modules.System.FontCache'
    local resolution = require 'trtf.libraries.resolution'

    love.resconf = {
        replace = {"mouse"},
        width = 1280,
        height = 800,
        aspectRatio = true,
        centered = true,
        clampMouse = true,
        clip = false,
    }

    resolution.init(love.resconf)

    local function error_printer(msg, layer)
        print((debug.traceback("[Error]: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
    end

    if love.window then
        love.window.setTitle("[RuntimeError] " .. love.window.getTitle())
    end

    local addons = love.filesystem.getDirectoryItems("src/Addons")
    for a = 1, #addons, 1 do
        require("src.Addons." .. addons[a]:gsub(".lua", ""))
    end

    msg = tostring(msg)

    error_printer(msg, 2)

    -- assets --
    if not love.window or not love.graphics or not love.event then
        return
    end

    if not love.graphics.isCreated() or not love.window.isOpen() then
        local success, status = pcall(love.window.setMode, 800, 600)
        if not success or not status then
            return
        end
    end

    -- Reset state.
    if love.mouse then
        love.mouse.setVisible(true)
        love.mouse.setGrabbed(false)
        love.mouse.setRelativeMode(false)
        if love.mouse.isCursorSupported() then
            love.mouse.setCursor()
        end
    end
    if love.joystick then
        -- Stop all joystick vibrations.
        for i,v in ipairs(love.joystick.getJoysticks()) do
            v:setVibration()
        end
    end
    if love.audio then love.audio.stop() end

    love.graphics.reset()
    local font = love.graphics.setNewFont(14)

    love.graphics.setColor(1, 1, 1)

    local trace = debug.traceback()

    love.graphics.origin()

    local sanitizedmsg = {}
    for char in msg:gmatch(utf8.charpattern) do
        table.insert(sanitizedmsg, char)
    end
    sanitizedmsg = table.concat(sanitizedmsg)

    local err = {}

    table.insert(err, "[Error]\n")
    table.insert(err, sanitizedmsg)

    if #sanitizedmsg ~= #msg then
        table.insert(err, "Invalid UTF-8 string in error message.")
    end

    table.insert(err, "\n")

    for l in trace:gmatch("(.-)\n") do
        if not l:match("boot.lua") then
            l = l:gsub("stack traceback:", "Traceback\n")
            table.insert(err, l)
        end
    end

    local p = table.concat(err, "\n")

    p = p:gsub("\t", "")
    p = p:gsub("%[string \"(.-)\"%]", "%1")

    -- generate log file --
    local pt = love.filesystem.isFused() and love.filesystem.getSourceBaseDirectory() or love.filesystem.getSaveDirectory()
    pt = pt:gsub("\\", "/") .. "/crashes"
    if love.filesystem.isFused() then
        nfs.createDirectory(pt)
    else
        love.filesystem.createDirectory("crashes")
    end

    local fdcrash = pt .. "/session_" .. tostring(os.date("%Y_%m_%d%H.%M.%S"))

    nfs.createDirectory(fdcrash)

    local err, f = nfs.write(string.format("%s/traceback.txt", fdcrash), tostring(p))
    if DEBUG_APP then
        local err, f = nfs.write(string.format("%s/outputlog.txt", fdcrash), tostring(table.concat(_G.GLOBAL_BUFFER, "")))
    end
    local dskWidth, dskHeight = love.window.getDesktopDimensions(1)
    local winW, winH = love.graphics.getDimensions()
    local stats = love.graphics.getStats()
    local s, p, sc = love.system.getPowerInfo()
    local err, f = nfs.write(string.format("%s/system.txt", fdcrash), tostring(table.concat({
        "Operating system: " .. love.system.getOS(),
        "Processor Count: " .. love.system.getProcessorCount(),
        ("Power: {\n    State: %s\n    Percent: %s\n    Seconds: %s\n}"):format(s, p, sc),
        ("Graphics: {\n    Renderer: %s\n    Version: %s\n    Vendor: %s\n    Device: %s}"):format(love.graphics.getRendererInfo()),
        ("Display: {\n    DisplaySize: %sx%s\n    DesktopSize:%sx%s}"):format(winW, winH, dskWidth, dskHeight),
        ("Total Memory Usage: %smb"):format(stats.texturememory / 1024 / 1024)
    }, "\n")))

    local sc = love.graphics.newImage("assets/images/system/Screen.png")
    local staticfx = {
        config = {
            timer = 0,
            frameid = 1,
            speed = 0.05
        },
        frames = {}
    }

    local disp = false

    local statics = love.filesystem.getDirectoryItems("assets/images/game/effects/static")
    for s = 1, #statics, 1 do
        table.insert(staticfx.frames, love.graphics.newImage("assets/images/game/effects/static/" .. statics[s]))
    end

    local fnt_title = fontcache.getFont("tnr", 60)
    local fnt_error = fontcache.getFont("tnr", 30)
    local fnt_errdisp = fontcache.getFont("ocrx", 18)

    local function draw()
        if not love.graphics.isActive() then return end
        local pos = 200
        love.graphics.clear(0, 0, 0, 0)
        
    
        love.graphics.draw(sc, 0, 0, 0, 
            love.graphics.getWidth() / staticfx.frames[staticfx.config.frameid]:getWidth(),
            love.graphics.getHeight() / staticfx.frames[staticfx.config.frameid]:getHeight()
        )
        love.graphics.setBlendMode("add")
            love.graphics.setColor(1, 1, 1, 0.2)
                love.graphics.draw(staticfx.frames[staticfx.config.frameid], 0, 0, 0, love.graphics.getWidth() / sc:getWidth(), love.graphics.getHeight() / sc:getHeight())
            love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setBlendMode("alpha")

        local txt = "Oh no! apparently frankburt has died due an game error\nAn error log has been saved on the game folder.\nPlease contact the developers and send the \"crashlog.txt\" file to them\n\n\nThe game will be terminated, press [ESC] to close or press [F1] to see the error."

        love.graphics.printf("-[ERROR]-", fnt_title, 0, 100, love.graphics.getWidth(), "center")
        love.graphics.printf(txt, fnt_error, 0, 250, love.graphics.getWidth(), "center")

        if disp then
            love.graphics.printf(p, fnt_errdisp, 80, 500, love.graphics.getWidth() - 80)
        end

        love.graphics.present()
    end

    return function()
        love.event.pump()

        for e, a, b, c in love.event.poll() do
            if e == "quit" then
                return 1
            elseif e == "keypressed" and a == "escape" then
                return 1
            elseif e == "keypressed" and a == "f1" then
                disp = not disp
            end
        end

        local elapsed = love.timer.step()

        staticfx.config.timer = staticfx.config.timer + elapsed
        if staticfx.config.timer >= staticfx.config.speed then
            staticfx.config.timer = 0
            staticfx.config.frameid = staticfx.config.frameid + 1
            if staticfx.config.frameid >= #staticfx.frames then
                staticfx.config.frameid = 1
            end
        end

        resolution.start()
        draw()
        resolution.stop()

        if love.timer then
            love.timer.sleep(0.01)
        end
    end
end