local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv
local Color,os,getfenv,print,CsIsNull = Color,os,getfenv,print,CsIsNull
local AudioSkill,AudioData,CsRotate = AudioSkill,AudioData,CsRotate
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
module("LuaScript.Mode.Skill.Skill3")

function start(fromShip, toShip, value, realValue, destroy)
	local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,42), AssetType.Forever)
	if not csAsset then
		return
	end
	local mInterval = mTimer.SetInterval(intervalFunc, 0.02)
	
	local skillObj = CsInstantiate(csAsset)
	local oldRotation = 0
	-- Ðý×ª
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
	
	CsRotate(GetTransform(skillObj),0,-rotation+oldRotation,0)
	oldRotation = rotation
	
	
	local startTime = os.oldClock
	function intervalFunc()
		
		local x = 0
		local y = 0
		local z = 0
		
		local overTime = (os.oldClock - startTime) *  2
		x = (toShip.x - fromShip.x)*overTime + fromShip.x
		y = 30 + 10 * math.sin(math.pi*overTime)
		z = (toShip.y - fromShip.y)*overTime + fromShip.y
		-- print(1,skillObj)
		CsSetPosition(GetTransform(skillObj), x,y,z)
		if overTime >= 1 then
			local csShip = mCharManager.GetCsShip(toShip.id)
			if csShip then
				mBulletManager.ChangeHp(toShip, realValue, destroy)
				mSceneTip.ShowTip(toShip.x, 0, toShip.y, value, Color.RedStr)
				mSkillManager.AddEffect(43, toShip, csShip)
				mAudioManager.PlayAudioOneShot(AudioData.bomb)
				mCameraManager.Shock()
			else
				-- mSkillManager.AddEffect(43, toShip, csShip)
			end
			
			mTimer.RemoveTimer(mInterval)
			Destroy(skillObj)
		end
	end
	
	mAudioManager.PlayAudioOneShot(AudioSkill[3])
	mInterval.func = intervalFunc
	intervalFunc()
end