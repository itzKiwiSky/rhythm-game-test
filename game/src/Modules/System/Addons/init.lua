local addons = {}

local path = ...
local lfs = pcall(require, "lfs") and require("lfs")
local addonPath = (...):gsub("%.init$", "")

if lfs then
    -- Modo Lua normal com lfs
    local path = addonPath:gsub("%.", "/")
    for file in lfs.dir(path) do
        local name = file:match("(.+)%.lua$")
        if name and name ~= "init" then
            local addon = require(addonPath .. "." .. name)
            addons[name] = addon
            _G[name] = addon
        end
    end
elseif love and love.filesystem then
    for _, file in ipairs(love.filesystem.getDirectoryItems(addonPath)) do
        local name = file:match("(.+)%.lua$")
        if name and name ~= "init" then
            local addon = require(path .. "." .. name)
            addons[name] = addon
            _G[name] = addon
        end
    end
else
    error("error")
end

return addons
