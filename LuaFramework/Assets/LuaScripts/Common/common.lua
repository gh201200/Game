local _tostring = tostring
function table.tostring(t, tab)
    local str = str or ""
    if not t then
        print("table is nil")
        return str
    end

    tab = tab or "        "
    str = str .. "{\n"

    if type(t) == "table" then
        for k, v in pairs(t) do
            if type(k) == "number" then
                str = str .. tab .. "[" .. k .. "]" .. " = "
            else
                str = str .. tab .. "[\"" .. k .. "\"]" .. " = "
            end
            if type(v) == "string" then
                str = str .. "\"" .. v .. "\"" .. ",\n"
            elseif type(v) == "number" then
                str = str .. v .. ",\n"
            elseif type(v) == "boolean" then
                str = str .. _tostring(v) .. ",\n"
            elseif type(v) == "function" then
                str = str .. _tostring(v) .. ",\n"
            elseif type(v) == "thread" then
                str = str .. "thread : " .. _tostring(v) .. ",\n"
            elseif type(v) == "userdata" then
                str = str .. "userdata : " .. _tostring(v) .. ",\n"
            elseif type(v) == "table" then
                str = str .. table.tostring(v, tab .. "        ") .. ",\n"
            else
                str = str .. "unknow : " .. _tostring(v) .. ",\n"
            end
        end
        str = str .. string.sub(tab, 1, #tab - 8) .. "}"
    else
        str = t
    end

    return str
end
tostring = table.tostring