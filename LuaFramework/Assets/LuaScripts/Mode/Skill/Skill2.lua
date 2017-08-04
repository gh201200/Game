local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs,CsStopEmit,setfenv
local Color,print,getfenv = Color,print,getfenv
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
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
module("LuaScript.Mode.Skill.Skill2")

function start(fromShip, toShip, value, realValue, destroy)
	local csShip = mCharManager.GetCsShip(toShip.id)
	if not csShip then
		return
	end
	
	
	if CsStopEmit then
		function timeOver()
			-- local ship = mCharManager.GetShip(shipId)
			-- if not ship then
				-- return
			-- end
			
			local buffs = toShip.buffs
			if not buffs or not buffs[25] then
				return
			end
			
			local buff = buffs[25]
			-- print(CsIsNull(buff.effect))
			if buff.effect and not CsIsNull(buff.effect) then
				CsStopEmit(buff.effect)
			end
		end
		
		-- local t = {shipId = ship.id,print=print, mCharManager=mCharManager, CsStopEmit=CsStopEmit}
		-- setfenv(timeOver, t)
		mTimer.SetTimeout(timeOver, 1.5)
	end
	mAudioManager.PlayAudioOneShot(AudioSkill[2])
	mBulletManager.ChangeHp(toShip, realValue, destroy)
	mSkillManager.AddEffect(25, toShip, csShip)
	mSceneTip.ShowTip(toShip.x, 0, toShip.y, "+"..value, Color.LimeStr)
end