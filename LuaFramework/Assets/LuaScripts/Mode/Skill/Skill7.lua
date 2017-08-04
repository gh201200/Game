local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv
local Color,os,CsRotate,getfenv = Color,os,CsRotate,getfenv
local AudioSkill,AudioData = AudioSkill,AudioData
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
module("LuaScript.Mode.Skill.Skill7")

function start(fromShip, toShip, value, realValue, destroy)
	local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,30), AssetType.Forever)
	if not csAsset then
		return
	end
	local obj = CsInstantiate(csAsset)
	local startTime = os.oldClock
	
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
	CsSetPosition(GetTransform(obj), fromShip.x,30,fromShip.y)
	
	local interval = mTimer.SetInterval(intervalFunc, 0.02)
	function intervalFunc()
		local x = 0
		local y = 0
		local z = 0
		local overTime = (os.oldClock - startTime)*2
		local moveX = toShip.x - fromShip.x
		local moveY = toShip.y - fromShip.y
		
		local x = fromShip.x + moveX*overTime
		local y = fromShip.y + moveY*overTime
		
		
		CsSetPosition(GetTransform(obj), x,30,y)
		if overTime > 1 then
			local csShip = mCharManager.GetCsShip(toShip.id)
			if csShip then
				mBulletManager.ChangeHp(toShip, realValue, destroy)
				mSceneTip.ShowTip(toShip.x, 0, toShip.y, value, Color.RedStr)
				mSkillManager.AddEffect(31, toShip, csShip)
				mAudioManager.PlayAudioOneShot(AudioData.bomb)
			end
			-- mCameraManager.Shock()
			mTimer.RemoveTimer(interval)
			Destroy(obj)
		end
	end
	mAudioManager.PlayAudioOneShot(AudioSkill[7])
	interval.func = intervalFunc
	intervalFunc()
end