local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs
local AudioSkill = AudioSkill
local Color = Color
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
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
module("LuaScript.Mode.Skill.Skill11")

function start(ship, toShip, value, realValue, destroy, attackList)
	-- mSceneTip.ShowTip(ship.x, 0, ship.y, "-"..value, Color.RedStr)
	for k,v in pairs(attackList) do
		mBulletManager.ChangeHp(v[2], v[4], v[5])
		mSceneTip.ShowTip(v[2].x, 0, v[2].y, v[3], Color.RedStr)
	end
	
	mSkillManager.AddEffect(35, ship)
	mAudioManager.PlayAudioOneShot(AudioSkill[11])
end