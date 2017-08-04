local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue,tonumber,CsSetPosition,GetTransform = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue,tonumber,CsSetPosition,GetTransform
local Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetScale,CsGetName = 
Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetScale,CsGetName
local Rect,Color,CsSetActive,CFG_map = Rect,Color,CsSetActive,CFG_map
local mCharacter = require "LuaScript.Mode.Object.Character"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mSceneManager = nil
local mMainPanel = nil
local mLoginPanel = nil
local mPanelManager = nil
local mNetManager = nil
local mAudioManager = nil
local mCharManager = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mCameraManager = nil
module("LuaScript.Control.Scene.CloudManager")

mCloudList = nil
mCsCloudList = nil
mActiveCloudList = nil
mCloudPositionList = {}
mOffsetX = 0
mOffsetY = 0
mChangeX = 0
mChangeY = 0
mChangeTime = -600
mOldDrawIndex = -1000

function Init()
	-- print(CsGetName)
	mCloudList = {{},{},{},{}}
	mCsCloudList = GameObject.Find("CloudList")
	local csCloudList = GameObject.FindGameObjectsWithTag(GameObjectTag.Cloud)
	-- print(csCloudList.Length)
	for i=0,csCloudList.Length-1,1 do
		local csCloud = csCloudList[i]
		CsSetActive(csCloud,false)
		local type = tonumber(CsGetName(csCloud))
		table.insert(mCloudList[type], csCloud)
	end
	
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
end

function ClearAll()
	Reset()
	
	mOffsetX = 0
	mOffsetY = 0
	mCloudPositionList = {}
end


function Reset()
	if not mActiveCloudList then
		return
	end
	for _,csCloud in pairs(mActiveCloudList) do
		local type = tonumber(CsGetName(csCloud))
		table.insert(mCloudList[type], csCloud)
		CsSetActive(csCloud,false)
	end
	mActiveCloudList = nil
	mOldDrawIndex = -1000
	-- mOffsetX = 0
	-- mOffsetY = 0
end

function GetOneCloud(type)
	local cs_Cloud = nil
	local length = #mCloudList[type]
	if length > 0 then
		cs_Cloud = mCloudList[type][length]
		mCloudList[type][length] = nil
		CsSetActive(cs_Cloud,true)
	else
	
	end
	return cs_Cloud
end

function ChangeAllX(change)
	mOldDrawIndex = -1000
	Update()
end

function InitCloudData(xIndex, yIndex, mapWidth, loop)
	-- print("InitCloudData")
	if loop == 1 then
		xIndex = (xIndex + math.floor(mapWidth / 600)) % math.floor(mapWidth / 600)
	end
	-- print(xIndex, yIndex)
	local key = xIndex +  yIndex * 100000000
	if mCloudPositionList[key] then
		return
	end
	local x = xIndex * 600
	local y = yIndex * 600
	local count = math.random(2) - 1
	-- local count = 1
	mCloudPositionList[key] = {}
	for i=1,count,1 do
		local cloud = {}
		cloud.x = x + math.random() * 600
		cloud.y = y - math.random() * 600
		cloud.angle = math.random(360)
		cloud.scale = math.random(10,20)
		cloud.type = math.random(4)
		table.insert(mCloudPositionList[key], cloud)
	end
	-- print(mCloudPositionList[key])
end


function InitCloud(xIndex, yIndex, x, y, mapWidth, loop)
	-- print(xIndex, (xIndex + math.floor(mapWidth / 600)) % math.floor(mapWidth / 600))
	if loop == 1 then
		xIndex = (xIndex + math.floor(mapWidth / 600)) % math.floor(mapWidth / 600)
	end
	-- print(xIndex, yIndex)
	local hero = mHeroManager.GetHero()
	local key = xIndex +  yIndex * 100000000
	for k,cloud in pairs(mCloudPositionList[key]) do
		local csCloud = GetOneCloud(cloud.type)
		if csCloud then
			local cloudX = cloud.x-mOffsetX
			if loop == 1 then
				_,cloudX = mCommonlyFunc.LoopVector((cloud.x-mOffsetX)%mapWidth,hero.x,mapWidth)
			end
			CsSetPosition(GetTransform(csCloud),cloudX,200,cloud.y-mOffsetY+250)
			CsSetScale(GetTransform(csCloud),cloud.scale,1,cloud.scale)
			mActiveCloudList = mActiveCloudList or {}
			table.insert(mActiveCloudList, csCloud)
		end
	end
end

function Update()
	local hero = mHeroManager.GetHero()
	-- if hero.map ~= 2 then
	if true then
		return
	end
	if os.oldClock - mChangeTime > 600 then
		mChangeX = math.random()
		mChangeY = math.random()
		mChangeTime = os.oldClock
	end
	mOffsetX = mOffsetX + mChangeX
	mOffsetY = mOffsetY + mChangeY
	
	local viewX,viewY = mCameraManager.GetView()
	local hero = mHeroManager.GetHero()
	local cfg_map = CFG_map[hero.map]
	local mapWidth = cfg_map.width
	local loop = cfg_map.loop
	local x = mOffsetX + viewX
	local y = mOffsetY + viewY
	
	if loop == 1 then
		x = (mOffsetX + viewX) % mapWidth
	end
	
	CsSetPosition(GetTransform(mCsCloudList),-mOffsetX,0,-mOffsetY)
	
	local xIndex = math.floor(x / 600)
	local yIndex = math.floor(y / 600)
	local key = xIndex + yIndex * 100000000
	if key ~= mOldDrawIndex then
		InitCloudData(xIndex-1, yIndex-1, mapWidth, loop)
		InitCloudData(xIndex-1, yIndex, mapWidth, loop)
		InitCloudData(xIndex-1, yIndex+1, mapWidth, loop)
		InitCloudData(xIndex, yIndex-1, mapWidth, loop)
		InitCloudData(xIndex, yIndex, mapWidth, loop)
		InitCloudData(xIndex, yIndex+1, mapWidth, loop)
		InitCloudData(xIndex+1, yIndex-1, mapWidth, loop)
		InitCloudData(xIndex+1, yIndex, mapWidth, loop)
		InitCloudData(xIndex+1, yIndex+1, mapWidth, loop)
		
		Reset()
		
		InitCloud(xIndex-1, yIndex-1, x, y, mapWidth,loop)
		InitCloud(xIndex-1, yIndex, x, y, mapWidth,loop)
		InitCloud(xIndex-1, yIndex+1, x, y, mapWidth,loop)
		InitCloud(xIndex, yIndex-1, x, y, mapWidth,loop)
		InitCloud(xIndex, yIndex, x, y, mapWidth, loop)
		InitCloud(xIndex, yIndex+1, x, y, mapWidth,loop)
		InitCloud(xIndex+1, yIndex-1, x, y, mapWidth,loop)
		InitCloud(xIndex+1, yIndex, x, y, mapWidth,loop)
		InitCloud(xIndex+1, yIndex+1, x, y, mapWidth,loop)
		
		mOldDrawIndex = key
	end
end