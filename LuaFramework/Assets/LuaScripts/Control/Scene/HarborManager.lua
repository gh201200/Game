local GameObject,MeshFilter,Screen,MapTexture,File,Vector3,Vector2,cs_Base,Texture2D,print,os,Instantiate,tonumber = 
	GameObject,MeshFilter,Screen,MapTexture,File,Vector3,Vector2,cs_Base,Texture2D,print,os,Instantiate,tonumber
local math,Renderer,EventType,Camera,Input,require,GameObjectTag,pairs,CFG_harbor,type,ConstValue,PackatHead,table = 
math,Renderer,EventType,Camera,Input,require,GameObjectTag,pairs,CFG_harbor,type,ConstValue,PackatHead,table
local Packat_Harbor,ByteArray,Language,LogbookType,AppearEvent,error,CsSetPosition,GetTransform,CsSetActive,CsSetScale = 
Packat_Harbor,ByteArray,Language,LogbookType,AppearEvent,error,CsSetPosition,GetTransform,CsSetActive,CsSetScale
local CsSetScale,CFG_map,CFG_UniqueSailor,CsGetName,CsSetParent,Color,string,GetLength,ErrorLog,tostring,AssetType = 
CsSetScale,CFG_map,CFG_UniqueSailor,CsGetName,CsSetParent,Color,string,GetLength,ErrorLog,tostring,AssetType
local mEventManager = require "LuaScript.Control.EventManager"
local mHeroManager = nil
local mNetManager = nil
local mSystemTip = nil
local mLogbookManager = nil
local mGuideManager = nil
local mCameraManager = nil
local mCommonlyFunc = nil
local m3DTextManager = nil
local mAssetManager = nil
local mChatManager = nil
module("LuaScript.Control.Scene.HarborManager") -- 港口数据管理

local mCsHarborList = nil
local mHarborList = nil
local mActiveHarborList = {}
mActiveCsHarborById = nil

local mHarborInfoList = {}
local mSelfHarborList = {}
local mSelfHarborListById = {}

local mNewCount = 0

local mHarborBattleState = nil


local oldDrawIndex = -1

function Reset()
	mHarborInfoList = {}
	mSelfHarborList = {}
	mSelfHarborListById = {}
	mNewCount = 0
	mHarborBattleState = nil
end

function GetActiveCsHarbor(id)
	return mActiveCsHarborById[id]
end

function GetNewCount()
	return mNewCount
end

function GetSelfHarborList()
	return mSelfHarborList
end

function GetHarborBattleState()
	return mHarborBattleState or 0
end

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mLogbookManager = require "LuaScript.Control.Data.LogbookManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mGuideManager = require "LuaScript.Control.Data.GuideManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mChatManager = require "LuaScript.Control.Data.ChatManager"
	m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
	if not mHarborList then
		mHarborList = {{},{},{},{}}
	end
	mCsHarborList = GameObject.Find("HarborList")
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_HARBOR_INFO, SEND_HARBOR_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_MAIN_BUILDING_INFO, SEND_MAIN_BUILDING_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_SHIP_FAC_INFO, SEND_SHIP_FAC_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_SHOP_INFO, SEND_SHOP_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_LAB_INFO, SEND_LAB_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_ALL_HARBORS_BELONG_YOU, SEND_ALL_HARBORS_BELONG_YOU)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_REFRESH_HARBOR_INFO, SEND_REFRESH_HARBOR_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_HARBORWAR_STATE, SEND_HARBORWAR_STATE)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_HARBOR_TREASURE_STATE, SEND_HARBOR_TREASURE_STATE)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_ADD_HARBOR_BELONG_YOU, SEND_ADD_HARBOR_BELONG_YOU)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_DEL_HARBOR_BELONG_YOU, SEND_DEL_HARBOR_BELONG_YOU)
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
end

function OnMouseDown(cs_Harbor)
	-- print(cs_Harbor)
	local harbor = mActiveHarborList[cs_Harbor]
	-- mHeroManager.SetTarget(ConstValue.HarborType, harbor.id)
	mHeroManager.GotoHarbor(harbor.id)
end

function ConnectFailure() -- 链接失败
	mSelfHarborList = {}
	mSelfHarborListById = {}
end

function ClearAll()
	for cs_Harbor,v in pairs(mActiveHarborList) do
		CsSetActive(cs_Harbor,false)
		table.insert(mHarborList[v.resId], cs_Harbor)
		
		if v.csTitle then
			m3DTextManager.Destroy(v.csTitle)
			v.csTitle = nil
		end
	end
	mActiveHarborList = {}
	mActiveCsHarborById = {}
	oldDrawIndex = -1
end

function GetHarborsList()
	return mActiveHarborList
end

function UpdatePosition(map, x, y)
	-- print(1111111111)
	local drawRowIndex = math.floor(x / MapTexture.width * 2.1)
	local drawColIndex = math.floor(y / MapTexture.height * 2.1)
	-- print(map, x, y)
	if oldDrawIndex ~= drawRowIndex + drawColIndex * 10000 then
		oldDrawIndex = drawRowIndex + drawColIndex * 10000
		InitHarbors(map, x, y)
	end
end

function InitHarbors(map, x, y)
	local x_dis = Screen.DefaultWidth/2 + MapTexture.width / 2
	-- local x_max = x + Screen.DefaultWidth/2 + MapTexture.width / 2
	local y_min = y - Screen.DefaultHeight/2 - MapTexture.height
	local y_max = y + Screen.DefaultHeight/2 + MapTexture.height / 2
	local mapWidth = CFG_map[map].width

	-- local activeList = {}
	
	for cs_Harbor,v in pairs(mActiveHarborList) do
		-- if v.mapId == map and mCommonlyFunc.LoopDis(v.x,x,mapWidth) < x_dis and v.y < y_max and v.y > y_min then
			-- activeList[cs_Harbor] = v
			-- mActiveCsHarborById[v.id] = cs_Harbor
		-- else
			CsSetActive(cs_Harbor,false)
			-- CsSetParent(GetTransform(cs_Harbor), GetTransform(mCsHarborList))
			table.insert(mHarborList[v.resId], cs_Harbor)
			if v.csTitle then
				m3DTextManager.Destroy(v.csTitle)
				v.csTitle = nil
			end
		-- end
	end
	mActiveCsHarborById = {}
	mActiveHarborList = {}
	
	-- print(#mHarborList[1])
	-- print(mActiveCsHarborById)
	
	-- print(mActiveCsHarborById)
	-- local index = 1
	local hero = mHeroManager.GetHero()
	for k,v in pairs(CFG_harbor) do
		if v.mapId == map and mCommonlyFunc.LoopDis(v.x,x,mapWidth) < x_dis and v.y < y_max and v.y > y_min then
			ShowHarbor(mHarborInfoList[v.id], v)
			RequestHarborInfo(v.id)
		end
	end
	
	-- print(#mHarborList[1].."over")
	
	-- print(mActiveCsHarborById)

end

function GetHarborInfoList()
	return mHarborInfoList
end

function GetHarborInfo(harborId)
	return mHarborInfoList[harborId]
end

function GetBuildLevel(harborId, buildId)
	local harborInfo = mHarborInfoList[harborId]
	if harborInfo and harborInfo.buildInfos[buildId] then
		return harborInfo.buildInfos[buildId].level
	end
	local cfg_Harbor = CFG_harbor[harborId]
	return cfg_Harbor.level
end

function GetShipyardLevel()
	local hero = mHeroManager.GetHero()
	local harborInfo = mHarborInfoList[hero.harborId]
	local cfg_harbor = CFG_harbor[hero.harborId]
	local level = cfg_harbor.level
	if harborInfo and harborInfo.buildInfos and harborInfo.buildInfos[2] then
		level = harborInfo.buildInfos[2].level
	end
	return level
end

function GetHarborLevel(harborId)
	local harborInfo = mHarborInfoList[harborId]
	local cfg_harbor = CFG_harbor[harborId]
	local level = cfg_harbor.level
	if harborInfo and harborInfo.buildInfos and harborInfo.buildInfos[1] then
		level = harborInfo.buildInfos[1].level
	end
	return level
end

function GetShopLevel(harborId)
	local harborInfo = mHarborInfoList[harborId]
	local cfg_harbor = CFG_harbor[harborId]
	local level = cfg_harbor.level
	if harborInfo and harborInfo.buildInfos and harborInfo.buildInfos[1] then
		level = harborInfo.buildInfos[4].level
	end
	return level
end

function GetHarborMasterName(harborId)
	if HarborIsMy(harborId) then
		local hero = mHeroManager.GetHero()
		if HarborIsMy(harborId).type == 0 then
			return hero.name
		else
			return hero.familyName
		end
		return
	end
	
	local harborInfo = mHarborInfoList[harborId]
	if harborInfo and harborInfo.masterId ~= 0 then
		return harborInfo.masterName
	else
		RequestHarborInfo(harborId)
		local cfg_harbor = CFG_harbor[harborId]
		local cfg_UniqueSailor = CFG_UniqueSailor[cfg_harbor.masterId] or CFG_UniqueSailor[6]
		if cfg_UniqueSailor then
			return cfg_UniqueSailor.name
		else
			return ""
		end
	end
end


function GetNearHarbor(selfHarbor)
	local harborId = GetNearHarborInList(mActiveHarborList, selfHarbor)
	if harborId then
		return harborId
	end
	return GetNearHarborInList(CFG_harbor, selfHarbor)
end

function GetNearHarborInList(list, selfHarbor)
	local minDis = 9999999
	local hero = mHeroManager.GetHero()
	local mapWidth = CFG_map[hero.map].width
	local harborId = nil
	
	for k,cfg_harbor in pairs(list) do
		if not selfHarbor or HarborIsMy(cfg_harbor.id) then
			local dis = mCommonlyFunc.LoopDis(cfg_harbor.x,hero.x,mapWidth)+math.abs(hero.y-cfg_harbor.y)
			if cfg_harbor.mapId ~= hero.map then
				dis = dis + 1000000
			end
			
			if dis < minDis then
				minDis = dis
				harborId = cfg_harbor.id
			end
		end
	end
	return harborId
end

function GetMaxLevelSelfHarborId()
	local level = 0
	local harborId = 0
	local hero = mHeroManager.GetHero()
	for k,v in pairs(mSelfHarborListById) do
		local cfg_harbor = CFG_harbor[k]
		local harborInfo = GetHarborInfo(k)
		if cfg_harbor.mapId == 2 and 
		-- if (harborInfo.masterType == 0 or (harborInfo.masterType == 1 and hero.post >= 2)) and 
			v.level > level  then
			level = v.level
			harborId = k
		end
	end
	return harborId
end

function GetHeroDis(harborId)
	local hero = mHeroManager.GetHero()
	local mapWidth = CFG_map[hero.map].width
	local cfg_harbor = CFG_harbor[harborId]
	local dis = mCommonlyFunc.LoopDis(cfg_harbor.x,hero.x,mapWidth)+math.abs(hero.y-cfg_harbor.y)
	return dis
end

function HarborIsMy(harborId)
	local hero = mHeroManager.GetHero()
	harborId = harborId or hero.harborId
	return mSelfHarborListById[harborId]
end

-- function HarborIsMyControl()
	-- local hero = mHeroManager.GetHero()
	-- local harborInfo = GetHarborInfo(harborId)
	-- if mSelfHarborListById[harborId] and (harborInfo.masterType == 0 or (harborInfo.masterType == 1 and hero.post >= 2)) then
		-- return true
	-- end
-- end

function RequestHarborInfo(harborId)
	if mHarborInfoList[harborId] or mHarborInfoList[-harborId] then
		return
	end
	-- print("RequestHarborInfo")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_HARBOR_INFO)
	ByteArray.WriteInt(cs_ByteArray,harborId)
	mNetManager.SendData(cs_ByteArray)
	mHarborInfoList[-harborId] = true
end

function SEND_HARBOR_INFO(cs_ByteArray)
	-- print("SEND_HARBOR_INFO")
	local harborInfo = {}
	harborInfo.id = ByteArray.ReadInt(cs_ByteArray)
	harborInfo.buildInfos = {}
	-- print(harborInfo.id)
	-- main
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	harborInfo.buildInfos[1] = {level=level, cd=cd, updateTime=os.oldClock}
	
	-- shipyard
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	harborInfo.buildInfos[2] = {level=level, cd=cd, updateTime=os.oldClock}
	
	-- shop
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	harborInfo.buildInfos[4] = {level=level, cd=cd, updateTime=os.oldClock}
	
	-- lab
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	harborInfo.buildInfos[3] = {level=level, cd=cd, updateTime=os.oldClock}
	
	harborInfo.masterId = ByteArray.ReadInt(cs_ByteArray)
	harborInfo.masterName = ByteArray.ReadUTF(cs_ByteArray,40)
	harborInfo.masterType = ByteArray.ReadByte(cs_ByteArray)
	
	mHarborInfoList[harborInfo.id] = harborInfo
	
	AppearEvent(nil, EventType.HarborInfo, harborInfo.id)
end

function ShowHarbor(harborInfo, cfg_harbor)
	-- print("ShowHarbor")
	local cs_Harbor = GetCsHarbor(cfg_harbor.resId)
	mActiveHarborList[cs_Harbor] = cfg_harbor
	mActiveCsHarborById[cfg_harbor.id] = cs_Harbor
	
	local viewX,viewY = mCameraManager.GetView()
	local mapWidth = CFG_map[cfg_harbor.mapId].width
	local _,x = mCommonlyFunc.LoopVector(cfg_harbor.showX,viewX,mapWidth)
	
	CsSetPosition(GetTransform(cs_Harbor), x,50,cfg_harbor.showY)
	-- CsSetScale(GetTransform(cs_Harbor),cfg_harbor.scale,cfg_harbor.scale,cfg_harbor.scale)
	
	CsSetActive(cs_Harbor,true)
	
	local str = string.format("%s%s%s", mCommonlyFunc.NGUIBeginColor(Color.SimpleYellowStr), cfg_harbor.name, mCommonlyFunc.NGUIEndColor())
	cfg_harbor.csTitle = cfg_harbor.csTitle or m3DTextManager.Get3DText(str)
	if cfg_harbor.csTitle then
		m3DTextManager.SetPosition(cfg_harbor.csTitle, x, 105, cfg_harbor.showY)
	end
end

function GetCsHarbor(resId)
	-- print(resId)
	if #mHarborList[resId] > 0 then
		return table.remove(mHarborList[resId], 1)
	else
		local path = string.format(ConstValue.ResHarborPath, resId)
		local csAsset = Instantiate(mAssetManager.GetAsset(path, AssetType.Ship))
		mEventManager.AddEventListen(csAsset, EventType.OnMouseDown, OnMouseDown)
		CsSetParent(GetTransform(csAsset), GetTransform(mCsHarborList))
		return csAsset
		-- CsSetScale(GetTransform(csShip), scale, scale, scale)
	end
end

function SEND_MAIN_BUILDING_INFO(cs_ByteArray)
	-- print("SEND_MAIN_BUILDING_INFO")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	local harborInfo = mHarborInfoList[harborId]
	-- print(harborId, level, cd)
	if cd <= 0 then
		local cfg_harbor = CFG_harbor[harborId]
		local infoStr = cfg_harbor.name..Language[147]..Language[19]..Language[115]..Language[148]
		mChatManager.AddServerMsg(infoStr)
		infoStr = infoStr .. "," .. Language[149] .. level
		mSystemTip.ShowTip(infoStr, Color.LimeStr)
		
		mLogbookManager.AddLog(LogbookType.Build, os.oldTime, harborId, 1,level)
	end
	
	if mSelfHarborListById[harborId] then
		mSelfHarborListById[harborId].level = level
	end
	
	if not harborInfo then
		return
	end
	-- harborInfo.mainLevel = level
	-- harborInfo.mainCD = cd
	-- harborInfo.mainUpdateTime = os.oldClock
	
	harborInfo.buildInfos[1] = {level=level, cd=cd, updateTime=os.oldClock}
	
	AppearEvent(nil, EventType.CheckAllTask)
end

function SEND_SHIP_FAC_INFO(cs_ByteArray)
	-- print("SEND_SHIP_FAC_INFO")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	local harborInfo = mHarborInfoList[harborId]
	if cd <= 0 then
		local cfg_harbor = CFG_harbor[harborId]
		local infoStr = cfg_harbor.name..Language[147]..Language[20]..Language[115]..Language[148]
		infoStr = infoStr .. "," .. Language[149] .. level
		mSystemTip.ShowTip(infoStr, Color.LimeStr)
		
		mLogbookManager.AddLog(LogbookType.Build, os.oldTime, harborId, 2,level)
	end
	if not harborInfo then
		return
	end
	
	harborInfo.buildInfos[2] = {level=level, cd=cd, updateTime=os.oldClock}
	
	AppearEvent(nil, EventType.CheckAllTask)
end

function SEND_SHOP_INFO(cs_ByteArray)
	-- print("SEND_SHOP_INFO")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	local harborInfo = mHarborInfoList[harborId]
	-- print(harborId, level, cd)
	if cd <= 0 then
		local cfg_harbor = CFG_harbor[harborId]
		local infoStr = cfg_harbor.name..Language[147]..Language[18]..Language[115]..Language[148]
		infoStr = infoStr .. "," .. Language[149] .. level
		mSystemTip.ShowTip(infoStr, Color.LimeStr)
		
		mLogbookManager.AddLog(LogbookType.Build, os.oldTime, harborId, 3,level)
	end
	
	if mSelfHarborListById[harborId] then
		mSelfHarborListById[harborId].shopLevel = level
	end
	
	if not harborInfo then
		return
	end
	
	harborInfo.buildInfos[4] = {level=level, cd=cd, updateTime=os.oldClock}
	
	AppearEvent(nil, EventType.CheckAllTask)
end

function SEND_ALL_HARBORS_BELONG_YOU(cs_ByteArray)
	-- print("SEND_ALL_HARBORS_BELONG_YOU")
	
	local count = ByteArray.ReadShort(cs_ByteArray)
	for i=1,count do
		local id = ByteArray.ReadShort(cs_ByteArray)
		local level = ByteArray.ReadByte(cs_ByteArray)
		local type = ByteArray.ReadByte(cs_ByteArray)
		local shopLevel = ByteArray.ReadByte(cs_ByteArray)
		local income = ByteArray.ReadBool(cs_ByteArray)
		local harbor = {id=id, level=level,type=type,shopLevel=shopLevel,income=income}
		mSelfHarborListById[id] = harbor
		
		RequestHarborInfo(id)
	end
	
	mNewCount = 0
	mSelfHarborList = {}
	for k,v in pairs(mSelfHarborListById) do
		if v.income then
			mNewCount = mNewCount + 1
		end
		table.insert(mSelfHarborList, v)
	end
	
	table.sort(mSelfHarborList, sortFunc)
	-- print(mSelfHarborList)
	-- mSelfHarborCount = #mSelfHarborList
end

function sortFunc(a, b)
	if a.income and not b.income then
		return true
	end
	
	if not a.income and b.income then
		return false
	end
	return a.level > b.level
end

function SEND_REFRESH_HARBOR_INFO(cs_ByteArray)
	-- print("SEND_REFRESH_HARBOR_INFO")
	local harborId = ByteArray.ReadShort(cs_ByteArray)
	mHarborInfoList[harborId] = nil
	mHarborInfoList[-harborId] = nil
end

function SEND_HARBORWAR_STATE(cs_ByteArray)
	-- print("SEND_HARBORWAR_STATE")
	mHarborBattleState = ByteArray.ReadByte(cs_ByteArray)
end

function SEND_HARBOR_TREASURE_STATE(cs_ByteArray)
	-- print("SEND_HARBOR_TREASURE_STATE")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local income = ByteArray.ReadBool(cs_ByteArray)
	
	if mSelfHarborListById[id] then
		local oldValue = mSelfHarborListById[id].income
		mSelfHarborListById[id].income = income
		table.sort(mSelfHarborList, sortFunc)
		
		if oldValue ~= income and income then
			mNewCount = mNewCount + 1
		elseif oldValue ~= income and not income then
			mNewCount = mNewCount - 1
		end
		AppearEvent(nil,EventType.CheckAllTask)
		-- print(mSelfHarborList[id].income)
	end
end

function SEND_ADD_HARBOR_BELONG_YOU(cs_ByteArray)
	-- print("SEND_ADD_HARBOR_BELONG_YOU")
	local id = ByteArray.ReadShort(cs_ByteArray)
	local level = ByteArray.ReadByte(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local shopLevel = ByteArray.ReadByte(cs_ByteArray)
	local income = ByteArray.ReadBool(cs_ByteArray)
	
	if type ~= 0 then
		income = false
	end
	local harbor = {id=id, level=level,type=type,shopLevel=shopLevel,income=income}
	mSelfHarborListById[id] = harbor
	table.insert(mSelfHarborList, harbor)
	
	if income then
		mNewCount = mNewCount + 1
	end
	
	table.sort(mSelfHarborList, sortFunc)
end

function DelFamilyHarbor()
	local count = #mSelfHarborList
	for i=count,1,-1 do
		local harbor = mSelfHarborList[i]
		if harbor.type ~= 0 then
			table.remove(mSelfHarborList, i)
			mSelfHarborListById[harbor.id] = nil
		end
	end
end

function SEND_DEL_HARBOR_BELONG_YOU(cs_ByteArray)
	-- print("SEND_DEL_HARBOR_BELONG_YOU")
	local id = ByteArray.ReadShort(cs_ByteArray)
	local harbor = mSelfHarborListById[id]
	for k,v in pairs(mSelfHarborList) do
		if v == harbor then
			table.remove(mSelfHarborList, k)
			break
		end
	end
	mSelfHarborListById[id] = nil
	
	if harbor and harbor.income then
		mNewCount = mNewCount - 1
	end
end

function SEND_LAB_INFO(cs_ByteArray)
	-- print("SEND_LAB_INFO")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local level = ByteArray.ReadInt(cs_ByteArray)
	local cd = ByteArray.ReadInt(cs_ByteArray)
	local harborInfo = mHarborInfoList[harborId]
	-- print(harborId, level, cd)
	if cd <= 0 then
		local cfg_harbor = CFG_harbor[harborId]
		local infoStr = cfg_harbor.name..Language[147]..Language[112]..Language[115]..Language[148]
		infoStr = infoStr .. "," .. Language[149] .. level
		mSystemTip.ShowTip(infoStr, Color.LimeStr)
		
		mLogbookManager.AddLog(LogbookType.Build, os.oldTime, harborId, 4,level)
	end
	if not harborInfo then
		return
	end
	harborInfo.buildInfos[3] = {level=level, cd=cd, updateTime=os.oldClock}
end

-- function IsMaster(harborId, id)
	-- local hero = mHeroManager.GetHero()
	-- id = id or hero.id
	-- harborId = harborId or hero.harborId
	
	-- if mHarborInfoList[harborId] then
		-- return mHarborInfoList[harborId].masterId == id
	-- end
	-- return false
-- end

function RequestIntoHarbor(harborId)
	-- print("RequestIntoHarbor" .. harborId )
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_ENTER_HARBOR)
	ByteArray.WriteInt(cs_ByteArray,harborId)
	mNetManager.SendData(cs_ByteArray)
	mGuideManager.SetStopGuide(true)
end

function RequestLeaveHarbor()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_LEAVE_HARBOR)
	mNetManager.SendData(cs_ByteArray)
	
	-- mSystemTip.ShowTip("食物补充完成", Color.LimeStr)
end

function RequestSignupInfo()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_GET_SIGNUP_INFO)
	mNetManager.SendData(cs_ByteArray)
end

function RequestCancelSignup(harborId, type)
	print("RequestCancelSignup")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_CANCEL_SIGNUP)
	ByteArray.WriteInt(cs_ByteArray,harborId)
	ByteArray.WriteByte(cs_ByteArray,type)
	mNetManager.SendData(cs_ByteArray)
end

function RequestCloseSignup()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_CLOSE_SIGNUP_FORM)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSignup(type, harborId, money)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_SIGNUP)
	ByteArray.WriteByte(cs_ByteArray,type)
	ByteArray.WriteInt(cs_ByteArray,harborId)
	ByteArray.WriteInt(cs_ByteArray,money)
	mNetManager.SendData(cs_ByteArray)
end

function RequestHarborBattleState()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_HARBORWAR_STATE)
	mNetManager.SendData(cs_ByteArray)
end

function RequestGetIncome(harborId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_GET_HARBOR_TREASURE)
	ByteArray.WriteInt(cs_ByteArray,harborId)
	mNetManager.SendData(cs_ByteArray)
end