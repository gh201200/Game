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
module("LuaScript.Mode.Skill.Skill12")

function start(fromShip, toShip, value, realValue, destroy)
	local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,37), AssetType.Forever)
	if not csAsset then
		return
	end
	mAudioManager.PlayAudioOneShot(AudioSkill[12])
	
	
	local obj = CsInstantiate(csAsset)
	
	local moveX = toShip.x - fromShip.x
	local moveY = toShip.y - fromShip.y
	local rotation = 0
	if moveX >= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180
	elseif moveX <= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 360
	elseif moveX <= 0 and moveY <= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	else
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	end
	CsRotate(GetTransform(obj),0,rotation,0)
	
	local length = math.sqrt(moveX^2+moveY^2)
	CsSetScale(GetTransform(obj), 45, 1, math.sqrt(moveX^2+moveY^2))
	local _,skillId = mSkillManager.AddEffect(37, fromShip, nil, obj)
	
	local startTime = os.oldClock
	local mInterval = mTimer.SetInterval(intervalFunc, 0.02)
	function intervalFunc()
		local skillObj = mSkillManager.GetSkill(skillId)
		if not skillObj then
			mTimer.RemoveTimer(mInterval)
			return
		end
		
		local overTime = math.min(os.oldClock - startTime, 1)
		CsSetScale(GetTransform(skillObj), 20-overTime*50, 1, length)
	end
	
	mInterval.func = intervalFunc
	-- local mInterval = mTimer.SetInterval(intervalFunc, 0.02)
	-- local t = {length=length,skillId = skillId,print=print,
		-- CsSetScale=CsSetScale,startTime=os.oldClock,os=os,
		-- mSkillManager=mSkillManager,mTimer=mTimer,interval=mInterval}
	-- setfenv(intervalFunc, t)
	
	
	mSkillManager.AddEffect(38, fromShip)
	mSkillManager.AddEffect(38, toShip)
	-- mSceneTip.ShowTip(toShip.x, 0, toShip.y, "-"..value, Color.RedStr)
	
	local obj = CsInstantiate(csAsset)
	local toX = toShip.x + math.random(50) - 50
	local toY = toShip.y + math.random(50) - 50
	local moveX = toX - toShip.x
	local moveY = toY - toShip.y
	local rotation = 0
	if moveX >= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180
	elseif moveX <= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 360
	elseif moveX <= 0 and moveY <= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	else
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	end
	CsRotate(GetTransform(obj),0,rotation,0)
	CsSetScale(GetTransform(obj), 10, 1, math.sqrt(moveX^2+moveY^2))
	
	mSkillManager.AddEffect(37, toShip, nil, obj)
	mSkillManager.AddEffect(38, {x=toX,y=toY})
	
	local obj = CsInstantiate(csAsset)
	local toX = toShip.x + math.random(100) - 50
	local toY = toShip.y + math.random(100) - 50
	local moveX = toX - toShip.x
	local moveY = toY - toShip.y
	local rotation = 0
	if moveX >= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180
	elseif moveX <= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 360
	elseif moveX <= 0 and moveY <= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	else
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	end
	CsRotate(GetTransform(obj),0,rotation,0)
	CsSetScale(GetTransform(obj), 8, 1, math.sqrt(moveX^2+moveY^2))
	
	mSkillManager.AddEffect(37, toShip, nil, obj)
	mSkillManager.AddEffect(38, {x=toX,y=toY})
	
	local obj = CsInstantiate(csAsset)
	local toX = toShip.x + math.random(150) - 50
	local toY = toShip.y + math.random(150) - 50
	local moveX = toX - toShip.x
	local moveY = toY - toShip.y
	local rotation = 0
	if moveX >= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180
	elseif moveX <= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 360
	elseif moveX <= 0 and moveY <= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	else
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	end
	CsRotate(GetTransform(obj),0,rotation,0)
	CsSetScale(GetTransform(obj), 5, 1, math.sqrt(moveX^2+moveY^2))
	
	mSkillManager.AddEffect(37, toShip, nil, obj)
	mSkillManager.AddEffect(38, {x=toX,y=toY})
	
	mBulletManager.ChangeHp(toShip, realValue, destroy)
	mSceneTip.ShowTip(toShip.x, 0, toShip.y, value, Color.RedStr)
end