function SplitString(str,delimiter)
   local args = {};
   local pattern = '(.-)' .. delimiter;
   local last_end = 1;
   local s,e,cap = string.find(str,pattern, 1);
   while s do
      if s ~= 1 or cap ~= '' then
  table.insert(args,cap);
      end
      last_end = e + 1;
      s,e,cap = string.find(str,pattern,last_end);
   end
   if last_end <= #str then
      cap = string.sub(str,last_end);
      table.insert(args,cap);
   end
   return args;
end
--去除字符串头部和尾部的空格 \t等
function Trim(str)
 local tmp = string.gsub(str,"^%s+","")
 tmp = string.gsub(tmp,"%s+$","")
 return tmp
end
function splitWithTrim(str,delim)
 local args = {}
 local pattern = '(.-)' .. delim
 local last_end = 1
 local s,e,cap = string.find(str,pattern , 1)
 while s do
  local tmp = trim(cap)
  if tmp ~= '' then
   table.insert(args,tmp)
  end
  last_end = e+1
  s,e,cap = string.find(str,pattern,last_end)
 end
 if last_end <= #str then
  cap = trim(string.sub(str,last_end))
  if cap ~= "" then
   table.insert(args,cap)
  end
 end
 return args
end

function CutString(str, c)
 local arr = {}
 local k = 1
 local i = 1
 local j = 1
 while j <= string.len(str) do
  if string.sub(str, j, j) == c then
   if i <= j-1 then
    arr[k] = string.sub(str, i, j-1)
    k = k+1
   end
   i = j+1
  elseif j == string.len(str) then
   arr[k] = string.sub(str, i, j)
   break
  end
  j = j+1
 end
 return arr
end
-- res/0_0.png.unity3d	.unity3d		
function ReplaceString(str, oldV, newV)
	return string.gsub(str, oldV, newV)
	-- print(str, oldV, newV)
	-- local index = 1
	-- local oldLength = #oldV
	-- local newLength = #newV
	-- while index < #str-oldLength do
		-- if string.sub(str, index, index+oldLength-1) == oldV then
			-- print(string.sub(str, 1, index-1), newV, string.sub(str, index+oldLength))
			-- str = string.sub(str, 1, index-1) .. newV .. string.sub(str, index+oldLength)
			-- index = index + newLength
		-- else
			-- index = index + 1
		-- end
	-- end
	-- return str
end

local tempList = {}
local tempIndex = 0
function ReplaceColor(str)
	if tempList[str] then
		return tempList[str].s
	end
	tempIndex = tempIndex + 1
	if tempIndex%50 == 0 then
		local destroyList = {}
		for k,v in pairs(tempList) do
			if os.oldTime - v.t > 60 then
				destroyList[k] = true
			end
		end
		for k,v in pairs(destroyList) do
			tempList[k] = nil
		end
	end
	
	local s = string.gsub(str, Language[214], Language[164])
	s = string.gsub(s, Language[215], Language[164])
	tempList[str] = {s=s, t=os.oldTime or 0}
	return tempList[str].s
end