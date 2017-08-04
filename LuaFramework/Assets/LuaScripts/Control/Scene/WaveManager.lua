local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CFG_seagull,MapTexture,cs_Base,CsRotate = 
Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CFG_seagull,MapTexture,cs_Base,CsRotate
local Rect,Color,CFG_ship,CsSetPosition,GetTransform,CsSetActive,GetRenderer,CsSetScale,CsSetMaterial,AssetType = 
Rect,Color,CFG_ship,CsSetPosition,GetTransform,CsSetActive,GetRenderer,CsSetScale,CsSetMaterial,AssetType
local CsSetParent,CFG_Enemy,CharacterType,GetComponentInChildren,CsAnimationPlay,Animation,CsFindType,GetComponent = 
CsSetParent,CFG_Enemy,CharacterType,GetComponentInChildren,CsAnimationPlay,Animation,CsFindType,GetComponent
local CsEmit,CsTranslateParticle,ParticleEmitter,CsClearParticle = 
CsEmit,CsTranslateParticle,ParticleEmitter,CsClearParticle
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

module("LuaScript.Control.Scene.WaveManager")
-- mCsSceneTransform = nil
-- mWaveList = nil
-- mActiveList = {}
-- mActiveListBySid = {}
-- mCsWaveTransform = nil
local mCsParticleEmitter = nil

function Init()
	local gameObjec = GameObject.Find("WaveParticle")
	mCsParticleEmitter = GetComponent(gameObjec,ParticleEmitter.GetType())
	
	-- mWaveList = {}
	-- local csWaveList = GameObject.FindGameObjectsWithTag(GameObjectTag.Wave)
	-- for i=0,csWaveList.Length-1,1 do
		-- local csWave = csWaveList:GetValue(i)
		-- CsSetActive(csWave,false)
		
		-- local mWave = {}
		-- mWave.csWave = csWave
		-- mWave.angles = 0
		-- table.insert(mWaveList, mWave)
		
		-- mEventManager.AddEventListen(csWave, EventType.OnAnimationOver, Destroy)
	-- end
	
	mCameraManager = require "LuaScript.Control.CameraManager"
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
end

function ClearAll()
	-- for k,wave in pairs(mActiveList) do
		-- CsSetActive(wave.csWave,false)
		-- table.insert(mWaveList, wave)
	-- end
	-- mActiveList = {}
	-- mActiveListBySid = {}
	
	CsClearParticle(mCsParticleEmitter)
end

-- function GetOneWave()
	-- local mWave = nil
	-- local length = #mWaveList
	-- if length > 0 then
		-- mWave = mWaveList[length]
		-- mWaveList[length] = nil
	-- else
	
	-- end
	-- return mWave
-- end

function InitWave(mShip, type)
	if mShip.dead then
		return
	end
	local rotation = mShip.angles or mShip.rotation
	local angles = rotation
	angles = 45 - angles
	if angles == 0 then
		angles = 360
	end
	
	
	local char = mCharManager.GetChar(mShip.cid)
	local cfg_ship = CFG_ship[mShip.bid]
	local size = cfg_ship.width*6
	if char.type == CharacterType.Enemy then
		local cfg_Enemy = CFG_Enemy[char.eid]
		size = size * cfg_Enemy.scale
	else
		size = size * cfg_ship.scale
	end
	
	-- print(char.type.. "_" .. size)
	if type == 0 then
		CsEmit(mCsParticleEmitter, 
			mShip.x+math.sin(math.pi*rotation/180)*20,0.5,mShip.y+math.cos(math.pi*rotation/180)*20,
			0,0,0,
			size,
			1.3,
			angles,
			0)
	else
		CsEmit(mCsParticleEmitter, 
			mShip.x+math.sin(math.pi*rotation/180)*20,0.5,mShip.y+math.cos(math.pi*rotation/180)*20,
			0,0,0,
			size,
			1.3,
			angles,
			0)
	end
	-- CsSetActive(mWave.csWave,true)
	-- local animation = GetComponentInChildren(mWave.csWave, Animation.GetType())
	-- CsAnimationPlay(animation, animationName)
	-- local transform = GetTransform(mWave.csWave)
	-- CsSetPosition(transform, mShip.x,0.5,mShip.y)
	
	
	-- local char = mCharManager.GetChar(mShip.cid)
	-- local cfg_ship = CFG_ship[mShip.bid]
	-- if char.type == CharacterType.Enemy then
		-- local cfg_Enemy = CFG_Enemy[char.eid]
		-- CsSetScale(transform, cfg_ship.width*0.083*cfg_Enemy.scale,1,cfg_ship.width*0.1*cfg_Enemy.scale)
	-- else
		-- CsSetScale(transform, cfg_ship.width*0.083,1,cfg_ship.width*0.1)
	-- end
	
	-- local angles = -mWave.angles + (mShip.rotation or mShip.angles)
	-- mWave.angles = mShip.rotation or mShip.angles
	-- CsRotate(transform,0,angles,0)
	
	-- local sid = mShip.id
	-- mWave.x = mShip.x
	-- mWave.y = mShip.y
	-- mWave.sid = sid
	-- mActiveListBySid[sid] = mActiveListBySid[sid] or {}
	-- mActiveListBySid[sid][mWave.csWave] = mWave
	-- mActiveList[mWave.csWave] = mWave
end

-- function ChangeAllX(value)
	-- local viewX,viewY = mCameraManager.GetView()
	-- for k,mWave in pairs(mActiveList) do
		-- CsSetPosition(GetTransform(mWave.csWave), mWave.x + value,0.5,mWave.y)
	-- end
	-- CsTranslateParticle(mCsParticleEmitter, value)
-- end

-- function Update()
	-- if not mActiveList then
		-- return
	-- end
	-- local destroyList = nil
	-- for k,wave in pairs(mActiveList) do
		-- local over = UpdateEffect(wave)
		-- if over then
			-- destroyList = destroyList or {}
			-- destroyList[k] = 1
		-- end
	-- end
	
	-- if destroyList then
		-- for index,_ in pairs(destroyList) do
			-- Destroy(index)
		-- end
	-- end
-- end

-- function UpdateEffect(wave)
	-- if os.oldClock - wave.time > 0.1 then
		-- if wave.frame >= 7 then
			
			-- return true
		-- end
		
		-- wave.time = os.oldClock 
		-- wave.frame = wave.frame + 1
		
		-- local csMaterial = mAssetManager.GetAsset("GameObj/Materials/WaveMaterial"..wave.frame,AssetType.Material)
		-- CsSetMaterial(GetRenderer(wave.csWave), csMaterial)
	-- end
-- end

-- function ClearBySid(sid)
	-- if not mActiveListBySid[sid] then
		-- return
	-- end
	-- for k,v in pairs(mActiveListBySid[sid]) do
		-- mActiveList[k] = nil
		-- CsSetActive(k,false)
		
		-- table.insert(mWaveList, v)
	-- end
	
	-- mActiveListBySid[sid] = nil
-- end

-- function Destroy(csWave)
	-- local mWave = mActiveList[csWave]
	-- table.insert(mWaveList, mWave)
	
	-- mActiveList[csWave] = nil
	-- CsSetActive(csWave,false)
	
	-- mActiveListBySid[mWave.sid][csWave] = nil
-- end