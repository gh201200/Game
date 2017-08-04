local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv
local Color,os,CsRotate,print = Color,os,CsRotate,print
local AudioSkill,CsIsNull = AudioSkill,CsIsNull
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
module("LuaScript.Mode.Skill.Skill8")

function start(fromShip, toShip, value, realValue, destroy, attackList)
	local hero = mHeroManager.GetHero()
	local csSkill = mSkillManager.AddEffect(32, {x=hero.x, y=hero.y, z=800})
	mAudioManager.PlayAudioOneShot(AudioSkill[8])
	if CsStopEmit then
		function timeOver()
			if csSkill and not CsIsNull(skillObj) then
				CsStopEmit(csSkill)
			end
			-- print(effect)
			-- local com = 
			-- effect.enableEmission = false
		end
		
		-- local t = {effect=csSkill, CsStopEmit=CsStopEmit}
		-- setfenv(timeOver, t)
		mTimer.SetTimeout(timeOver, 1.5)
	end
	
	function timeOver2()
		for k,v in pairs(attackList) do
			local toShip = v[2]
			mBulletManager.ChangeHp(toShip, v[4], v[5])
			mSceneTip.ShowTip(toShip.x, 0, toShip.y, "+"..v[3], Color.LimeStr)
		end
	end
	mTimer.SetTimeout(timeOver2, 1)
end