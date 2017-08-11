function class(classname, super)  
     local cls = {}  
     if super then  
        cls = {}  
        for k,v in pairs(super) do cls[k] = v end  
        cls.super = super  
    else  
        cls = {ctor = function() end}  
    end  
  
    cls.__cname = classname  
    cls.__index = cls  
  
    function cls.new(...)  
        local instance = setmetatable({}, cls)  
        local create  
        create = function(c, ...)  
             if c.super then -- 递归向上调用create  
                  create(c.super, ...)  
             end  
             if c.ctor then  
                  c.ctor(instance, ...)  
             end  
        end  
        create(instance, ...)  
        instance.class = cls  
        return instance  
    end  
    return cls  
end

function Class(base,static,instance)

    local mt = getmetatable(base)

    local class = static or {}
    setmetatable(class, 
        {
            __index = base,
            __call = function(...)
                local r = mt.__call(...)
                local ret = instance or {}

                local ins_ret = setmetatable(
                    {
                        __base = r,
                    },

                    {
                        __index = function(t, k)
                            local ret_field
                            ret_field = ret[k]
                            if nil == ret_field then
                                ret_field = r[k]
                            end

                            return ret_field
                        end,

                        __newindex = function(t,k,v)
                            if not pcall(function() r[k]=v end) then
                                rawset(t,k,v)
                            end
                        end,
                    })

                if ret.ctor then
                    ret.ctor(ins_ret, ...)
                end

                return ins_ret
            end,
        }
    )
    return class
end

function dumpTab(tab,ind)
  if(tab==nil)then return "nil" end;
  local str="{";
  if(ind==nil)then ind="  "; end;
   --//each of table
  for k,v in pairs(tab) do
     --//key
    if(type(k)=="string")then
       k="[\"" .. tostring(k) .. "\"]" .." = ";
    else
       k="["..tostring(k).."] = ";
    end;--//end if
     --//value
    local s="";
    if(type(v)=="nil")then
       s="nil";
    elseif(type(v)=="boolean")then
       if(v) then s="true"; else s="false"; end;
    elseif(type(v)=="number")then
       s=v;
    elseif(type(v)=="string")then
       s="\""..v.."\"";
    elseif(type(v)=="table")then
       s=dumpTab(v,ind.."  ");
       s=string.sub(s,1,#s-1);
    elseif(type(v)=="function")then
       s="function : "..v;
    elseif(type(v)=="thread")then
       s="thread : "..tostring(v);
    elseif(type(v)=="userdata")then
       s="userdata : "..tostring(v);
    else
       s="nuknow : "..tostring(v);
    end;--//end if
     --//Contact
    str=str.."\n"..ind..k..s.." ,";
   end --//end for
   --//return the format string
   local sss=string.sub(str,1,#str-1);
   if(#ind>0)then ind=string.sub(ind,1,#ind-2) end;
   sss=sss.."\n"..ind.."}\n";
   return sss;--string.sub(str,1,#str-1).."\n"..ind.."}\n";
end