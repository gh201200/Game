local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local CsDestroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,GetTransform,error,BulletList = 
Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,GetTransform,error,BulletList
local Rect,Color,CsSetActive,CsFindType,GetComponent,CsAddBullet,AttackType,CFG_ship,CsInstantiate = 
Rect,Color,CsSetActive,CsFindType,GetComponent,CsAddBullet,AttackType,CFG_ship,CsInstantiate
local CsClearParticle,VersionCode,ParticleEmitter = CsClearParticle,VersionCode,ParticleEmitter
local mCharacter = require "LuaScript.Mode.Object.Character"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mSceneManager = nil
local mMainPanel = nil
local mLoginPanel = nil
local mNetManager = nil
local mSceneTip = nil
local mAudioManager = nil
local mCharManager = nil
local mHeroManager = nil
local mSpindriftManager = nil
local mCameraManager = nil
local mBattleFieldManager = nil
local mSkillManager = nil

module("LuaScript.Control.Scene.BulletManager")

mBulletResList = nil
mActiveBulletList = nil
bulletListScript = nil

function Init()
	mActiveBulletList = {}
	mBulletResList = {}
	
	local csBulletList = GameObject.Find("BulletList")
	bulletListScript = GetComponent(csBulletList,BulletList.GetClassType())
	
	local csBulletList = GameObject.FindGameObjectsWithTag(GameObjectTag.Bullet)
	-- print(csBulletList[1])
	-- print(csBulletList.Length)
	for i=0,csBulletList.Length-1,1 do
		local csBullet = csBulletList[i]
		CsSetActive(csBullet,false)
		table.insert(mBulletResList, csBullet)
		mEventManager.AddEventListen(csBullet, EventType.OnBulletOver,OnBulletOver)
	end
	
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
	mSpindriftManager = require "LuaScript.Control.Scene.SpindriftManager"
	mSceneTip = require "LuaScript.View.Tip.SceneTip"
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	mSkillManager = require "LuaScript.Control.Scene.SkillManager"
end

function ClearAll()
	for csBullet,bulletData in pairs(mActiveBulletList) do
		table.insert(mBulletResList, csBullet)
		CsSetActive(csBullet,false)
	end
	mActiveBulletList = {}
	bulletListScript:CleanAll()
end

function GetOneBullet()
	-- local now = os.clock()
	local cs_Bullet = nil
	local length = #mBulletResList
	-- print(length)
	if length > 0 then
		-- print(111)
		cs_Bullet = mBulletResList[length]
		mBulletResList[length] = nil
	else
	
	end

	return cs_Bullet
end

function InitBullet(count, missCount, attackType, damageTotal, realDeltaHp, fromCsShip, toCsShip, fromShip, toShip, destroy, bulletAsset)
	-- print(count, missCount, damageTotal, lastHp, fromCsShip, toCsShip, fromShip, toShip)
	-- print("1_"..toShip.id)
	count = math.min(count, 5)
	mAudioManager.PlayAudioOneShot(AudioData.shoot)
	for i=1,count,1 do
		local forward = GetTransform(fromCsShip).forward
		local fromForwardX = forward.x
		local fromForwardZ = forward.z
		local toward = GetTransform(toCsShip).forward
		local toForwardX = forward.x
		local toForwardZ = forward.z
		
		local cfg_ship = CFG_ship[fromShip.bid]
		local shipLength = math.min(cfg_ship.scale*100 * 0.7, 60)
		local bulletData = {}
		bulletData.fromCsShip = fromCsShip
		bulletData.toCsShip = toCsShip
		bulletData.fromShip = fromShip
		bulletData.toShip = toShip
		
		
		local flyTime = ConstValue.BulletFlyTime - math.random() * 0.1
		local flyHeight = ConstValue.BulletFlyHeight + 5 * math.random()
		
		if i == 1 then
			bulletData.hurt = damageTotal
			bulletData.realDeltaHp = realDeltaHp
			bulletData.missCount = missCount
			bulletData.attackType = attackType
			bulletData.count = count
			bulletData.destroy = destroy
			flyTime = ConstValue.BulletFlyTime
		end
		local fromOffsetX = fromForwardX*shipLength*(i-count/2)/count
		local fromOffsetY = 2 * math.random()
		local fromOffsetZ = fromForwardZ*shipLength*(i-count/2)/count + math.random(-5,5)
		
		local toOffsetX = toForwardX*shipLength*(i-count/2)/count*0.4 + math.random(-5,5)
		local toOffsetY = 5 * math.random()
		local toOffsetZ = toForwardZ*shipLength*(i-count/2)/count*0.4 + math.random(-5,5)
		
		bulletData.toOffsetX = toOffsetX 
		bulletData.toOffsetY = toOffsetY 
		bulletData.toOffsetZ = toOffsetZ 
		
		
		local csBullet = nil
		if bulletAsset then
			csBullet = CsInstantiate(bulletAsset)
			bulletData.destroyBullet = true 
			mEventManager.AddEventListen(csBullet, EventType.OnBulletOver,OnBulletOver)
		else
			csBullet = GetOneBullet()
		end
		if not csBullet then
			if bulletData.hurt then
				ChangeHp(bulletData.toShip, bulletData.realDeltaHp, bulletData.destroy)
			end
			return
		end
		
		CsAddBullet(bulletListScript,fromShip.id, toShip.id, flyTime, flyHeight, fromOffsetX, fromOffsetY, fromOffsetZ,
			toOffsetX, toOffsetY, toOffsetZ, fromCsShip, toCsShip, csBullet)
		
		bulletData.csBullet = csBullet
		mActiveBulletList[csBullet] = bulletData

		CsClearParticle(GetComponent(csBullet,ParticleEmitter.GetType()))
		CsSetActive(csBullet,true)
	end
end

function OnBulletOver(csBullet,...)
	-- print(csBullet)
	local bulletData = mActiveBulletList[csBullet]
	if not bulletData.toShipMiss and bulletData.hurt and bulletData.toCsShip.activeSelf then
		ShowHit(bulletData)
	elseif bulletData.hurt then
		local cfg_ship = CFG_ship[bulletData.toShip.bid]
		if cfg_ship.type ~= 0 then
			return
		end
		local x = bulletData.toShip.x
		local y = bulletData.toShip.y
		for i=1,bulletData.missCount,1 do
			local value = math.pi*i/bulletData.missCount * math.random(7,10) * 0.2
			local spindriftX = x + math.sin(value) * 30
			local spindriftY = y + math.cos(value) * 30
			mSpindriftManager.InitSpindrift(spindriftX, spindriftY)
		end
	end
	
	if bulletData.destroyBullet then
		mEventManager.RemoveEventListen(csBullet)
		CsDestroy(csBullet)
	else
		Destroy(csBullet)
	end
end

function ShowHit(bulletData)
	local mHero = mHeroManager.GetHero()
	ChangeHp(bulletData.toShip, bulletData.realDeltaHp, bulletData.destroy)
	
	
	local cfg_ship = CFG_ship[bulletData.toShip.bid]
	local scale = cfg_ship.scale
	if cfg_ship.type == 1 then
		scale = scale * 2
	end
	mBombEffectManager.InitBombEffect(bulletData.toShip.x,10 + bulletData.toOffsetY,bulletData.toShip.y,scale)
	
	
	if cfg_ship.type == 0 then
		local x = bulletData.toShip.x
		local y = bulletData.toShip.y
		for i=1,bulletData.missCount,1 do
			local value = math.pi*i/bulletData.missCount * math.random(7,10) * 0.2
			local spindriftX = x + math.sin(value) * 30
			local spindriftY = y + math.cos(value) * 30
			mSpindriftManager.InitSpindrift(spindriftX, spindriftY)
		end
	end
	
	if bulletData.fromShip.cid ~= mHero.id and bulletData.toShip.cid ~= mHero.id then
		return
	end
	
	local x = bulletData.toShip.x + bulletData.toOffsetX
	-- local y = bulletData.toOffsetY
	local z = bulletData.toShip.y + bulletData.toOffsetZ 
	if bulletData.attackType == AttackType.Hit then
		if bulletData.hurt ~= 0 then
			mSceneTip.ShowTip(x,0,z-40, -bulletData.hurt, Color.RedStr)
			mAudioManager.PlayAudioOneShot(AudioData.bomb)
		end
	elseif bulletData.attackType == AttackType.Crit then
		mSceneTip.ShowTip(x,0,z-40, "暴击\n"..-bulletData.hurt, Color.RedStr, "Rise&Sacle")
		mAudioManager.PlayAudioOneShot(AudioData.bomb)
	elseif bulletData.attackType == AttackType.Miss then
		mSceneTip.ShowTip(x,0,z-40, "miss", Color.LimeStr)
		mAudioManager.PlayAudioOneShot(AudioData.bomb)
	end
	
	if bulletData.toShip.cid == mHero.id and bulletData.attackType == AttackType.Crit then
		mCameraManager.Shock()
	end
end

function ChangeHp(ship, hp, destroy)
	if destroy == 2 then
		mSkillManager.AddSkill(19, ship.id)
	end
	if hp == 0 then
		return
	end
	local mHero = mHeroManager.GetHero()
	ship.hp = ship.hp + hp
	mCharManager.UpdateHpBar(ship)
	
	if destroy == 1 and mHero.id == ship.cid then
		mHeroManager.Sink(ship.id)
	elseif destroy == 1 then
		mCharManager.Sink(ship.id)
	end
end

function Destroy(csBullet)
	-- print("Destroy",csBullet)
	mActiveBulletList[csBullet] = nil
	table.insert(mBulletResList, csBullet)
	CsSetActive(csBullet,false)
end

-- function HurtTipChange(tip)
	-- tip.position.z = tip.position.z + os.deltaTime*20
-- end

function ClearBySid(shipId)
	-- print("ClearBySid" , shipId)
	-- local destroyList = {}
	for csBullet,bulletData in pairs(mActiveBulletList) do
		if bulletData.toShip.id == shipId then
			bulletData.toShipMiss = true
		end
	end
	bulletListScript:InvalidBulletById(shipId)
	-- for csBullet,_ in pairs(destroyList) do
		-- Destroy(csBullet)
	-- end
end
