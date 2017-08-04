local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CFG_seagull,MapTexture,cs_Base = 
Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CFG_seagull,MapTexture,cs_Base
local Rect,Color,CsSetActive,CsSetHeroPosition,CsFindType,GetComponent,CsSetSeagull,SeagullList = 
Rect,Color,CsSetActive,CsSetHeroPosition,CsFindType,GetComponent,CsSetSeagull,SeagullList
local mCharacter = require "LuaScript.Mode.Object.Character"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mSceneManager = nil
local mMainPanel = nil
local mLoginPanel = nil
local mPanelManager = nil
local mNetManager = nil
local mSceneTip = nil
local mAudioManager = nil
local mCharManager = nil
local mHeroManager = nil
local mBombEffectManager = nil
local mCameraManager = nil

module("LuaScript.Control.Scene.SeagullManager")

mLastAudioPlayTime = 0
csSeagullList = nil
bulletListScript = nil
mActive = false
mSeagullId = -1

mOldDrawIndex = -1

function Init()
	-- mSeagullList = {}
	csSeagullList = GameObject.Find("SeagullList")
	bulletListScript = GetComponent(csSeagullList,SeagullList.GetClassType())
	CsSetActive(csSeagullList,false)
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mBombEffectManager = require "LuaScript.Control.Scene.BombEffectManager"
	mSceneTip = require "LuaScript.View.Tip.SceneTip"
	mCameraManager = require "LuaScript.Control.CameraManager"
end

function ClearAll()
	if mActive then
		SetActive(false)
	end
	mOldDrawIndex = -1
end

function SetActive(active, seagullId)
	if active and mActive ~= active then
		local hero = mHeroManager.GetHero()
		mSeagullId = seagullId
		local mSeagullCfg = CFG_seagull[seagullId]
		for i=0,12,1 do
			local rotateTime = 2 + math.random() * 2
			CsSetSeagull(bulletListScript,i                                          ,
							rotateTime                               		      ,
							55 + 20 * math.random() * rotateTime 			      ,
							mSeagullCfg.x + 10 * math.random()                    ,
							200 + 20 * math.random()                              ,
							mSeagullCfg.y + 10 * math.random()                    ,
							0.8 + math.random() * 0.5                             ,
							0.8 + math.random() * 0.5                             ,
							math.random() * rotateTime           )
		end
		CsSetActive(csSeagullList,true)
	elseif not active and mActive ~= active then
		CsSetActive(csSeagullList,false)
	end
	mActive = active
end

function UpdatePosition(map, x, y)
	-- print("UpdatePositio~~~~~~~~~~~~n")
	local drawRowIndex = math.floor(x / MapTexture.width * 2.2)
	local drawColIndex = math.floor(y / MapTexture.height * 2.2)
	if mOldDrawIndex == drawRowIndex + drawColIndex * 10000 then
		return
	end
	
	mOldDrawIndex = drawRowIndex + drawColIndex * 10000
	
	if mActive then
		local mSeagullCfg = CFG_seagull[mSeagullId]
		if math.abs(x - mSeagullCfg.x) > Screen.DefaultWidth or 
			math.abs(y - mSeagullCfg.y) > Screen.DefaultHeight then
			SetActive(false)
		end
	else
		local x_min = x - Screen.DefaultWidth/2 - MapTexture.width / 2
		local x_max = x + Screen.DefaultWidth/2 + MapTexture.width / 2
		local y_min = y - Screen.DefaultHeight/2 - MapTexture.height / 2
		local y_max = y + Screen.DefaultHeight/2 + MapTexture.height / 2
		for k,v in pairs(CFG_seagull) do
			if map == v.mapId and v.x > x_min and v.x < x_max and v.y > y_min and v.y < y_max then
				SetActive(true, v.id)
				break
			end
		end
	end
end


function Update()
	if not mActive then
		return
	end
	
	-- local viewX,viewY = mCameraManager.GetView()
	-- CsSetHeroPosition(bulletListScript, viewX, viewY)
	
	if os.oldClock - mLastAudioPlayTime > math.random() + 0.4 then
		local mSeagullCfg = CFG_seagull[mSeagullId]
		local viewX,viewY = mCameraManager.GetView()
		local dis = (500 - math.abs(viewX - mSeagullCfg.x) - math.abs(viewY - mSeagullCfg.y)) / 500
		-- print(dis)
		if dis < 0.4 then
			return
		end
	
		local index = math.random(3)
		mAudioManager.PlayAudioOneShot(AudioData["gull"..index], dis)
		mLastAudioPlayTime = os.oldClock
	end
end