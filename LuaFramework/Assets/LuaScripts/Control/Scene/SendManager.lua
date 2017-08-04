local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CFG_send,MapTexture,cs_Base,CsRotate = 
Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CFG_send,MapTexture,cs_Base,CsRotate
local Rect,Color,CsSetPosition,GetTransform,CsSetActive,CsSetParent = 
Rect,Color,CsSetPosition,GetTransform,CsSetActive,CsSetParent
local mCharacter = require "LuaScript.Mode.Object.Character"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mHeroManager = nil
local mCameraManager = nil

module("LuaScript.Control.Scene.SendManager")

mCsSend = nil
-- mCsScene = nil
mActive = false
mSendId = 0

mOldDrawIndex = -1

function Init()
	mCsSend = GameObject.FindGameObjectWithTag(GameObjectTag.Send)
	-- mCsScene = GameObject.Find("Scene")
	-- print(1111111111111)
	CsSetActive(mCsSend,false)
	mEventManager.AddEventListen(mCsSend, EventType.OnMouseDown, OnMouseDown)
	
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
end

function GetNearSend()
	local hero = mHeroManager.GetHero()
	local dis = 1000000
	local send = nil
	for k,cfg_send in pairs(CFG_send) do
		-- print(char.eid == eid)
		if EffectMap(cfg_send) and cfg_send.map == hero.map then
			local tDis = math.abs(cfg_send.x - hero.x) + math.abs(cfg_send.y - hero.y)
			if tDis < dis then
				dis = tDis
				send = cfg_send
			end
		end
	end
	-- print(send.id)
	return send
end

function ClearAll()
	if mActive then
		SetActive(false)
	end
	mOldDrawIndex = -1
end

function SetActive(active, sendId)
	if active and mActive ~= active then
		mSendId = sendId
		CsSetActive(mCsSend,true)
		-- CsSetParent(GetTransform(mCsSend), GetTransform(mCsScene))
	elseif not active and mActive ~= active then
		CsSetActive(mCsSend,false)
		-- CsSetParent(GetTransform(mCsSend), nil)
	end
	mActive = active
end

function UpdatePosition(map, x, y)	
	local drawRowIndex = math.floor(x / MapTexture.width * 1.98)
	local drawColIndex = math.floor(y / MapTexture.height * 1.98)
	if mOldDrawIndex == drawRowIndex + drawColIndex * 10000 then
		return
	end
	
	mOldDrawIndex = drawRowIndex + drawColIndex * 10000
	
	if mActive then
		local mSendCfg = CFG_send[mSendId]
		if math.abs(x - mSendCfg.x) > Screen.DefaultWidth / 2 + 200 or 
			math.abs(y - mSendCfg.y) > Screen.DefaultHeight / 2 + 200 
			or mSendCfg.map ~= map then
			SetActive(false)
			-- print(11111111111)
		end
	else
		local x_min = x - Screen.DefaultWidth/2 - MapTexture.width / 2 - 100
		local x_max = x + Screen.DefaultWidth/2 + MapTexture.width / 2 + 100
		local y_min = y - Screen.DefaultHeight/2 - MapTexture.height / 2 - 100
		local y_max = y + Screen.DefaultHeight/2 + MapTexture.height / 2 + 100
		-- local hero = mHeroManager.GetHero()
		-- local viewX,viewY = mCameraManager.GetView()
		for k,v in pairs(CFG_send) do
			if EffectMap(v) and  v.x > x_min and v.x < x_max and v.y > y_min and v.y < y_max and v.map == map then
				-- print(111111111111)
				SetActive(true, v.id)
				local mSendCfg = CFG_send[mSendId]
				CsSetPosition(GetTransform(mCsSend), mSendCfg.x,1,mSendCfg.y)
				break
			end
		end
	end
end

function EffectMap(send)
	if send.map ~= 2 then
		return true
	end
	
	-- local hero = mHeroManager.GetHero()
	return true
end

function OnMouseDown()
	local mSendCfg = CFG_send[mSendId]
	mHeroManager.SetTarget(ConstValue.SendType ,mSendId)
	mHeroManager.Goto(mSendCfg.map, mSendCfg.x, mSendCfg.y)
end


-- function Update()
	-- if not mActive then
		-- return
	-- end
	-- print(Vector3.up, 10)
	-- CsRotate(GetTransform(mCsSend), 0, 0, -1)
-- end