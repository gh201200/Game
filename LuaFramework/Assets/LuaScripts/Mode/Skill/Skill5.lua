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
local mSkillManager = require "LuaScript.Control.Scene.SkillManager"
local mSceneTip = require "LuaScript.View.Tip.SceneTip"
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
module("LuaScript.Mode.Skill.Skill5")

function start(fromShip, toShip, value, realValue, destroy)
	mBulletManager.ChangeHp(toShip, realValue, destroy)
	mSceneTip.ShowTip(toShip.x, 0, toShip.y, value, Color.RedStr)
	mSkillManager.AddEffect(7, toShip)
	mAudioManager.PlayAudioOneShot(AudioSkill[5])
end