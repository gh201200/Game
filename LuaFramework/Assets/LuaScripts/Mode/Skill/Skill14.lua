local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs
local Color,CsStopEmit = Color,CsStopEmit
local AudioSkill,CsIsNull = AudioSkill,CsIsNull
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mTimer = require "LuaScript.Common.Timer"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
local mSkillManager = require "LuaScript.Control.Scene.SkillManager"
local mSceneTip = require "LuaScript.View.Tip.SceneTip"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
module("LuaScript.Mode.Skill.Skill14")

function start(ship)
	-- mSceneTip.ShowTip(ship.x, 0, ship.y, "-"..value, Color.RedStr)
	local effect = mSkillManager.AddEffect(39, {x=ship.x,y=ship.y,z=800})
	mAudioManager.PlayAudioOneShot(AudioSkill[14])
	if CsStopEmit then
		function timeOver()
			if effect and not CsIsNull(effect) then
				CsStopEmit(effect)
			end
		end
		
		mTimer.SetTimeout(timeOver, 2)
	end
end