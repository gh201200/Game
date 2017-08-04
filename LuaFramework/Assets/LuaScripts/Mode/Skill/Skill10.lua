local SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs = 
SceneType,AssetType,CsInstantiate,math,table,Destroy,string,ConstValue,GetTransform,CsSetPosition,pairs
local AudioSkill,UnityEngine = AudioSkill,UnityEngine
local Color,print = Color,print
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
local mCharManager = require "LuaScript.Control.Scene.CharManager"
local mParticleSystemType = UnityEngine.ParticleSystem.GetClassType()
module("LuaScript.Mode.Skill.Skill10")

function start(ship, value, _, _, _, attackList)
	-- print(attackList)
	-- mSceneTip.ShowTip(ship.x, 0, ship.y, "-"..value, Color.RedStr)
	
	local csEffectList = {}
	
	-- local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,40), AssetType.Forever)
	-- local obj = CsInstantiate(csAsset)
	-- table.insert(csEffectList, obj)
	

	local csShip = mCharManager.GetCsShip(ship.id)
	local char = mCharManager.GetChar(ship.cid)
	local csEffect = mSkillManager.AddEffect(40, ship, csShip, obj)
	table.insert(csEffectList, csEffect)
	for k, v in pairs(char.ships) do
		if v ~= ship then
			local csShip = mCharManager.GetCsShip(v.id)
			local csEffect = mSkillManager.AddEffect(41, v, csShip)
			table.insert(csEffectList, csEffect)
		end
	end
	
	function intervalFunc()
		-- print("stop")
		-- if csEffectList[1] and csEffectList[1]:Equals(nil) then
			-- return
		-- end
		for _,v in pairs(csEffectList) do
			if not v:Equals(nil) then
				local list = v:GetComponentsInChildren(mParticleSystemType)
				for i=0,list.Length-1 do
					list[i].loop = false
				end
			end
		end
	end
	
	local mInterval = mTimer.SetTimeout(intervalFunc, 10)
	-- intervalFunc()
	
	mAudioManager.PlayAudioOneShot(AudioSkill[10])
end