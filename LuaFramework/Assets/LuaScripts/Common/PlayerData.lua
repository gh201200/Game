local PlayerData = class("Common.PlayerData")

local File = System.IO.File

function PlayerData:ctor(...)
	self.configPath = Application.persistentDataPath .. "/userdata.bytes"
	self.passwd = "19930822"
end

function PlayerData:Load()
	if File.Exists(self.configPath) then
		local ebytes = File.ReadAllBytes(self.configPath)
		local dbytes = EncryptUtil.DecryptBytes(ebytes, self.passwd)
		local str = Api.GetString(dbytes)
		local res = loadstring("return " .. str)()
		return res
	else
		return {}
	end
end

function PlayerData:Save(data)
	local bytes = Api.GetBytes(tostring(data))
	local ebytes = EncryptUtil.EncryptBytes(bytes, self.passwd)
	File.WriteAllBytes(self.configPath, ebytes)
end

return PlayerData.new()
