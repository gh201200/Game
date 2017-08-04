local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsRotate = 
Destroy,GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsRotate
local Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,string,CsInstantiateInParent = 
Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,string,CsInstantiateInParent
local CFG_skillEffect,Packat_Ship,CsSetScale,VersionCode,CsInstantiate,setfenv,Packat_StarFate,AppearEvent = 
CFG_skillEffect,Packat_Ship,CsSetScale,VersionCode,CsInstantiate,setfenv,Packat_StarFate,AppearEvent
local CFG_starSkill,CharacterType,error,tostring = CFG_starSkill,CharacterType,error,tostring
local mCharacter = require "LuaScript.Mode.Object.Character"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mTimer = require "LuaScript.Common.Timer"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mCharManager = nil
local mNetManager = require "LuaScript.Control.System.NetManager"
local mSkill = nil
local mSceneTip = nil
local mHeroManager = nil
module("LuaScript.Control.Scene.SkillManager")

local mSceneEffect = {}
local mSceneEffectIndex = 100000
local mBuffList = {}

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mSkill = require "LuaScript.Mode.Skill.Skill"
	mSceneTip = require "LuaScript.View.Tip.SceneTip"
	
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_ADD_SHIP_EFFECT, SEND_ADD_SHIP_EFFECT)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_DEL_SHIP_EFFECT, SEND_DEL_SHIP_EFFECT)
	
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_USE_BATTLE_SKILL_RLT, SEND_USE_BATTLE_SKILL_RLT)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_MAP_BUFF_LIST, SEND_MAP_BUFF_LIST)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_MAP_ADD_BUFF, SEND_MAP_ADD_BUFF)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_MAP_DEL_BUFF, SEND_MAP_DEL_BUFF)
	
	mEventManager.AddEventListen(nil, EventType.IntoBattleScene, IntoBattleScene)
end

function IntoBattleScene()
	-- for k,v in pairs(mSceneEffect) do
		-- Destroy(v)
	-- end
	mBuffList = {}
	-- mSceneEffect = {}
end

function SEND_USE_BATTLE_SKILL_RLT(cs_ByteArray)
	-- print("SEND_USE_BATTLE_SKILL_RLT")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local shopId = ByteArray.ReadInt(cs_ByteArray)
	local skillId = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadByte(cs_ByteArray)
	
	local formShipId = mCommonlyFunc.GetUid(id,type,shopId)
	local formShip = mCharManager.GetShip(formShipId)
	if not formShip then
		-- local char = mCharManager.GetChar(id)
		-- local hero = mHeroManager.GetHero()
		-- local str = "id="..id..",type="..type..",shopId="..shopId..",skillId="..skillId..",char="..tostring(char).."\nbattleLog....\n"..table.concat( hero.battleLog,"\n")
		-- error("skill error!"..str)
		return
	end
	-- print(id,type,shopId,skillId)
	local hero = mHeroManager.GetHero()
	-- if id == hero.id and skillId == 24 then
		-- mSceneTip.ShowTip(hero.x, 0, hero.y, "战斗力提升!!!", Color.RedStr, "Rise&Sacle")
	-- end
	
	local cfg_starSkill = CFG_starSkill[skillId]
	local attackList = {}
	for i=1,count do
		local toId = ByteArray.ReadInt(cs_ByteArray)
		local toType = ByteArray.ReadByte(cs_ByteArray)
		local toShopId = ByteArray.ReadInt(cs_ByteArray)
		local changeHp = ByteArray.ReadInt(cs_ByteArray)
		local realChgHp = ByteArray.ReadInt(cs_ByteArray)
		local destroy = ByteArray.ReadByte(cs_ByteArray)
		
		local toShipId = mCommonlyFunc.GetUid(toId,toType,toShopId)
		local toShip = mCharManager.GetShip(toShipId)
		-- print(toId,toType,toShopId,changeHp,realChgHp,destroy)
		if toShip then
			if (cfg_starSkill.target == 2 or cfg_starSkill.target == 5 or cfg_starSkill.target == 4) then
				table.insert(attackList, {formShip,toShip,changeHp,realChgHp,destroy})
			else
				local skillFuc = mSkill.GetSkill(cfg_starSkill.ScriptId)
				skillFuc(formShip,toShip,changeHp,realChgHp,destroy)
				-- print(cfg_starSkill.ScriptId)
			end
		end
	end
	
	if (cfg_starSkill.target == 2 or cfg_starSkill.target == 5 or cfg_starSkill.target == 4) then
		-- print(cfg_starSkill.ScriptId)
		local skillFuc = mSkill.GetSkill(cfg_starSkill.ScriptId)
		skillFuc(formShip,nil,nil,nil,nil,attackList)
	end
	if id == hero.id then
		AppearEvent(nil, EventType.UseBattleSkill, skillId)
	end
end


function SEND_MAP_BUFF_LIST(cs_ByteArray)
	-- print("SEND_MAP_BUFF_LIST")
	local count = ByteArray.ReadInt(cs_ByteArray)
	local buffs = {}
	for i=1,count,1 do
		local buffid = ByteArray.ReadInt(cs_ByteArray)
		local skillId = ByteArray.ReadInt(cs_ByteArray)
		local nParam1 = ByteArray.ReadInt(cs_ByteArray)
		local nParam2 = ByteArray.ReadInt(cs_ByteArray)
		
		local cfg_starSkill = CFG_starSkill[skillId]
		if cfg_starSkill.ScriptId == 13 then
			buff = {buffid=buffid,skillId=skillId,nParam1=nParam1,nParam2=nParam2}
			mBuffList[buffid] = buff
			-- local skillFuc = mSkill.GetSkill(cfg_starSkill.ScriptId)
			if cfg_starSkill.target == 3 then
				local formShipId = mCommonlyFunc.GetUid(nParam1,CharacterType.Player,nParam2)
				-- skillFuc(formShipId)
				AddSkill(1, formShipId)
			else
				local char = mCharManager.GetChar(nParam1)
				if char.ships[1] and not char.ships[1].dead then
					-- skillFuc(char.ships[1])
					AddSkill(1, char.ships[1].id)
				end
				if char.ships[2] and not char.ships[2].dead then
					-- skillFuc(char.ships[2])
					AddSkill(1, char.ships[2].id)
				end
				if char.ships[3] and not char.ships[3].dead then
					-- skillFuc(char.ships[3])
					AddSkill(1, char.ships[3].id)
				end
			end
		end
		-- print(buffid,skillId,nParam1,nParam2)
		
	end
	
end

function SEND_MAP_ADD_BUFF(cs_ByteArray)
	-- print("SEND_MAP_ADD_BUFF")
	local buffid = ByteArray.ReadInt(cs_ByteArray)
	local skillId = ByteArray.ReadInt(cs_ByteArray)
	local nParam1 = ByteArray.ReadInt(cs_ByteArray)
	local nParam2 = ByteArray.ReadInt(cs_ByteArray)
	
	local cfg_starSkill = CFG_starSkill[skillId]
	if cfg_starSkill.ScriptId == 13 then
		local skillFuc = mSkill.GetSkill(cfg_starSkill.ScriptId)
		buff = {buffid=buffid,skillId=skillId,nParam1=nParam1,nParam2=nParam2}
		mBuffList[buffid] = buff
		if cfg_starSkill.target == 3 then
			local formShipId = mCommonlyFunc.GetUid(nParam1,CharacterType.Player,nParam2)
			local ship = mCharManager.GetShip(formShipId)
			if not ship then
				return
			end
			skillFuc(ship)
			-- AddSkill(1, formShipId)
		else
			local char = mCharManager.GetChar(nParam1)
			if not char then
				return
			end
			if char.ships[1] and not char.ships[1].dead then
				skillFuc(char.ships[1])
				-- AddSkill(1, char.ships[1].id)
			end
			if char.ships[2] and not char.ships[2].dead then
				skillFuc(char.ships[2])
				-- AddSkill(1, char.ships[2].id)
			end
			if char.ships[3] and not char.ships[3].dead then
				skillFuc(char.ships[3])
				-- AddSkill(1, char.ships[3].id)
			end
		end
	end
	
	-- print(buffid,skillId,nParam1,nParam2)
end

function SEND_MAP_DEL_BUFF(cs_ByteArray)
	-- print("SEND_MAP_DEL_BUFF")
	local buffid = ByteArray.ReadInt(cs_ByteArray)
	-- print(buffid)
	buff = mBuffList[buffid]
	-- print(buff)
	-- {buffid=buffid,skillId=skillId,nParam1=nParam1,nParam2=nParam2}
	if not buff then
		return
	end
	
	local cfg_starSkill = CFG_starSkill[buff.skillId]
	if cfg_starSkill.ScriptId == 13 then
		local skillFuc = mSkill.GetSkill(cfg_starSkill.ScriptId)
		if cfg_starSkill.target == 3 then
			local formShipId = mCommonlyFunc.GetUid(buff.nParam1,CharacterType.Player,buff.nParam2)
			-- skillFuc(nParam1,nParam2)
			RemoveSkill(1, formShipId)
		else
			local char = mCharManager.GetChar(buff.nParam1)
			if not char then
				return
			end
			if char.ships[1] and not char.ships[1].dead then
				-- skillFuc(char.ships[1])
				RemoveSkill(1, char.ships[1].id)
			end
			if char.ships[2] and not char.ships[2].dead then
				-- skillFuc(char.ships[2])
				RemoveSkill(1, char.ships[2].id)
			end
			if char.ships[3] and not char.ships[3].dead then
				-- skillFuc(char.ships[3])
				RemoveSkill(1, char.ships[3].id)
			end
		end
	end
end

function SEND_ADD_SHIP_EFFECT(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local index = ByteArray.ReadInt(cs_ByteArray)
	local shipId = mCommonlyFunc.GetUid(id,type,index)
	local skillId = ByteArray.ReadShort(cs_ByteArray)
	AddSkill(skillId, shipId)
end

function SEND_DEL_SHIP_EFFECT(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local index = ByteArray.ReadInt(cs_ByteArray)
	local shipId = mCommonlyFunc.GetUid(id,type,index)
	local skillId = ByteArray.ReadShort(cs_ByteArray)
	RemoveSkill(skillId, shipId)
end

function AddSkill(skillId, shipId)
	local ship = mCharManager.GetShip(shipId)
	if not ship then
		return
	end
	if ship.buffs and ship.buffs[skillId] then
		return
	end
	
	local csShip = mCharManager.GetCsShip(shipId)
	if not csShip then
		return
	end
	AddEffect(skillId,ship,csShip)
end

function AddEffect(skillId,ship,csShip,_csSkill)
	local cfg_skillEffect = CFG_skillEffect[skillId]
	local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,cfg_skillEffect.resId), AssetType.Forever)
	-- print(csAsset)
	if not csAsset then
		return
	end
	local csSkill = nil
	local scale = cfg_skillEffect.scale
	if cfg_skillEffect.target == 0 then
		if not ship then
			return
		end
		skillId = mSceneEffectIndex
		
		csSkill = _csSkill or CsInstantiate(csAsset)
		if cfg_skillEffect.autoDestroy == 1 then
			mSceneEffect[mSceneEffectIndex] = csSkill
		end
		mSceneEffectIndex = mSceneEffectIndex + 1
		if scale ~= 0 then
			CsSetScale(GetTransform(csSkill), scale, scale, scale)
		end
		CsSetPosition(GetTransform(csSkill), ship.x,ship.z or 0,ship.y)
	else
		if ship and ship.buffs and ship.buffs[skillId] then
			return
		end
		csSkill = _csSkill or CsInstantiateInParent(csAsset,GetTransform(csAsset),GetTransform(csShip))
		
		-- print(csSkill)
		if scale ~= 0 then
			CsSetScale(GetTransform(csSkill), scale, scale, scale)
		end
		
		if ship then
			ship.buffs = ship.buffs or {}
			ship.buffs[skillId] = {id=skillId,effect=csSkill}
		end
	end
	
	
	-- print(cfg_skillEffect.time)
	if cfg_skillEffect.time > 0 then
		function OkFuc()
			-- print(skillId)
			RemoveSkill(skillId, ship.id)
		end
		-- local t = {_skillId=skillId,_shipId=ship.id,RemoveSkill=RemoveSkill}
		-- setfenv(OkFuc, t)
		mTimer.SetTimeout(OkFuc,cfg_skillEffect.time)
	end
	if csSkill then
		return csSkill,mSceneEffectIndex-1
	end
end

function GetSkill(skillId)
	return mSceneEffect[skillId]
end

function RefreshEffect(ship)
	-- print("RefreshSkill")
	if not ship.buffs then
		return
	end
	-- print(ship.buffs)
	for k,v in pairs(ship.buffs) do
		-- print(v.effect)
		if not v.effect then
			local cfg_skillEffect = CFG_skillEffect[v.id]
			local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResSkillPath,cfg_skillEffect.resId), AssetType.Forever)
			local csShip = mCharManager.GetCsShip(ship.id)
			if csShip then
				local csSkill = CsInstantiateInParent(csAsset,GetTransform(csAsset),GetTransform(csShip))
				v.effect = csSkill 
			end
		end
	end
end

function HideEffect(ship)
	if not ship.buffs then
		return
	end
	for k,v in pairs(ship.buffs) do
		v.effect = nil
	end
end

function RemoveSkill(skillId, shipId)
	-- print(skillId)
	if skillId < 100000 then
		local ship = mCharManager.GetShip(shipId)
		if not ship then
			return
		end
		
		local buffs = ship.buffs
		if not buffs or not buffs[skillId] then
			return
		end
		
		local buff = buffs[skillId]
		if buff.effect then
			Destroy(buff.effect)
		end
		buffs[skillId] = nil
	else
		-- print(mSceneEffect[skillId])
		if mSceneEffect[skillId] then
			Destroy(mSceneEffect[skillId])
			mSceneEffect[skillId] = nil
		end
	end
end

function SkillOver(csSkill)
	Destroy(csSkill)
end