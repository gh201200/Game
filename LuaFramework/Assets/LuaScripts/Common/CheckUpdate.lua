local CheckUpdate = class("Common.CheckUpdate")

local this = nil
local File = System.IO.File
local checked = false
local compareFinish = false
local ready = true
local downloadingFile = nil
local curAsyncArgs = nil

local function Update()
	if not checked and this.op and this.op.cur ~= 0 then
		--print(this.op.cur, this.op.total, this.op.progress)
		if this.op.isDone then
			print("AssetInfo download complete!")
			this:Compare()
			checked = true
		end
	end
	if not compareFinish then return end
	if not this.needUpdate then
		LuaManager.OnUpdateEvent = {"-=", Update}
		EventManager:Dispatch(EventType.OnCheckUpdateComplete, this.needUpdate)
		return
	end
	if ready and table.size(this.waitToDownloadList) > 0 then
		for k, v in pairs(this.waitToDownloadList) do
			downloadingFile = v
			this.waitToDownloadList[k] = nil
			break
		end
	end
	if downloadingFile and ready then
		if File.Exists(this.rootPath .. downloadingFile.path .. this.tempFileSuffix) then
			File.Delete(this.rootPath .. downloadingFile.path .. this.tempFileSuffix)
		end
		curAsyncArgs = HttpHelper.Instance:DownLoadFileAsync(this.remoteUrl .. downloadingFile.path, this.rootPath .. downloadingFile.path .. this.tempFileSuffix)
		ready = false
	end
	if curAsyncArgs and curAsyncArgs.isDone then
		if File.Exists(this.rootPath .. downloadingFile.path) then
			File.Delete(this.rootPath .. downloadingFile.path)
		end
		File.Move(this.rootPath .. downloadingFile.path .. this.tempFileSuffix, this.rootPath .. downloadingFile.path)
		this.completeList[downloadingFile.path] = downloadingFile
		ready = true
		-- downloadingFile = nil
	end
	
	this.progress = (table.size(this.completeList) + curAsyncArgs.progress) / table.size(this.updateList)
	
	-- print("downloading... " .. tonumber(string.format("%.2f", this.curSize / this.totalSize)) * 100 .. "%", this.curSize, this.totalSize)
	EventManager:Dispatch(EventType.OnUpdating, downloadingFile, this.totalSize, this.progress)
	if table.size(this.completeList) == this.updateCount then
		LuaManager.OnUpdateEvent = {"-=", Update}
		if File.Exists(this.json_local) then
			File.Delete(this.json_local)
		end
		File.Move(this.json_server, this.json_local)
		EventManager:Dispatch(EventType.OnCheckUpdateComplete, this.needUpdate)
	end
end

local function OnDestroy()

end

function CheckUpdate:ctor()
	this = self
	this.remoteUrl = "http://192.168.0.232:5555/Version/Assets/"
	this.rootPath = Application.persistentDataPath .. "/"
	this.tempFileSuffix = ".tempfile"
	this.json_server = this.rootPath .. "AssetsInfo_Server.json"
	this.json_local = this.rootPath .. "AssetsInfo.json"
	this.updateList = {}
	this.waitToDownloadList = {}
	this.completeList = {}
end

function CheckUpdate:Check()
	if DEBUG_MODE then
		EventManager:Dispatch(EventType.OnCheckUpdateComplete)
		return
	end
	EventManager:Dispatch(EventType.OnStartCheckUpdate)
	if File.Exists(this.json_server) then File.Delete(this.json_server) end
	this.op = HttpHelper.Instance:DownLoadFileAsync(this.remoteUrl .. "AssetsInfo.json", this.json_server)
	LuaManager.OnUpdateEvent = {"+=", Update}
	LuaManager.OnDestroyEvent = {"+=", OnDestroy}
end

function CheckUpdate:Compare()
	local str = File.ReadAllText(this.json_server)
	local t_server = Json.decode(str)
	this.serverVersionInfo = t_server.info
	-- File.WriteAllText("C:/Users/Administrator/Desktop/test.lua", tostring(t_server))
	if File.Exists(this.json_local) then
		local t_local = Json.decode(File.ReadAllText(this.json_local))
		this.localVersionInfo = t_local.info
		EventManager:Dispatch(EventType.ShowVersion, this.localVersionInfo, this.serverVersionInfo)
		for k, v in pairs(t_server.files) do
			if not t_local.files[k] or (t_local.files[k] and string.lower(t_local.files[k].md5) ~= string.lower(v.md5)) then
				this.updateList[k] = v
			end
		end
	else
		this.updateList = t_server.files
	end
	print("更新列表:", this.updateList)
	if table.size(this.updateList) == 0 then
		print("已是最新版本!")
		compareFinish = true
		this.needUpdate = false
		File.Delete(this.json_server)
		return
	end
	this.needUpdate = true
	this.updateCount = 0
	this.totalSize = 0
	for k, v in pairs(this.updateList) do
		this.updateCount = this.updateCount + 1
		this.waitToDownloadList[k] = v
		this.totalSize = this.totalSize + v.size
	end
	EventManager:Dispatch(EventType.QueryUpdate, this.totalSize, "更新", "退出游戏", function()		
		compareFinish = true
	end, Api.Quit)
end

return CheckUpdate.new()