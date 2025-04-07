love.filesystem.load("src/Modules/System/Run.lua")()
--love.filesystem.load("src/Modules/System/ErrorHandler.lua")()


function love.initialize()
    Discord = require 'src.Modules.Game.API.Discord'

    love.resconf = {
        replace = { "mouse" },
        width = 1280,
        height = 768,
        aspectRatio = true,
        centered = true,
        clampMouse = true,
        clip = false,
    }

    resolution.init(love.resconf)

    -- save system --
    gameslot = neuron.new("game")
    gameslot.save.game = {
        user = {
            settings = {
                language = "English",
                gamejolt = {
                    username = "",
                    usertoken = ""
                },
                fullscreen = false,
                displayFPS = true,
                discordRichPresence = true,
            }
        }
    }
    gameslot:initialize()

    love.graphics.getWidth = function() return love.resconf.width end
    love.graphics.getHeight = function() return love.resconf.height end

    -- api stuff --
    require('src.Modules.Game.API.Gamejolt')()
    require('src.Modules.Game.API.GitDebug')()
    if gameslot.save.game.user.settings.discordRichPresence then
        Discord.init()
    end

    -- language association --
    languageService = LanguageController:getData(gameslot.save.game.user.settings.language)
    languageRaw = LanguageController:getRawData(gameslot.save.game.user.settings.language)

    registers = {
        -- register some values that may change during gameplay --
    }

    
    th_ping = love.thread.newThread("src/Modules/Game/API/GamejoltPingThread.lua")

    tmr_gamejoltHeartbeat = timer.new()
    tmr_gamejoltHeartbeat:every(20, function()
        th_ping:start(
            gameslot.save.game.user.settings.gamejolt.username, 
            gameslot.save.game.user.settings.gamejolt.usertoken
        )
    end)

    -- load states --
    local states = love.filesystem.getDirectoryItems("src/Scenes")
    for s = 1, #states, 1 do
        require("src.Scenes." .. states[s]:gsub(".lua", ""))
    end

    --[[gamestate.registerEvents({
        "predraw",
        "update",
        "mousepressed",
        "mousereleased",
        "wheelmoved",
        "mousemoved",
        "keyreleased",
        "keypressed",
        "textinput",
        "gamepadpressed",
        "gamepadreleased",
        "gamepadaxis",
        "joystickadded",
        "joystickremoved",
        "resize"
    })]]--
    gamestate.registerEvents()
    gamestate.switch(PlayState)
end

function love.update(elapsed)
    if gamejolt.isLoggedIn then
        tmr_gamejoltHeartbeat:update(elapsed)
    end
end

function love.keypressed(k)
    if k == "f10" then
        -- Changes are updated dynamically
        FEATURE_FLAGS.videoStats = not FEATURE_FLAGS.videoStats
    end
end