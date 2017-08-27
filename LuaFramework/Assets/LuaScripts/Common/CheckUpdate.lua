local CheckUpdate = class("Common.CheckUpdate")

local mStopwatch = require "common.stopwatch"
local Json = require "Common.Json"

function CheckUpdate:ctor()
	self.remoteUrl = "http://localhost/Version/"
end

local function DownLoadComplete(filePath, callback)
	local file = io.open(filePath, "r")
	local str = file:read("*a")
	print(Json.decode(str))
	if callback then callback() end
end

function CheckUpdate:Check(callback)
	local path = Application.persistentDataPath .. "/AssetsInfo.json"
	os.remove(path)
	HttpHelper.Instance:DownLoadFile(self.remoteUrl .. "AssetsInfo.json", path, nil, function()
		DownLoadComplete(path, callback)
		--print("download complete")
	end)
end

return CheckUpdate.new()
