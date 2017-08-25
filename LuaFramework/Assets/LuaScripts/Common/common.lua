table.size = function(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

table.empty = function(t)
    return not next(t)
end

table.copy = function(t)
    local result = { }

    setmetatable(result, getmetatable(t))

    for k, v in pairs(t) do
        if type(v) == "table" then
            result[k] = table.copy(v)
        else
            result[k] = v
        end
    end
    return result
end

function table.containsKey(t, key)
    for k, v in pairs(t) do
        if key == k then
            return true;
        end
    end
    return false;
end

do
    local _tostring = tostring
    function table.tostring(t, tab)
        local str = str or ""
        if not t then
            print("nil")
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
            str = _tostring(t)
        end

        return str
    end
    tostring = table.tostring
end

string.ltrim = function(s, c)
    local pattern = "^" ..(c or "%s") .. "+"
    return(string.gsub(s, pattern, ""))
end

string.rtrim = function(s, c)
    local pattern =(c or "%s") .. "+" .. "$"
    return(string.gsub(s, pattern, ""))
end

string.trim = function(s, c)
    return string.rtrim(string.ltrim(s, c), c)
end

string.split = function(s, c)
    local t = { }
    c = c or "%s"
    local pattern = "[^" .. c .. "]+"
    string.gsub(s, pattern, function(v)
        table.insert(t, string.trim(v, "%s"))
    end )
    return t
end

function class(className, super)
    local cls = { }
    cls.name = className
    cls.super = super
    cls.new = function(...)
        local obj = { }
        do
            local create
            create = function(c, ...)
                if c.super then
                    create(c.super, ...)
                end
                if c.ctor then
                    c.ctor(...)
                end
            end

            create(cls, ...)
        end
        setmetatable(obj, { __index = table.copy(cls) })
        return obj
    end

    if super then
        setmetatable(cls, { __index = table.copy(super) })
    end

    return cls
end


local _class = { }
function class(className, super)
    local class_type = { }
    class_type.ctor = false
    class_type.super = super
    class_type.new = function(...)
        local obj = { }
        do
            local create
            create = function(c, ...)
                if c.super then
                    create(c.super, ...)
                end
                if c.ctor then
                    c.ctor(obj, ...)
                end
            end

            create(class_type, ...)
        end
        setmetatable(obj, { __index = _class[class_type] })
        return obj
    end
    local vtbl = { }
	vtbl.name = className
    _class[class_type] = vtbl

    setmetatable(class_type, {
        __newindex =
        function(t, k, v)
            vtbl[k] = v
        end
    } )

    if super then
        setmetatable(vtbl, {
            __index =
            function(t, k)
                local ret = _class[super][k]
                vtbl[k] = ret
                return ret
            end
        } )
    end

    return class_type
end