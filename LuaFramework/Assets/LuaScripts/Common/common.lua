
local function get_timezone()
  local now = os.time()
  return 28800-os.difftime(now, os.time(os.date("!*t", now)))
end
os.offset = get_timezone()

os._date = os.date
os.date = function(format, value)
	if value then
		value = value + os.offset
	end
	return os._date(format, value)
end


math.round = function(num)
	local v,m = math.modf(num)
	if m >= 0.5 then
		return v + 1
	else
		return v
	end
end

table.simpleConcat = function(a, b)
	for _,v in pairs(b) do
		table.insert(a, v)
	end
end

math.clamp = function(value, min, max)
	return math.max(math.min(value,max),min)
end

math.sum = function(a, b)
	return a + b
end

math.minus = function(a, b)
	return a - b
end

os._clock = os.clock
os.clock = function()
	return CsGetTime()
end
math.randomseed(os.time())

function _print(...)
	local msg = ""
	local arg = {...}
	if type(arg[1]) == "table" and #arg == 1 then
		msg = msg .. "[-------------table-------------]\n";
		for k,v in pairs(arg[1]) do
			msg = msg .. tostring(k) .. "\t" .. tostring(v) .. "\n"
		end
		msg = msg .. "[-------------table-------------]\n";
	else
		local maxKey = getMaxKey(arg)
		for i=1,maxKey,1 do
			msg = msg .. tostring(arg[i]) .. "\t"
		end
		if maxKey == 0 then
			msg = "nil"
		end
	end
	CsPrint(msg .. "\n" .. debug.traceback())
end

function print(...)
	if not _G.IsDebug then
		return
	end
	_print(...)
end

function NewObjectArr(...)
	return cs_Base:NewObjectArr(getMaxKey({...}), ...)
end

function getMaxKey(t)
	local maxKey = 0
	for k,v in pairs(t) do
		if maxKey < k then
			maxKey = k
		end
	end
	return maxKey
end

local fileName = ""
function loadFile()
	package.loaded[fileName] = nil
	require(fileName)
end

local luaScr = ""
function loadLuaScr()
	local f,err = loadstring(luaScr, "hotfix")
	if f then
		return f()
	else
		ErrorLog(err)
	end
end

function RunLuaScript(str)
	if str == "load" then
		print("load hotfix.lua")
		fileName = "LuaScript.hotfix"
		local _,value = xpcall(loadFile, ErrorLog)
		return value
	elseif string.sub(str, 1, 4) == "load" then
		print(str)
		fileName = string.sub(str, 6, #str)
		local _,value = xpcall(loadFile, ErrorLog)
		return value
	else
		luaScr = str
		local _,value = xpcall(loadLuaScr, ErrorLog)
		return value
	end
end


local OverpassList = {["Trying to reload asset from disk that is not stored on disk\n"]=true}
local ErrorList = {}
function ErrorLog(info, traceback)
	info = tostring(info)
	if traceback then
		traceback = tostring(traceback)
	end
	
	if not _G.IsDebug then
		if OverpassList[info] then
			return
		end
		
		if ErrorList[info] then
			return
		end
		ErrorList[info] = 0
		
		-- if string.find(info, "Trying to reload asset") then
			-- info = info .. "\n" .. mLoader.GetLogs()
		-- end

		local succes,err = pcall(UploadError, tostring(info).."\n".. (traceback or debug.traceback()))
		if not succes then
			pcall(Upload, err)
		end
	else
		if ErrorList[info] and os.oldClock - ErrorList[info] < 5 then
			return
		end
		ErrorList[info] = os.oldClock
		
		info = "error : " .. tostring(info)
		_print(info)

		if mSystemTip then
			mSystemTip.ShowTip(info, Color.RedStr)
		end
	end
end

local mUploadErrorCount = 0
function UploadError(info)
	info = tostring(info)
	if mUploadErrorCount > 10 then
		return
	end
	
	local str = ""
	
	-- local param = {CsCheckStack()}
	-- if param[1] then
		-- local paramStr = "param: length = " .. #param .. "\n"
		-- paramStr = paramStr .. "[1] = " .. tostring(param[1]) .. "\n"
		-- paramStr = paramStr .. "[2] = " .. tostring(param[2]) .. "\n"
		-- paramStr = paramStr .. "[3] = " .. tostring(param[3]) .. "\n"
		-- paramStr = paramStr .. "[4] = " .. tostring(param[4]) .. "\n"
		-- str = str .. paramStr
	-- end
	
	if mHeroManager then
		local hero = mHeroManager.GetHero()
		if hero then
			local info = "ID:" .. hero.id .. "\n"
			info = info .. "Name:" .. tostring(hero.name) .. "\n"
			info = info .. "Map:" .. tostring(hero.map) .. "\n"
			info = info .. "Level:" .. tostring(hero.level) .. "\n"
			info = info .. "SceneType:" .. tostring(hero.SceneType) .. "\n"
			info = info .. "HarborId:" .. tostring(hero.harborId) .. "\n"
			str = str .. info
		end
	end
	
	if mAccountManager then
		local serverName = mAccountManager.GetServerName()
		if serverName then
			str = str .. "Server:" .. serverName .. "\n"
		end
		if platform then
			str = str .. "Platform:" .. platform .. "\n"
		end
		if Version then
			str = str .. "Version:" .. Version .. "\n"
		end
		if VersionName then
			str = str .. "VersionName:" .. VersionName .. "\n"
		end
	end
	
	if _G.connectTime then
		str = str .. "ConnectTime:" .. _G.connectTime .. "\n"
	end
	
	if _G.startTime then
		str = str .. "StartTime:" .. _G.startTime .. "\n"
	end
	str = str .. "CurrentTime:" .. os.date("%x %X").. "\n"
	if mNetManager then
		str = str .. "IsConnected:" .. tostring(mNetManager.IsConnected()).. "\n"
	end
	str = str .. GetMachineInfo()
	str = str .. info .. "\n\n\n"
	
	Upload(str)
end

function Upload(str)
	str = tostring(str)
	if mUploadErrorCount > 10 then
		return
	end
	mUploadErrorCount = mUploadErrorCount + 1
	
	-- local mWWWForm = CsInitClass(WWWForm.GetType(), nil)
	-- mWWWForm:AddField("errorInfo", str)
	
	-- local cs_Args = NewObjectArr(ErrorCollectUrl,mWWWForm)
	-- CsInitClass(WWW.GetType(), cs_Args)
	
	local mWWWForm = UnityEngine.WWWForm.New()
	mWWWForm:AddField("errorInfo", str)
	UnityEngine.WWW.New(ErrorCollectUrl, mWWWForm)
end

local mMachineInfo = nil
function GetMachineInfo()
	if mMachineInfo then
		return mMachineInfo
	end
	mMachineInfo = ""
	--ios test script
	if IosTestScript then
		return mMachineInfo
	end
	
	local csConfig = luanet.import_type("UnityEngine.SystemInfo")
	local csApplication = luanet.import_type("UnityEngine.Application")
	-- mMachineInfo = "deviceModel = " .. csConfig.deviceModel .. "\n"
	mMachineInfo = mMachineInfo .. "deviceUniqueIdentifier = " .. csConfig.deviceUniqueIdentifier .. "\n"
	-- mMachineInfo = mMachineInfo .. "systemMemorySize = " .. csConfig.systemMemorySize .. "M\n"
	mMachineInfo = mMachineInfo .. "graphicsDeviceName = " .. csConfig.graphicsDeviceName .. "\n"
	-- mMachineInfo = mMachineInfo .. "graphicsMemorySize = " .. csConfig.graphicsMemorySize .. "M\n"
	mMachineInfo = mMachineInfo .. "appPlatform = " .. tostring(csApplication.platform) .. "\n"
	return mMachineInfo
end

function CoyeToClipboard(str)
	if not TextEditor then
		return
	end
	sc_TextEditor = TextEditor.Init()
	sc_TextEditor.content = GUIContent.Init(str)
	sc_TextEditor:SelectAll()
	sc_TextEditor:Copy()
end


function CleanCache()
	local Caching = luanet.import_type("UnityEngine.Caching")
	Caching.CleanCache()
end

function LoadScript()
	local mSystemTip = require "LuaScript.View.Tip.SystemTip"
	local csConfig = luanet.import_type("Config")
	function complete11(csLoader)
		mSystemTip.ShowTip("11 OVER")
		File.WriteAllBytes(csConfig.ResPath.."11", csLoader.bytes)
	end
	Loader.Load(csConfig.ResUrl.."11", complete11, true)
	
	function complete22(csLoader)
		mSystemTip.ShowTip("22 OVER")
		File.WriteAllBytes(csConfig.ResPath.."22", csLoader.bytes)
	end
	Loader.Load(csConfig.ResUrl.."22", complete22, true)
end