local CheckUpdate = class("Common.CheckUpdate")

local mStopwatch = require "common.stopwatch"

function CheckUpdate:ctor()
	self.remoteUrl = "http://localhost/Version/"
end

local function DownLoadComplete(filePath, callback)
	local file = io.open(filePath, "r")
	local str = file:read("*a")
	mStopwatch:Start()
	local pattern = "\"[%w]+\":"
	string.gsub(str, pattern, function(v)
		if string.find(str, v) then
			str = string.gsub(str, v, string.gsub(v, "\"", ""))
		end
	end)
	str = string.gsub(str, ":", "=")
	str = string.gsub(str, "%[", "%{")
	str = string.gsub(str, "%]", "%}")
	local data = "data=" .. str .. "\nreturn data"
	local res = LuaManager.Instance:DoString(data)
	print(mStopwatch:Stop())
	print(res)
	if callback then callback() end
end

function CheckUpdate:Check(callback)
	local path = Application.persistentDataPath .. "/AssetsInfo.json"
	os.remove(path)
	HttpHelper.Instance:DownLoadFile(self.remoteUrl .. "AssetsInfo.json", path, nil, function()
		DownLoadComplete(path, callback)
	end)
end

return CheckUpdate.new()
