local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs
local Color = Color
local AudioSkill = AudioSkill
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mTimer = require "LuaScript.Common.Timer"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mSceneTip = require "LuaScript.View.Tip.SceneTip"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
local mCameraManager = require "LuaScript.Control.CameraManager"
module("LuaScript.Mode.Skill.Skill15")

local mPostList = {
{{87,278},{-39,178},{-172,-121}}  ,
{{-360,-7},{248,-32}}  ,
{{384,-8},{-374,-236},{477,202}}  ,
{{-247,198}}  ,
{{-266,-82},{-216,-215},{45,16}}  ,
{{493,-262},{393,151}} ,
{{-386,266},{27,194}}}

function start(fromShip, toShip, value, realValue, destroy, attackList)
	local list = {}
	local hero = mHeroManager.GetHero()
	local index = 1
	function intervalFunc()
		local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,7), AssetType.Forever)
		if not csAsset then
			return
		end
		
		if hero.SceneType ~= SceneType.Battle then
			return
		end
		if not mPostList[index] then
			return
		end
		mAudioManager.PlayAudioOneShot(AudioSkill[5])
		for i=1,#mPostList[index] do
			local obj = CsInstantiate(csAsset)
			table.insert(list, obj)
			CsSetPosition(GetTransform(obj), hero.x + mPostList[index][i][1],0, hero.y+ mPostList[index][i][2])
		end
		
		index = index + 1
		mCameraManager.Shock()
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
	
	for k,v in pairs(attackList) do
		mBulletManager.ChangeHp(v[2], v[4], v[5])
		mSceneTip.ShowTip(v[2].x, 0, v[2].y, v[3], Color.RedStr)
	end
end