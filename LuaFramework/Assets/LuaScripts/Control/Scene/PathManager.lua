local CFG_path_point,CFG_path_line,table,pairs,print,PathFindManager,File,cs_Base,CSInt32,os,SceneType,require = 
CFG_path_point,CFG_path_line,table,pairs,print,PathFindManager,File,cs_Base,CSInt32,os,SceneType,require
local Resources,CFG_map,EventType,AppearEvent,AssetType,CsFindPath,math,CsAddPathPoint,CsAddPathLine,pcall =
Resources,CFG_map,EventType,AppearEvent,AssetType,CsFindPath,math,CsAddPathPoint,CsAddPathLine,pcall
local tostring,debug,UploadError = tostring,debug,UploadError
local mEventManager = require "LuaScript.Control.EventManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHeroManager = nil
local mSystemTip = nil

module("LuaScript.Control.Scene.PathManager")

-- local PathNet = nil
cs_PathFindManager = PathFindManager.New()
local mPathBytesList = {}
-- local mMapId = 1

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	local hero = mHeroManager.GetHero()
	local cfg_map = CFG_map[hero.map]
	if cfg_map.showImage == 0 then
		IsInit = true
		AppearEvent(nil, EventType.OnPathComplete)
	else
		local asset = mAssetManager.GetAsset("map/"..hero.map.."/path", nil, PathCompleteFunc)
		if mPathBytesList[hero.map] or asset then
			PathCompleteFunc()
		end
	end
end

function CouldWalk(x,y,map)
	-- print(x,y)
	if y > 15131 or y <= 0 then
		return
	end
	
	if map == 1 then
		if x > 50 and x < 1500 and y > 50 and y < 1060 then
			return true
		else
			return false
		end
	end
	
	
	local cs_ByteArray = mPathBytesList[map]
	if not cs_ByteArray then
		local cs_TextAsset = mAssetManager.GetAsset("map/"..map.."/path")
		if not cs_TextAsset then
			mSystemTip.ShowTip("地图数据未初始化完成")
			return
		end
		-- print("bug!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		cs_ByteArray = cs_TextAsset.bytes
		mPathBytesList[map] = cs_ByteArray 
	end
	local cfg_map = CFG_map[map]
	local index = math.floor(x / 8) + math.floor(y /1.4142 / 8) * cfg_map.width / 8
	return cs_ByteArray[index] == 0
end

-- function GetValue(cs_ByteArray, index)
	-- return cs_ByteArray:GetValue(index) == 0
-- end

function PathCompleteFunc()
	local hero = mHeroManager.GetHero()
	local cs_ByteArray = mPathBytesList[hero.map]
	
	if not cs_ByteArray then
		local cs_TextAsset = mAssetManager.GetAsset("map/"..hero.map.."/path")
		-- print("bug!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		cs_ByteArray = cs_TextAsset.bytes
	end
	
	mPathBytesList[hero.map] = cs_ByteArray 
	
	local cfg_map = CFG_map[hero.map]
	cs_PathFindManager:SetGrid(cs_ByteArray,cfg_map.width, cfg_map.height, cfg_map.loop)
	InitPathNet(hero.map)
	
	IsInit = true
	AppearEvent(nil, EventType.OnPathComplete)
end

function FindPath(fromX, fromY, toPointX, toPointY)
	if not IsInit then
		return
	end
	-- print(toPoint)
	local hero = mHeroManager.GetHero()
	local cfg_map = CFG_map[hero.map]
	local t = nil
	if cfg_map.showImage == 1 then
		t = CsFindPath(fromX, fromY/1.4142, toPointX, toPointY/1.4142)
		if not t then
			return
		end
		for i=2,#t,2 do
			t[i] = t[i]*1.4142
		end
	else
		t = {toPointX, toPointY}
	end
	return t
end

-- function NearPathPoint(point)
	-- local nearPoint = nil
	-- local nearDis = 0
	-- for k,v in pairs(CFG_path_point) do
		-- local disX = v.x - point.x
		-- local disY = v.y - point.y
		-- local dis = disX*disX + disY*disY
		-- if not nearPoint or nearDis > dis then
			-- nearPoint = v
			-- nearDis = dis
		-- end
	-- end
	-- return nearPoint
-- end

-- function FindPathWay(fromPathPoint, toPathPoint)
	-- if not PathNet then
		-- InitPathNet()
	-- end

	-- local way = {}
	-- local openWay = {{fromPathPoint.id}}
	-- local deep = 1
	-- local fatherWayList = {}
	-- local i = 0
	-- while true do
		-- openWay[deep+1] = {}
		-- for _,pointId in pairs(openWay[deep]) do
			-- for _,PathNetPoint in pairs(PathNet[pointId].NearPoint) do
				-- i = i + 1
				-- if PathNetPoint.Point == toPathPoint then
					-- table.insert(way, PathNetPoint.Point.x / 4)
					-- table.insert(way, PathNetPoint.Point.y / 4)
					-- local curId = PathNetPoint.Point.id
					-- print(curId)
					-- fatherWayList[PathNetPoint.Point.id] = pointId
					
					-- while true do
						-- table.insert(way, CFG_path_point[fatherWayList[curId]].x / 4)
						-- table.insert(way, CFG_path_point[fatherWayList[curId]].y / 4)
						-- if fatherWayList[curId] and CFG_path_point[fatherWayList[curId]] ~= fromPathPoint then
							-- curId = fatherWayList[curId]
						-- else
							-- return way
						-- end
					-- end
				-- elseif not fatherWayList[PathNetPoint.Point.id] then
					-- fatherWayList[PathNetPoint.Point.id] = pointId
					-- table.insert(openWay[deep+1], PathNetPoint.Point.id)
				-- end
			
			-- end
		-- end
		-- deep = deep + 1
		-- if #openWay[deep] == 0 then
			-- break
		-- end
	-- end
-- end

function InitPathNet(mapId)
	cs_PathFindManager:ClearPointAndLine()
	for k,v in pairs(CFG_path_point) do
		if v.map == mapId then
			CsAddPathPoint(v.id, v.x/8, v.y/8)
		end
	end
	for k,v in pairs(CFG_path_line) do
		if v.map == mapId then
			CsAddPathLine(v.startPoint, v.endPoint, v.reverse==1)
		end
	end
end