local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv
local Color,os = Color,os
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
local mSkill3 = require "LuaScript.Mode.Skill.Skill3"
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
module("LuaScript.Mode.Skill.Skill4")

function start(fromShip, toShip, value, realValue, destroy, attackList)
	local hero = mHeroManager.GetHero()
	
	function intervalFunc()
		local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,26), AssetType.Forever)
		if not csAsset then
			return
		end
		
		for i=1,math.random(3) do
			local target = {x=hero.x + math.random(1000)-500,y=hero.y+ math.random(600)-300}
			mSkill3.start(nil,target)
		end
	end
	local mInterval = mTimer.SetInterval(intervalFunc, 0.2)
	intervalFunc()

	
	function timeOver1()
		mTimer.RemoveTimer(mInterval)
	end
	mTimer.SetTimeout(timeOver1, 1.5)
	
	function timeOver2()
		for k,v in pairs(attackList) do
			local toShip = v[2]
			if not toShip.outView then
				mBulletManager.ChangeHp(toShip, v[4], v[5])
				mSceneTip.ShowTip(toShip.x, 0, toShip.y, v[3], Color.RedStr)
				mSkillManager.AddEffect(27, toShip)
			end
		end
	end
	mTimer.SetTimeout(timeOver2, 1.3)
end