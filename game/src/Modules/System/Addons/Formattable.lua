function debug.formattable(tbl, indent, crawlTable)
    crawlTable = crawlTable or false
    indent = indent or 0

    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 1 
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= "   
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            if crawlTable then
                toprint = toprint .. debug.formattable(v, indent + 1, crawlTable) .. ",\r\n"
            else
                toprint = toprint  .. "{...},\r\n"
            end
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
end

return debug.formattable