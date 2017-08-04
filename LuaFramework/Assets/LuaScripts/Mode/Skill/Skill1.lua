local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs
local AudioSkill = AudioSkill
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mTimer = require "LuaScript.Common.Timer"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
module("LuaScript.Mode.Skill.Skill1")

function start()
	local list = {}
	local hero = mHeroManager.GetHero()
	
	function intervalFunc()
		local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,7), AssetType.Forever)
		if not csAsset then
			return
		end
		
		if hero.SceneType ~= SceneType.Battle then
			return
		end
		mAudioManager.PlayAudioOneShot(AudioSkill[5])
		for i=1,math.random(3) do
			local obj = CsInstantiate(csAsset)
			table.insert(list, obj)
			CsSetPosition(GetTransform(obj), hero.x + math.random(1000)-500,0, hero.y+ math.random(600)-300)
		end
	end
	local mInterval = mTimer.SetInterval(intervalFunc, 0.2)
	intervalFunc()


	function timeOver1()
		mTimer.RemoveTimer(mInterval)
	end
	mTimer.SetTimeout(timeOver1, 1.5)

	function timeOver2()
		for k,v in pairs(list) do
			Destroy(v)
		end
	end
	mTimer.SetTimeout(timeOver2, 2)
	
	mBattleManager.KillAll()
end