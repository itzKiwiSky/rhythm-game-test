local LanguageManager = {}

local function _findKey(_tblInput, _tblOutput)
    for k, v in pairs(_tblInput) do
        if type(v) == "table" then
            _findKey(v, _tblOutput)
        else
            _tblOutput[k] = v
        end
    end
end

function LanguageManager:getData(_language)
    local data = {}

    local tempdata = json.decode(love.filesystem.read("assets/data/language/" .. _language .. ".lang"))
    _findKey(tempdata, data)
    return data
end

function LanguageManager:getRawData(_language)
    return json.decode(love.filesystem.read("assets/data/language/" .. _language .. ".lang"))
end

return LanguageManager