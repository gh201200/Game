function GetFirstKey(t)
	if t[1] then
		return 1
	end
	for k,v in pairs(t) do
		return k
	end
	return nil
end


function GetNextKey(t)
	for i=1,#t+1 do
		if not t[i] then
			return i
		end
	end
	return 0
end

function CopyTable(t, depth)
	if not depth then
		depth = 0
	end
	depth = depth + 1
	if depth > 10 then
		error("in copyTable function: table is too depth")
	end
	local t2 = {}
	for k,v in pairs(t) do
		if type(v) == "table" then
			t2[k] = CopyTable(v, depth)
		else
			t2[k] = v
		end
	end
	return t2
end

function TurnTable(t)
	local l = #t
	local index = 1
	while index < l do
		table.insert(t, index, table.remove(t))
		index = index + 1
	end
end

function GetLength(t)
	local length = 0;
	for _,_ in pairs(t) do
		length = length + 1
	end
	return length
end

-- 返回table大小
table.size = function(t)
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

--已废弃
function GetRichTable(t, tt)
	local richTable = tt or {}
	richTable[#richTable+1] = getLength(t)
	for k,v in pairs(t) do
		table.insert(richTable, tostring(k))
		table.insert(richTable, v)
	end
	return richTable
end

function unpack(t, t2)
	if t == nil or t2 == nil or type(t) ~= "table" or type(t2) ~= "table" then
		error("t or t2 error")
	end
	for _,v in pairs(t) do
		if type(v) ~= "table" then
			table.insert(t2, v)
		else
			-- print("function unpack ! warning table is too deep!")
			unpack(v, t2)
		end
	end
end

maxInt = 2100000000
minInt = -2100000000
function writeObject(t, depth)
	if t == nil then
		return
	end
	
	assert(type(t) == "table")
	if not depth then
		depth = 0
		newObject()
	end
	depth = depth + 1
	if depth > 6 then
		error("in writeObject function: table is too depth")
	end
	writeBy(10)
	writeBy(1)
	for k,v in pairs(t) do
		assert(type(k) == "number" or type(k) == "string" )
		if type(k) == "number" then
			if math.floor(k) == k and k < maxInt and k > minInt then
				writeInt(k)
			else
				writeDouble(k)
			end
		elseif type(k) == "string" then
			writeString(k)
		end
		
		if v == false then
			writeBy(2)
		elseif v == true then
			writeBy(3)
		elseif type(v) == "number" then
			if math.floor(v) == v and v < maxInt and v > minInt then
				writeInt(v)
			else
				writeDouble(v)
			end
		elseif type(v) == "string" then
			writeString(v)
		elseif type(v) == "table" then
			writeObject(v, depth)
		end
	end
	writeBy(1)
	if depth == 1 then
		saveTable(tostring(t))
		return tostring(t)
	end
end