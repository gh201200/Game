local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv
local Color,os,CsRotate,print,CsSetScale = Color,os,CsRotate,print,CsSetScale
local AudioSkill = AudioSkill
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mTimer = require "LuaScript.Common.Timer"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
local mSkillManager = require "LuaScript.Control.Scene.SkillManager"
local mCharManager = require "LuaScript.Control.Scene.CharManager"
local mSceneTip = require "LuaScript.View.Tip.SceneTip"
local mCameraManager = require "LuaScript.Control.CameraManager"
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
module("LuaScript.Mode.Skill.Skill9")

function start(fromShip, toShip, value, realValue, destroy, attackList)
	-- print(fromShip, toShip, value, realValue, destroy)
	-- print(attackList)
	-- local hero = mHeroManager.GetHero()
	
	local char = mCharManager.GetChar(fromShip.cid)
	if not char then
		return
	end
	for k,v in pairs(attackList) do
		local toShip = v[2]
		mBulletManager.ChangeHp(toShip, v[4], v[5])
		if v[3] > 0 then
			mSceneTip.ShowTip(toShip.x, 0, toShip.y, "+"..v[3], Color.LimeStr)
		elseif v[3] < 0 then
			mSceneTip.ShowTip(toShip.x, 0, toShip.y, v[3], Color.LimeStr)
		end
	end
	mAudioManager.PlayAudioOneShot(AudioSkill[9])
	if char.ships[1] and char.ships[2] then
		func(char.ships[1], char.ships[2])
	end
	if char.ships[2] and char.ships[3] then
		func(char.ships[2], char.ships[3])
	end
end

function func(fromShip, toShip)
	local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,33), AssetType.Forever)
	if not csAsset then
		return
	end
	local obj = CsInstantiate(csAsset)
	
	local moveX = toShip.x - fromShip.x
	local moveY = toShip.y - fromShip.y
	local rotation = 0
	if moveX == 0 and moveY == 0 then
		rotation = 0
	elseif moveX >= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180
	elseif moveX <= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 360
	elseif moveX <= 0 and moveY <= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	else
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	end
	-- print(GetTransform(obj),0,rotation,0)
	CsRotate(GetTransform(obj),0,rotation,0)
	-- print(GetTransform(obj), 15, 1, math.sqrt(moveX^2+moveY^2))
	CsSetScale(GetTransform(obj), 15, 1, math.sqrt(moveX^2+moveY^2))
	-- CsSetPosition(GetTransform(obj), (fromShip.x+toShip.x)/2,30,(fromShip.y+toShip.y)/2)
	
	mSkillManager.AddEffect(33, fromShip, nil, obj)
	mSkillManager.AddEffect(36, fromShip)
	mSkillManager.AddEffect(36, toShip)
end