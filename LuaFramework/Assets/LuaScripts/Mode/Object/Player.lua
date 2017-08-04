

module("LuaScript.Mode.Object.Player")

function ReadPlayer(cs_ByteArray)
	local data = {}
	data.id = ByteArray.ReadInt(cs_ByteArray)
	data.lv = ByteArray.ReadInt(cs_ByteArray)
	data.x = ByteArray.ReadInt(cs_ByteArray)
	data.y = ByteArray.ReadInt(cs_ByteArray)
	data.name = ByteArray.ReadUTF(cs_ByteArray)
	
	local isMove = ByteArray.ReadBool(cs_ByteArray)
	if isMove then
		local count = ByteArray.ReadShort(cs_ByteArray)
		data.path = {}
		for i=1,count,1 do
			data.path[#data.path+1] = ByteArray.ReadInt(cs_ByteArray)
		end
	end
end



-- function ReadShipData(cs_ByteArray)
	-- local count = ByteArray.ReadShort(cs_ByteArray)
	-- for i=1,count,1 do
		-- local data = {}
		-- data.id = ByteArray.ReadInt(cs_ByteArray)
		-- data.x = ByteArray.ReadInt(cs_ByteArray)
		-- data.y = ByteArray.ReadInt(cs_ByteArray)
		-- data.name = ByteArray.ReadUTF(cs_ByteArray)
	-- end
-- end

-- function Read