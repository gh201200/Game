local Loader,table,pairs,ConstValue,string,EventType,AssetType,require,Resources,print,os,error,_G,ErrorLog,debug = 
Loader,table,pairs,ConstValue,string,EventType,AssetType,require,Resources,print,os,error,_G,ErrorLog,debug
local Application,VersionCode,io,os,GetComponent,CsFindType,FindChild,GetTransform, mSDK = 
Application,VersionCode,io,os,GetComponent,CsFindType,FindChild,GetTransform, mSDK
local mEventManager = nil
local mAlert = require "LuaScript.View.Alert.Alert"
local mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
local mTimer = require "LuaScript.Common.Timer"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.Control.AssetManager")
mAssetList = {}
mAssetTypeList = {}
mAssetReadingList = {}
mLoaderCompleteFuncs = {}
mLastUseTime = {}

local mTemporaryData = {}

function Init()
	mTimer.SetInterval(AutoUnloadAsset, 5)
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.ClearAsset, ClearAsset)
	mEventManager.AddEventListen(nil, EventType.NotFile, NotFile)
	mEventManager.AddEventListen(nil, EventType.AssetError, AssetError)
	
	-- if VersionCode < 5 then
		-- function func()
			-- GetAsset(string.format(ConstValue.ResSkillPath,7), AssetType.Forever)
		-- end
		-- GetAsset("Effect/LightningShaft", AssetType.Forever, func)
	-- end
	
	-- if VersionCode < 6 then
		-- GetAsset("GameObj/title/title_1", AssetType.Forever)
		-- GetAsset("GameObj/title/title_2", AssetType.Forever)
		-- GetAsset("GameObj/title/title_3", AssetType.Forever)
		-- GetAsset("GameObj/title/title_4", AssetType.Forever)
		-- GetAsset("GameObj/title/Materials/title_1", AssetType.Forever)
		-- GetAsset("GameObj/title/Materials/title_2", AssetType.Forever)
		-- GetAsset("GameObj/title/Materials/title_3", AssetType.Forever)
		-- GetAsset("GameObj/title/Materials/title_4", AssetType.Forever)
		-- GetAsset("GameObj/title/1", AssetType.Forever)
		-- GetAsset("GameObj/title/2", AssetType.Forever)
		-- GetAsset("GameObj/title/3", AssetType.Forever)
		-- GetAsset("GameObj/title/4", AssetType.Forever)
		
		-- GetAsset("Effect/buff10", AssetType.Forever)
		-- GetAsset("Effect/buff11", AssetType.Forever)
		-- GetAsset("Effect/buff12", AssetType.Forever)
		-- GetAsset("Effect/Materials/buff11", AssetType.Forever)
		-- GetAsset("Effect/Materials/buff12", AssetType.Forever)
		-- GetAsset("Effect/Materials/buff13", AssetType.Forever)
		-- GetAsset("GameObj/skill/22", AssetType.Forever)
		-- GetAsset("GameObj/skill/23", AssetType.Forever)
		-- GetAsset("GameObj/skill/24", AssetType.Forever)
	-- end
	
	-- if VersionCode < 9 then
		-- GetAsset("GameObj/ships/42", AssetType.Forever)
		-- GetAsset("GameObj/ships/43", AssetType.Forever)
		-- GetAsset("GameObj/ships/44", AssetType.Forever)
		
		-- GetAsset("GameObj/skill/1", AssetType.Forever)
		-- GetAsset("GameObj/skill/25", AssetType.Forever)
		-- GetAsset("GameObj/skill/26", AssetType.Forever)
		-- GetAsset("GameObj/skill/27", AssetType.Forever)
		-- GetAsset("GameObj/skill/28", AssetType.Forever)
		-- GetAsset("GameObj/skill/29", AssetType.Forever)
		-- GetAsset("GameObj/skill/30", AssetType.Forever)
		-- GetAsset("GameObj/skill/31", AssetType.Forever)
		-- GetAsset("GameObj/skill/32", AssetType.Forever)
		-- GetAsset("GameObj/skill/33", AssetType.Forever)
		-- GetAsset("GameObj/skill/34", AssetType.Forever)
		-- GetAsset("GameObj/skill/35", AssetType.Forever)
		-- GetAsset("GameObj/skill/36", AssetType.Forever)
		-- GetAsset("GameObj/skill/37", AssetType.Forever)
		-- GetAsset("GameObj/skill/38", AssetType.Forever)
		-- GetAsset("GameObj/skill/39", AssetType.Forever)
		-- GetAsset("GameObj/skill/7", AssetType.Forever)
	-- end
end

function NotFile()
	if mAlert.visible or mPromptAlert.visible then
		return
	end
	if _G.IsDebug then
		return
	end
	if _G.ShowNotFile then
		return
	end
	_G.ShowNotFile = true
	
	local errorId = 20000
	local value = os.remove(ConstValue.ResPath.."newResList")
	local value = os.remove(ConstValue.DataPath.."version")
	if value then
		errorId = 20001
	end
	if mSDK.GetChannelName() ~= "185sy" then
		mAlert.Show("读取资源失败,错误编号:"..errorId.."!\n请重开游戏,将会自动下载更新包.如问题还未解决,请联系客服,官方QQ群:390261959",mCommonlyFunc.QuitGame,nil,"退出")
	else
		mAlert.Show("读取资源失败,错误编号:"..errorId.."!\n请重开游戏,将会自动下载更新包.如问题还未解决,请联系客服。",mCommonlyFunc.QuitGame,nil,"退出")
	end
end

function AssetError(_, _, errorStr)
	if _G.ShowAssetError then
		return
	end
	_G.ShowAssetError = true
	
	if mSDK.GetChannelName() ~= "185sy" then
		mAlert.Show("游戏文件已损坏,请尝试下载并安装最新版本。如未解决本问题请联系客服,官方QQ群:390261959")
	else
		mAlert.Show("游戏文件已损坏,请尝试下载并安装最新版本。")
	end
	ErrorLog("AssetError!", errorStr.."\n"..debug.traceback())
end

function HaveAsset(path)
	return mAssetList[path] ~= nil
end

function GetAsset(path, type, completeFunc, shieldError)
	-- if not type then
		-- error("type is nil")
	-- end
	
	-- if type == AssetType.Map then
		-- print(2222222222)
	-- end
	mLastUseTime[path] =  os.oldClock or os.clock()
	if mAssetList[path] then
		return mAssetList[path]
	elseif not mAssetReadingList[path] then
		mAssetTypeList[path] = type
		mAssetReadingList[path] = true
		
		local cs_Loader = Loader.Init(path, LoaderComplete, shieldError)
		if mAssetList[path] then
			return mAssetList[path]
		end
		
		if completeFunc then
			mLoaderCompleteFuncs[path] = mLoaderCompleteFuncs[path] or {}
			table.insert(mLoaderCompleteFuncs[path], completeFunc)
		end
	end
end

function LoaderComplete(cs_Loader, eventType, param)
	-- print("LoaderComplete")
	mAssetList[param] = cs_Loader.mainAsset
	mAssetReadingList[param] = nil
	if mLoaderCompleteFuncs[param] then
		for k,func in pairs(mLoaderCompleteFuncs[param]) do
			func(cs_Loader, eventType, param)
		end
		mLoaderCompleteFuncs[param] = nil
	end
end

function ClearAsset(target, eventType, level)
	local clearList = {}
	if level == 1 then
		for key,type in pairs(mAssetTypeList) do
			if type == AssetType.Map or type == AssetType.Icon or type == AssetType.Pic or type == AssetType.CopyMap then
				clearList[key] = true
			end
		end
	elseif level == 2 then
		for key,type in pairs(mAssetTypeList) do
			if type == AssetType.Map or type == AssetType.Icon or type == AssetType.Pic or type == AssetType.CopyMap
				or type == AssetType.Ship or type == AssetType.GUI then
				clearList[key] = true
			end
		end
	elseif level == 3 then
		for key,type in pairs(mAssetTypeList) do
			if type ~= AssetType.Forever then
				clearList[key] = true
			end
		end
	end
	
	for key,_ in pairs(clearList) do
		UnloadAsset(key)
	end
	
	-- 测试
	Resources.UnloadUnusedAssets()
end


function UnloadAsset(path)
	local asset = mAssetList[path]
	if asset then
		-- print(path)
		local type = mAssetTypeList[key]
		if type ~= AssetType.Ship and type ~= AssetType.Audio then
			Resources.UnloadAsset(asset)
		end
		mAssetList[path] = nil
		mAssetTypeList[path] = nil
	end
end

function AutoUnloadAsset()
	-- print("AutoUnloadAsset")
	-- local t = os.clock()
	local unloadAssetList = {}
	for key,_ in pairs(mAssetList) do
		local type = mAssetTypeList[key]
		if type ~= AssetType.Ship and type ~= AssetType.Map and type ~= AssetType.GUIStyle 
			and type ~= AssetType.Material and type ~= AssetType.Forever then
			-- print(key, type)
			if os.oldClock - mLastUseTime[key] > 5 then
				table.insert(unloadAssetList, key)
			end
		end
	end
	
	for _,key in pairs(unloadAssetList) do -- 系统资源自动释放
	    -- print(key)
		UnloadAsset(key)
	end
	-- print(os.clock() - t)
	-- print(unloadAssetList)
end