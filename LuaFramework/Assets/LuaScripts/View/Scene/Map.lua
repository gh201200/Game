local GameObject,MeshFilter,Screen,MapTexture,File,Vector3,Vector2,cs_Base,Texture2D,print,os,Instantiate,Destroy = 
	GameObject,MeshFilter,Screen,MapTexture,File,Vector3,Vector2,cs_Base,Texture2D,print,os,Instantiate,Destroy
local math,Renderer,EventType,Camera,Input,require,Resources,CFG_map,AppearEvent,AssetType,table,CsSetParent = 
math,Renderer,EventType,Camera,Input,require,Resources,CFG_map,AppearEvent,AssetType,table,CsSetParent
local Time,CsSetPosition,GetTransform,CsSetActive,CsSetScale,CsSetMainTexture,CsGetValue,pairs,GUI,CFG_MapWave = 
Time,CsSetPosition,GetTransform,CsSetActive,CsSetScale,CsSetMainTexture,CsGetValue,pairs,GUI,CFG_MapWave
local string,ConstValue,RunStaticFunc,VersionName,CsGetTouchInfo = string,ConstValue,RunStaticFunc,VersionName,CsGetTouchInfo
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mHeroManager = nil
local mCharManager = nil
local mCameraManager = nil
local mTargetManager = nil
local mMoveManager = nil
local mBattleFieldManager = nil
module("LuaScript.View.Scene.Map")
local cs_ImageList = {}
-- local drawImageList = nil
local oldDrawIndex = -1
local cs_map = nil
local cs_mapTransform = nil
local csMeshMaterialList = nil
local csMeshList = nil

local drawRowCount = 3
local drawColCount = 3

local mNeedLoadList = nil
local mMapTextureList = {}
local mUsingTextureList = {}

local showX = 0
local showY = 0

local csClickPoint = nil
local mStartTouch = false
local mLastTouchTime = 0
local mCsWaterSimple = nil
local mActive = false
local mAutoBusinessManager = false

local mCommand = nil
local mSeekTreasurePanel = nil

--
local mMapWaveList = {} 
local mFreeMapWaveList = {} 
local mCsMapWaveList = nil
local mMapStarX = 0
local mMapStarY = 0

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	mAutoBusinessManager = require "LuaScript.Control.Data.AutoBusinessManager"
	mMoveManager = require "LuaScript.Control.Scene.MoveManager"
	mTargetManager = require "LuaScript.Control.Scene.TargetManager"
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	mSeekTreasurePanel = require "LuaScript.View.Panel.SeekTreasure.SeekTreasurePanel"
	
	cs_map = GameObject.Find("Map")
	mCsMapWaveList = GameObject.Find("MapWaveList")
	cs_mapTransform = cs_map.transform
	CsSetScale(cs_mapTransform,MapTexture.width,1,MapTexture.height)
	
	csMeshList = csMeshList or {}
	csMeshMaterialList = csMeshMaterialList or {}
	for i=0,8,1 do
		local csMesh = cs_mapTransform:GetChild(i).gameObject
		csMeshList[i] = csMesh
		csMeshMaterialList[i] = csMesh.renderer.material
	end
	mEventManager.AddEventListen(nil, EventType.IntoNormalScene, IntoNormalScene)
	mEventManager.AddEventListen(nil, EventType.IntoBattleScene, IntoBattleScene)
	mEventManager.AddEventListen(cs_map,EventType.OnMouseDown, OnMouseDown)
	mEventManager.AddEventListen(cs_map,EventType.OnMouseUp, OnMouseUp)
	mEventManager.AddEventListen(nil, EventType.OnLoadComplete, OnLoadComplete)
	CsSetActive(cs_map,false)
end

function IntoNormalScene()
	csMeshList[1].layer = 4
	csMeshList[2].layer = 4
	csMeshList[3].layer = 4
	csMeshList[4].layer = 4
	csMeshList[5].layer = 4
	csMeshList[6].layer = 4
	csMeshList[7].layer = 4
	csMeshList[8].layer = 4
end

function IntoBattleScene()
	csMeshList[1].layer = 0
	csMeshList[2].layer = 0
	csMeshList[3].layer = 0
	csMeshList[4].layer = 0
	csMeshList[5].layer = 0
	csMeshList[6].layer = 0
	csMeshList[7].layer = 0
	csMeshList[8].layer = 0
end

function SetCommand(command)
	mCommand = command
end

function GetCommand(command)
	return mCommand
end

function OnLoadComplete()
	mCommand = nil
end

function Update()
	if mNeedLoadList then
		mAssetManager.GetAsset(mNeedLoadList[1], AssetType.Map)
		mMapTextureList[mNeedLoadList[1]] = true
		
		table.remove(mNeedLoadList, 1)
		
		if not mNeedLoadList[1] then
			mNeedLoadList = nil
			MapImageCompleteFunc()
			
			UnloadAsset()
		end
	end
end

function UnloadAsset()
    -- local mTreasureKey =  mSeekTreasurePanel.GetTreasureKey()
	for key,_ in pairs(mMapTextureList) do
		if not mUsingTextureList[key] then
			mAssetManager.UnloadAsset(key)
		end
	end
end

function Show()
	local hero = mHeroManager.GetHero()
	local cfg_map = CFG_map[hero.map]
	if cfg_map.showImage == 0 then
		ImageListCompleteFunc()
	else
		local cs_TextAsset = mAssetManager.GetAsset(string.format("map/%d/imageList",hero.map), AssetType.Map, ImageListCompleteFunc, true)
		if cs_TextAsset then
			ImageListCompleteFunc()
		end
	end
	mActive = true
end

function ImageListCompleteFunc()
	local hero = mHeroManager.GetHero()
	if not cs_ImageList[hero.map] then
		local cs_TextAsset = mAssetManager.GetAsset(string.format("map/%d/imageList",hero.map), AssetType.Map, nil, true)
		if cs_TextAsset then
			cs_ImageList[hero.map] = cs_TextAsset.bytes
		end
	end
	
	CsSetActive(cs_map,true)
	IsInit = true
	
	AppearEvent(nil, EventType.OnMapComplete)
end

function ClearAll()
	oldDrawIndex = -1
	if cs_map then
		CsSetActive(cs_map,false)
	end
	mStartTouch = false
	csClickPoint = nil
	mActive = false
end

function DisableMove()
	mStartTouch = false
	csClickPoint = nil
	mHeroManager.StopMove()
end

function OnMouseDown(cs_GameObj)
	-- print(OnMouseDown)
	-- print(cs_GameObj)
	local csVector3 = Input.GetMousePosition()
	csClickPoint = mCameraManager.ScreenPointToWorld(csVector3.x,csVector3.y)
	
	mStartTouch = true
	--print("on mouse down")
end

function OnMouseUp(cs_GameObj)
	-- print(OnMouseDown)
	-- print(cs_GameObj)
	mStartTouch = false
end


function FixUpdate()
	local hero = mHeroManager.GetHero()
	if not mActive then
		return
	end
	if GUI.EventRepaint then
		return
	end
	if not hero.ships or not hero.ships[1] then
		return
	end
	
	if mStartTouch and Input.GetTouchCount() > 0 and os.oldClock - mLastTouchTime > 0.3 then
		local toucheX,toucheY = CsGetTouchInfo(0)
		csClickPoint = mCameraManager.ScreenPointToWorld(toucheX, toucheY)
		mLastTouchTime = os.oldClock
	end
	
	if not csClickPoint then
		return
	end
	
	local x = csClickPoint.x
	local y = csClickPoint.z
	if mCommand then
		mBattleFieldManager.RequestCommand(mCommand, x, y, hero.team, hero.name)
		mCommand = nil
		csClickPoint = nil
		return
	end
	
	-- local mToPoint = {x = x, y = y}
	mHeroManager.SetTarget(nil, nil)
	mHeroManager.Goto(hero.map, x, y)
	-- print(mHeroManager.IsMoving())
	if mHeroManager.IsMoving() then
		mTargetManager.Show(x, y)
	end
	
	mAutoBusinessManager.StopAutoBusiness()
	csClickPoint = nil
end

function UpdatePosition(map, x, y)
	if not IsInit then
		return
	end
	
	-- local cfg_map = CFG_map[map]
	-- if cfg_map.showImage == 0 then
		-- return
	-- end
	
	local drawRowIndex = math.floor(x / MapTexture.width)
	local drawColIndex = math.floor(y / MapTexture.height)
	if oldDrawIndex == drawRowIndex + drawColIndex * 10000 then
		return
	end
	
	showX = x
	showY = y
	
	oldDrawIndex = drawRowIndex + drawColIndex * 10000
	
	CalculateAsset(map, x, y)
end

function ChangeAllX(value)
	local viewX,viewY = mCameraManager.GetView()
	CsSetPosition(GetTransform(cs_map), 
				math.floor(viewX / MapTexture.width - 1) * MapTexture.width + value,
				-0.05,
				math.floor(viewY / MapTexture.height - 1) * MapTexture.height)
				
	for k,cs_wave in pairs(mMapWaveList) do
		local position = GetTransform(cs_wave).position
		CsSetPosition(GetTransform(cs_wave),position.x + value, position.y, position.z)
	end
end

function CalculateAsset(map, x, y)
	local cfg_map = CFG_map[map]
	if cfg_map.showImage == 0 then
		MapImageCompleteFunc()
		return
	end
	if not cs_ImageList[map] then
		return
	end
	local mapWidthTextureCount = CFG_map[map].width / MapTexture.width
	local mapHeightTextureCount = math.ceil(CFG_map[map].height / MapTexture.height)
	local drawRowIndex = (math.floor(x / MapTexture.width) - math.floor(drawRowCount/2) + mapWidthTextureCount ) % mapWidthTextureCount
	local drawColIndex = (math.floor(y / MapTexture.height) - math.floor(drawColCount/2)+ mapHeightTextureCount ) % mapHeightTextureCount
	
	mNeedLoadList = nil
	mUsingTextureList = {}
	for i = drawRowIndex, drawRowCount + drawRowIndex - 1, 1 do
		for j = drawColIndex, drawColCount + drawColIndex - 1, 1 do
			local ii = i % mapWidthTextureCount
			local jj = j % mapHeightTextureCount
			
			local index = ii + jj * mapWidthTextureCount
			if CsGetValue(cs_ImageList[map],index) == 1 then
				local url = string.format("map/%d/%d_%d", map,ii,jj)
				mUsingTextureList[url] = true
				if not mAssetManager.HaveAsset(url) then
					mNeedLoadList = mNeedLoadList or {}
					table.insert(mNeedLoadList, url)
				end
			end
		end
	end
	
	if mNeedLoadList == nil then
		MapImageCompleteFunc()
	end
end

function drawMap(map, x, y)
	-- print(map, x, y)
	local cfg_map = CFG_map[map]
	local mapWidthTextureCount = cfg_map.width / MapTexture.width
	local mapHeightTextureCount = math.ceil(cfg_map.height / MapTexture.height)
	local drawRowIndex = 0
	local drawColIndex = 0
	if cfg_map.loop == 1 then
		drawRowIndex = (math.floor(x / MapTexture.width) - math.floor(drawRowCount/2) + mapWidthTextureCount ) % mapWidthTextureCount
		drawColIndex = (math.floor(y / MapTexture.height) - math.floor(drawColCount/2)+ mapHeightTextureCount ) % mapHeightTextureCount
	else
		drawRowIndex = math.floor(x / MapTexture.width) - math.floor(drawRowCount/2) 
		drawColIndex = math.floor(y / MapTexture.height) - math.floor(drawColCount/2)
	end
	mMapStarX = drawRowIndex * 2
	mMapStarY = drawColIndex * 2
	ClearMapWave()
	-- print(drawRowIndex)
	for i = drawRowIndex, drawRowCount + drawRowIndex - 1, 1 do
		for j = drawColIndex, drawColCount + drawColIndex - 1, 1 do
			local ii = i
			local jj = j
			if cfg_map.loop == 1 then
				ii = i % mapWidthTextureCount
				jj = j % mapHeightTextureCount
			end
			local index = ii + jj * mapWidthTextureCount
			
			if cs_ImageList[map] and index >= 0 and CsGetValue(cs_ImageList[map], index) == 1 then
				drawMapTexture(ii , jj, i - drawRowIndex, j - drawColIndex)
			else
				drawEmptyMapTexture(ii , jj, i - drawRowIndex, j - drawColIndex)
			end
			
			DrawMapWave(map, mapWidthTextureCount, i*2, j*2)
			DrawMapWave(map, mapWidthTextureCount, i*2+1, j*2)
			DrawMapWave(map, mapWidthTextureCount, i*2, j*2+1)
			DrawMapWave(map, mapWidthTextureCount, i*2+1, j*2+1)
		end
	end
end

function ClearMapWave()
	local outWaveList = {}
	for k,cs_mapwave in pairs(mMapWaveList) do
		local y = math.floor((k % 1000000000) / 100000)
		local x =(k % 100000)
		if mMapStarX > x or mMapStarX + 6 < x or mMapStarY > y or mMapStarY + 6 < y then 
			CsSetActive(cs_mapwave,false)
			table.insert(outWaveList, k)
			table.insert(mFreeMapWaveList, cs_mapwave)
		end
	end
	-- print(outWaveList)
	for k,v in pairs(outWaveList) do
		mMapWaveList[v] = nil
	end
	-- print(mMapWaveList)
end

function DrawMapWave(map, mapWidthTextureCount,  x, y)
	-- print(map, x, y)
	x = math.floor(x)
	y = math.floor(y)
	local cfg_map = CFG_map[map]
	-- print(map, x, y)
	local key = map*1000000000 + y * 100000 + x % (mapWidthTextureCount*2)
	local viewX,viewY = mCameraManager.GetView()
	if cfg_map.loop == 1 and viewX < 1000 and x*256+128 > 10000 then
		x = x - mapWidthTextureCount*2
	end
	if not mMapWaveList[key] and CFG_MapWave[key] then
		-- print(key)
		
		local cs_wave = GetMapWave()
		CsSetActive(cs_wave,true)
		CsSetPosition(GetTransform(cs_wave), 
		x*256+128, 
		0.01*(y-mMapStarY), 
		(y*256+128)*1.4142)
		mMapWaveList[key] = cs_wave
		-- print((y*256+128)*1.4142)
	end
end

function GetMapWave()
	if #mFreeMapWaveList > 0 then
		return table.remove(mFreeMapWaveList, 1)
	else
		local csAsset = Instantiate(mAssetManager.GetAsset(ConstValue.MapWavePath, AssetType.Forever))
		CsSetParent(GetTransform(csAsset), GetTransform(mCsMapWaveList))
		return csAsset
		-- CsSetScale(GetTransform(csShip), scale, scale, scale)
	end
end

function MapImageCompleteFunc()
	local hero = mHeroManager.GetHero()
	local viewX,viewY = mCameraManager.GetView()
	CsSetPosition(GetTransform(cs_map), 
				math.floor(viewX / MapTexture.width - 1) * MapTexture.width,
				-0.05,
				math.floor(viewY / MapTexture.height - 1) * MapTexture.height)
	drawMap(hero.map, viewX, viewY)
end

function drawMapTexture(i, j, index_x, index_y)
	local hero = mHeroManager.GetHero()
	local url = string.format("map/%d/%d_%d", hero.map,i,j)
	local cs_Texture = mAssetManager.GetAsset(url, AssetType.Map, MapImageCompleteFunc,true)
	if cs_Texture then
		CsSetMainTexture(csMeshMaterialList[index_x+drawRowCount*index_y], cs_Texture)
	else
		drawEmptyMapTexture(i, j, index_x, index_y)
	end
end

function drawEmptyMapTexture(i, j, index_x, index_y)
	local url = ConstValue.MapEmpty
	local cs_Texture = mAssetManager.GetAsset(url,AssetType.Map,nil,true)
	if cs_Texture then
		CsSetMainTexture(csMeshMaterialList[index_x+drawRowCount*index_y], cs_Texture)
	end
end
