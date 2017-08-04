
Loader = {}
local table,ErrorLog,print,NewObjectArr,cs_Base,Resources,EventType,File,ConstValue,ReplaceString,_G,ResUrl =
table,ErrorLog,print,NewObjectArr,cs_Base,Resources,EventType,File,ConstValue,ReplaceString,_G,ResUrl
local Loader,string,_G,error,io,CSLoader,CsIsNull,tostring,UploadError,os,AppearEvent,platform,debug = 
Loader,string,_G,error,io,CSLoader,CsIsNull,tostring,UploadError,os,AppearEvent,platform,debug
local mEventManager = require "LuaScript.Control.EventManager"
module("LuaScript.Mode.Object.Loader")

-- ÄÚÖÃÁÐ±í
mLoadingList = {}
mLoadingByUrlList = {}
mNewAssetList = {}

-- local mLogs = {}

-- function GetLogs()
	-- return table.concat(mLogs, "\n")
-- end

local f = io.open(ConstValue.ResPath.."newResList", "r")
if f then
	local newAssetName = f:read("*line")
	while(newAssetName) do
		mNewAssetList[newAssetName] = true
		newAssetName = f:read("*line")
	end
	f:close()
	
	mNewAssetList["GameObj/skill/21"] = nil
end
-- print(mNewAssetList)

Loader.Update = function()
	local count = #mLoadingList
	for i=count,1,-1 do
		local loader = mLoadingList[i]
		if loader.csLoader.isDone then
			if loader.csLoader.error then
				if _G.IsDebug then
					ErrorLog(loader.csLoader.error .. "\n" .. loader.url)
				end
			else
				_G.AppearEvent(loader.csLoader, EventType.Complete)
			end
			mLoadingByUrlList[loader.url] = nil
			table.remove(mLoadingList, i)
			
			
			-- print(loader.url)
			loader.csLoader:destroy()
			
			-- mEventManager.RemoveAllEveListen(loader.csLoader)
			-- print("ok")
		end
	end
end

Loader.Init = function(url, completeHandler, shieldError)
	-- print("Loader.Init", url, completeHandler, notSaveRes, reload)
	-- print(SaveResToLocal)
	local cs_args = nil
	local cs_Loader = nil
	local cs_Asset = nil
	-- local full_Url = GetFullUrl(url)
	local local_Url = GetLocalUrl(url)
	
	if mLoadingByUrlList[url] then
		cs_Loader = mLoadingByUrlList[url]
	elseif platform and mNewAssetList[url] then
		
		-- table.insert(mLogs, string.format("type=1   time=%s   url=%s",os.date("%x %X"),url))
		-- if #mLogs > 20 then
			-- table.remove(mLogs, 1)
		-- end
		
		if CSLoader then
			cs_Loader = CSLoader(local_Url, false)
			mLoadingByUrlList[url] = cs_Loader
		else
			cs_args = NewObjectArr(local_Url, false)
			cs_Loader = cs_Base:InitClass("HHLoader", cs_args)
			mLoadingByUrlList[url] = cs_Loader
		end
	else
		-- table.insert(mLogs, string.format("type=0   time=%s   url=%s",os.date("%x %X"),url))
		-- if #mLogs > 20 then
			-- table.remove(mLogs, 1)
		-- end
		
		cs_Asset = Resources.Load(url)
		if not cs_Asset and not shieldError then
			ErrorLog("NotFile Error!", url.."\n"..debug.traceback())
			_G.AppearEvent(nil, EventType.NotFile)
			return nil
		end
	end
	
	if cs_Loader then
		local loader = {csLoader=cs_Loader, url=url}
		table.insert(mLoadingList, loader)
		mLoadingByUrlList[url] = loader
	end
	
	if completeHandler then
		if cs_Loader then
			mEventManager.AddEventListen(cs_Loader, EventType.Complete, completeHandler, url)
		elseif cs_Asset then
			completeHandler({mainAsset=cs_Asset}, EventType.Complete, url)
		end
	end
	
	return cs_Loader,cs_Asset
end

Loader.Load = function(url, completeHandler, fullUrl)
	local full_Url = url
	if not fullUrl then
		full_Url = GetFullUrl(url)
	end
	
	local cs_Loader = nil
	if CSLoader then
		cs_Loader = CSLoader(full_Url, true)
	else
		local cs_args = NewObjectArr(full_Url, true)
		cs_Loader = cs_Base:InitClass("HHLoader", cs_args)
	end
	
	local loader = {csLoader=cs_Loader, url=url}
	table.insert(mLoadingList, loader)
	mLoadingByUrlList[url] = loader
	
	if completeHandler then
		mEventManager.AddEventListen(cs_Loader, EventType.Complete, completeHandler, url)
	end
	
	return cs_Loader
end

-- Loader.CompleteHandler = function (cs_Loader, handler, url)
	-- table.insert(Loader._handlerList, {cs_Loader=cs_Loader, handler=handler, url})
-- end

-- function SaveResToLocal(cs_Loader)
	-- local path = GetResPath(cs_Loader.url)
	-- File.WriteAllBytes(path, cs_Loader.bytes)
-- end

function GetFullUrl(path)
	return ResUrl .. path
end

function GetLocalUrl(path)
	return ConstValue.ResPath .. path
end

function GetResPath(path)
	path = ReplaceString(path, ConstValue.BaseUrl, ResUrl)
	-- path = ReplaceString(path, Loader._fileType, "")
	return path
end