local https = require 'https'

return function()
    local cfgfile = love.filesystem.getInfo("src/ApiConfig.json")

    if cfgfile then
        local data = json.decode(love.filesystem.read("src/ApiConfig.json"))
        if data.gamejolt.gameID~= nil and data.gamejolt.gameKey ~= nil then
            gamejolt.init(data.gamejolt.gameID, data.gamejolt.gameKey)
            if gameslot.save.game.user.settings.gamejolt.username ~= "" and gameslot.save.game.user.settings.gamejolt.usertoken ~= "" then
                gamejolt.authUser(
                    gameslot.save.game.user.settings.gamejolt.username,
                    gameslot.save.game.user.settings.gamejolt.usertoken
                )
                gamejolt.openSession()
                io.printf(string.format("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Client connected (%s, %s){reset}\n", gamejolt.username, gamejolt.userToken))
            end
        else
            io.printf("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Failed to initialize to gamejolt, config with invalid parameter length{reset}\n")
        end
    else
        io.printf("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Failed to initialize to gamejolt, cannot find config file{reset}\n")
    end
end