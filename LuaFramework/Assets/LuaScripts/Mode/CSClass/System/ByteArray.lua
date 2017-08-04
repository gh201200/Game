
ByteArray = {}

ByteArray.Init = function()
	if not ByteArray.cs_ByteArray then
		-- local cs_args = NewObjectArr(5120)
		-- ByteArray.cs_ByteArray = cs_Base:InitClass("HHByteArray",cs_args)
		ByteArray.cs_ByteArray = HHByteArray.New(5120)
	end
	CsByteClear(ByteArray.cs_ByteArray)
	return ByteArray.cs_ByteArray
end

ByteArray.CreateByteArray = function()
	-- local cs_args = NewObjectArr(5120)
	-- ByteArray.cs_ByteArray = cs_Base:InitClass("HHByteArray",cs_args)
	ByteArray.cs_ByteArray = HHByteArray.New(5120)
end

ByteArray.JoinShort = CsByteJoinShort
ByteArray.WriteInt = CsByteWriteInt
ByteArray.WriteShort = CsByteWriteShort
ByteArray.WriteByte = CsByteWriteByte
ByteArray.WriteBytes = CsByteWriteBytes
ByteArray.ReadInt = CsByteReadInt
ByteArray.ReadShort = CsByteReadShort
ByteArray.ReadByte = CsByteReadByte
ByteArray.ReadBool = CsByteReadBool
ByteArray.Readbytes = CsByteReadbytes
ByteArray.Clear = CsByteClear
ByteArray.GetLength = CsByteGetLength

ByteArray.WriteUTF = function(cs_ByteArray, str, length)
	if length then
		if #str > length then
			str = string.sub(str, 0, length)
		end
		CsByteWriteUTF_2(cs_ByteArray, str, length)
	else
		CsByteWriteUTF_1(cs_ByteArray, str)
	end
end

ByteArray.ReadUTF = function(cs_ByteArray, length)
	if length then
		return CsByteReadUTF_2(cs_ByteArray, length)
	else
		return CsByteReadUTF_1(cs_ByteArray)
	end
end





-- ByteArray.Compress = function(cs_ByteArray)
	-- return RunStaticFunc("HHByteArray", "Compress", cs_ByteArray)
-- end

-- ByteArray.Uncompress = function(cs_ByteArray)
	-- return RunStaticFunc("HHByteArray", "Uncompress", cs_ByteArray)
-- end