local Discord = {}
Discord.presence = {
    state = "Looking to Play",
    details = "1v1 (Ranked)",
}

function Discord.init()
    local cfgfile = love.filesystem.getInfo("src/ApiConfig.json")

    if cfgfile then
        -- tries a request to api, to check internet connection --
        local data = json.decode(love.filesystem.read("src/ApiConfig.json"))
        discordrpc.initialize(data.discord.appid, true)

        discordrpc.updatePresence(Discord.presence)
    else
        io.printf("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Failed to initialize to discord, cannot find config file{reset}\n")
    end
end

function Discord.updatePresence()
    discordrpc.updatePresence(Discord.presence)
end

return Discord