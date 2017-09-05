local PlayerData = class("Common.PlayerData")

local File = System.IO.File

local this = nil

function PlayerData:ctor(...)
	this = self
	this.configPath = Application.persistentDataPath .. "/userdata.bytes"
	this.passwd = "19930822"
	LuaManager.OnDestroyEvent = {"+=", function()
		this:Save(Data)
	end}
end

function PlayerData:Load()
	if File.Exists(this.configPath) then
		local ebytes = File.ReadAllBytes(this.configPath)
		local dbytes = EncryptUtil.DecryptBytes(ebytes, this.passwd)
		local str = Api.GetString(dbytes)
		local res = loadstring("return " .. str)()
		return res
	else
		return {}
	end
end

function PlayerData:Save(data)
	local str = tostring(data)
	local bytes = Api.GetBytes(str)
	local ebytes = EncryptUtil.EncryptBytes(bytes, this.passwd)
	File.WriteAllBytes(this.configPath, ebytes)
	print("save PlayerData:", str)
end

return PlayerData.new()
