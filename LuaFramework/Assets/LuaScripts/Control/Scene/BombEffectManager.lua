local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsEmit = 
Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsEmit
local Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,ParticleEmitter,GetComponent = 
Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,ParticleEmitter,GetComponent
local CsClearParticle = CsClearParticle
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
local mCameraManager = nil
module("LuaScript.Control.Scene.BombEffectManager")

-- mBombEffectList = nil
-- mActiveBombEffectList = {}
local mCsParticleEmitter = nil

function Init()
	local gameObjec = GameObject.Find("BombEffectParticle")
	mCsParticleEmitter = GetComponent(gameObjec,ParticleEmitter.GetType())
	
	-- mBombEffectList = {}
	-- local csBombEffectList = GameObject.FindGameObjectsWithTag(GameObjectTag.BombEffect)
	-- for i=0,csBombEffectList.Length-1,1 do
		-- local csBombEffect = csBombEffectList:GetValue(i)
		-- CsSetActive(csBombEffect,false)
		-- table.insert(mBombEffectList, csBombEffect)
		
		-- mEventManager.AddEventListen(csBombEffect, EventType.OnAnimationOver, Destroy)
	-- end
	
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
end


function ClearAll()
	CsClearParticle(mCsParticleEmitter)
	-- for csEffect,_ in pairs(mActiveBombEffectList) do
		-- table.insert(mBombEffectList, csEffect)
		-- CsSetActive(csEffect,false)
	-- end
	-- mActiveBombEffectList = {}
end

-- function GetOneBombEffect()
	-- local cs_BombEffect = nil
	-- local length = #mBombEffectList
	-- if length > 0 then
		-- cs_BombEffect = mBombEffectList[length]
		-- mBombEffectList[length] = nil
		-- CsSetActive(cs_BombEffect,true)
	-- else

	-- end
	-- return cs_BombEffect
-- end


function InitBombEffect(x,y,z,scale)
	CsEmit(mCsParticleEmitter, 
		x,y,z,
		0,0,0,
		70*scale,
		1,
		0,
		0)
	-- local csBombEffect = GetOneBombEffect()
	-- if not csBombEffect then
		-- return 
	-- end
	
	-- CsSetPosition(GetTransform(csBombEffect), bulletData.toShip.x, 10 + bulletData.toOffsetY, bulletData.toShip.y)
	-- mActiveBombEffectList[csBombEffect] = true
end

-- function Destroy(csEffect)
	-- table.insert(mBombEffectList, csEffect)
	-- CsSetActive(csEffect,false)
	
	-- mActiveBombEffectList[csEffect] = nil
-- end