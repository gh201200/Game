local os,print,Screen,require,EventType,PackatHead,Packat_Player,AudioData,SceneType,table,CharacterType,Packat_Battle,Packat_Enemy = 
os,print,Screen,require,EventType,PackatHead,Packat_Player,AudioData,SceneType,table,CharacterType,Packat_Battle,Packat_Enemy
local pairs,ByteArray,math,AttackType,Instantiate,AssetType,GetTransform,CsSetPosition,Destroy,Language = 
pairs,ByteArray,math,AttackType,Instantiate,AssetType,GetTransform,CsSetPosition,Destroy,Language
local Color,Packat_Ship,Packat_CopyMap,tostring,UploadError,string,os,ConstValue,BattleIcon = 
Color,Packat_Ship,Packat_CopyMap,tostring,UploadError,string,os,ConstValue,BattleIcon
local AssetPath,setmetatable,Packat_StarFate = AssetPath,setmetatable,Packat_StarFate
local CFG_starSkill = CFG_starSkill
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mCharacter = require "LuaScript.Mode.Object.Character"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mCharManager = nil
local mBulletManager = nil
local mSystemTip = nil
local mAudioManager = nil
local mBattleAwardPanel = nil
local mTimer = nil
local mBattleSuccessTip = nil
local mBattleFailTip = nil
local mHeroManager = nil
local mAssetManager = nil
local mSceneTip = nil
local mEquipManager = nil
local mBossAwardTip = nil
local mShipEquipManager = nil
local mEventManager = nil
local m3DTextManager = nil
local mSkill = nil
local mBattleTargetManager = nil
-- local mUploadError = true
--战场管理
module("LuaScript.Control.Data.BattleFieldManager")

mBattleFieldList = {}
mBattleFieldListById = {}
mBattleIconBySid = {}

local mSuperSkillTime = nil
local mUpdateTime = nil
local mTimeOverTip = nil

local mHurtList = nil
local mBattleRankId = nil

mAttackTimerList = {}
local metatable = {__mode = 'v'}
setmetatable(mAttackTimerList, metatable)
-- mBattleLogs = {}


function Init()
	mBattleFailTip = require "LuaScript.View.Tip.BattleFailTip"
	mBattleSuccessTip = require "LuaScript.View.Tip.BattleSuccessTip"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mBulletManager = require "LuaScript.Control.Scene.BulletManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mBattleAwardPanel = require "LuaScript.View.Panel.Battle.BattleAwardPanel"
	mTimer = require "LuaScript.Common.Timer"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mSceneTip = require "LuaScript.View.Tip.SceneTip"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mBossAwardTip = require "LuaScript.View.Panel.Main.BossAward"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSkill = require "LuaScript.Mode.Skill.Skill"
	m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
	mBattleTargetManager = require "LuaScript.Control.Scene.BattleTargetManager"
	
	mNetManager.AddListen(PackatHead.BATTLE, Packat_Battle.SYNC_BATTLE_FIELD, AddBattleField)
	mNetManager.AddListen(PackatHead.BATTLE, Packat_Battle.SEND_BATTLE_FIELD_ADD_OBJ, SEND_BATTLE_FIELD_ADD_PLAYER)
	mNetManager.AddListen(PackatHead.BATTLE, Packat_Battle.SEND_BATTLE_FIELD_DEL_OBJ, SEND_BATTLE_FIELD_DEL_PLAYER)
	mNetManager.AddListen(PackatHead.BATTLE, Packat_Battle.SEND_DEL_BATTLE_FIELD, SEND_DEL_BATTLE_FIELD)
	mNetManager.AddListen(PackatHead.BATTLE, Packat_Battle.SEND_BATTLE_FILED_OUT_VIEW, SEND_BATTLE_FILED_OUT_VIEW)
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_ATTACK, SEND_ATTACK)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SEND_ENEMY_ATTACK, SEND_ENEMY_ATTACK)
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_BATTLE_END, SEND_BATTLE_END)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_SHIP_HP_CHG, SEND_SHIP_HP_CHG)
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_BOSS_DMG_RANK, SEND_BOSS_DMG_RANK)
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_BOSS_AWARD, SEND_BOSS_AWARD)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.ENEMY_SUPER_ATTACK, ENEMY_SUPER_ATTACK)
	
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SEND_ENEMY_SUPER_ATTACK_TIME, SEND_ENEMY_SUPER_ATTACK_TIME)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SEND_ENEMY_SUPER_ATTACK_END, SEND_ENEMY_SUPER_ATTACK_END)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.CLIENT_SEND_BATTLE_COMMAND, CLIENT_SEND_BATTLE_COMMAND)
	
	-- mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_USE_BATTLE_SKILL_RLT, SEND_USE_BATTLE_SKILL_RLT)
	-- mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_MAP_BUFF_LIST, SEND_MAP_BUFF_LIST)
	-- mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_MAP_ADD_BUFF, SEND_MAP_ADD_BUFF)
	-- mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_MAP_DEL_BUFF, SEND_MAP_DEL_BUFF)
	
	mEventManager.AddEventListen(nil, EventType.IntoBattleScene, IntoBattleScene)
end

function Reset()
	for k,v in pairs(mAttackTimerList) do
		mTimer.RemoveTimer(v)
	end
end

function GetSuperSkillTime()
	if not mSuperSkillTime then
		return
	end
	
	local last = mSuperSkillTime - os.oldTime + mUpdateTime
	if last > 180 then
		return
	end
	if not mTimeOverTip then
		local hero = mHeroManager.GetHero()
		if hero.map == 1 then
			mSystemTip.ShowTip(string.format("BOSS将于%d秒后释放雷神之怒",last))
		else
			mSystemTip.ShowTip(string.format("城主将于%d秒后释放雷神之怒",last))
		end
	end
	mTimeOverTip = true
	return last
end

function KillAll()
	local shipList = mCharManager.GetShipList()
	local hero = mHeroManager.GetHero()
	for k,ship in pairs(shipList) do
		local char = mCharManager.GetChar(ship.cid)
		if not ship.dead and char.type == CharacterType.Player then
			if hero.id == ship.cid then
				mHeroManager.Sink(ship.id)
			else
				mCharManager.Sink(ship.id)
			end
			mSceneTip.ShowTip(ship.x,0,ship.y-40, -999999, Color.RedStr)
		end
	end
end

function ClearAll()
	local hero = mHeroManager.GetHero()
	if hero then
		hero.battleId = nil
	end
	
	for _,csBattleIcon in pairs(mBattleIconBySid) do
		Destroy(csBattleIcon)
	end
	
	mBattleFieldList = {}
	mBattleFieldListById = {}
	mBattleIconBySid = {}
	-- mBattleLogs = {}
	
	mTimeOverTip = nil
	mSuperSkillTime = nil

end

function IntoBattleScene()
	mBattleRankId = nil
end

function GetBattleFieldList()
	return mBattleFieldList
end

function GetBattleField(id)
	return mBattleFieldListById[id]
end

function GetHurtList()
	local hero = mHeroManager.GetHero()
	if mHurtList and (not mBattleFieldListById[mHurtList.battleId] and hero.SceneType ~= SceneType.Battle) then
		mHurtList = nil
	end
	return mHurtList
end

function GetBattleFieldId(type, id)
	if type == CharacterType.Harbor then
		for k,battleField in pairs(mBattleFieldListById) do
			local id = id * 10 + type
			local char = battleField.charList[id]
			if char then
				return battleField.id,char.team
			end
		end
	else
		local char = mCharManager.GetChar(id)
		if char.battleId then
			local id = id * 10 + type
			local battleField = mBattleFieldListById[char.battleId]
			-- if not battleField and mBattleLogs[char.battleId] then
				-- local logStr = string.format("target Id = %d type = %d \n", id, type)
				-- logStr = logStr .. table.concat(mBattleLogs[char.battleId],"\n")
				-- UploadError(logStr)
				-- return
			-- end
			
			local char = battleField.charList[id]
			return battleField.id,char.team
		end
	end
end

function SEND_ATTACK(cs_ByteArray)
	-- print("SEND_ATTACK")
	local dwAttacker = ByteArray.ReadInt(cs_ByteArray)
	local byAttackerShipIndex = ByteArray.ReadInt(cs_ByteArray)
	local dwTarget = ByteArray.ReadInt(cs_ByteArray)
	local byTargetType = ByteArray.ReadByte(cs_ByteArray)
	local byTargetShipIndex = ByteArray.ReadInt(cs_ByteArray)
	local byAttackerShipId = mCommonlyFunc.GetUid(dwAttacker,CharacterType.Player,byAttackerShipIndex)
	local byTargetShipId = mCommonlyFunc.GetUid(dwTarget, byTargetType, byTargetShipIndex)
	local nRealDeltaHp = ByteArray.ReadInt(cs_ByteArray)
	local byCount = ByteArray.ReadByte(cs_ByteArray)
	local damageTotal = ByteArray.ReadInt(cs_ByteArray)
	local byAttackType = ByteArray.ReadByte(cs_ByteArray)
	local destroy = ByteArray.ReadByte(cs_ByteArray)
	local skill = ByteArray.ReadByte(cs_ByteArray)
	
	Attack(byAttackerShipId, byTargetShipId, byAttackType, byCount, damageTotal, nRealDeltaHp, destroy, skill)
end

function SEND_ENEMY_ATTACK(cs_ByteArray)
	-- print("SEND_ENEMY_ATTACK") 
	local byType = ByteArray.ReadByte(cs_ByteArray)
	local dwAttacker = ByteArray.ReadInt(cs_ByteArray)
	local byAttackerShipIndex = ByteArray.ReadInt(cs_ByteArray)
	local dwTarget = ByteArray.ReadInt(cs_ByteArray)
	local byTargetType = ByteArray.ReadByte(cs_ByteArray)
	local byTargetShipIndex = ByteArray.ReadInt(cs_ByteArray)
	local byAttackerShipId = mCommonlyFunc.GetUid(dwAttacker,byType,byAttackerShipIndex)
	local byTargetShipId = mCommonlyFunc.GetUid(dwTarget, byTargetType, byTargetShipIndex)
	local nRealDeltaHp = ByteArray.ReadInt(cs_ByteArray)
	local byCount = ByteArray.ReadByte(cs_ByteArray)
	local damageTotal = ByteArray.ReadInt(cs_ByteArray)
	local byAttackType = ByteArray.ReadByte(cs_ByteArray)
	local destroy = ByteArray.ReadByte(cs_ByteArray)
	local skill = ByteArray.ReadByte(cs_ByteArray)
	
	Attack(byAttackerShipId, byTargetShipId, byAttackType, byCount, damageTotal, nRealDeltaHp, destroy, skill)
end

function Attack(fromShipId, toShipId, attackType, count, damageTotal, realDeltaHp, destroy, skill)
	local hero = mHeroManager.GetHero()
	if hero.SceneType ~= SceneType.Battle then
		return
	end
	
	local fromShip = mCharManager.GetShip(fromShipId)
	if fromShip and fromShip.lastBulletTime and os.oldClock - fromShip.lastBulletTime < ConstValue.MinBulletInterval then
		function okFunc()
			Attack(fromShipId, toShipId, attackType, count, damageTotal, realDeltaHp, destroy)
		end
		local timer = mTimer.SetTimeout(okFunc, ConstValue.MinBulletInterval)
		table.insert(mAttackTimerList, timer)
		return
	end
	if fromShip then
		fromShip.lastBulletTime = os.oldClock
	end
	
	local fromCsShip = mCharManager.GetCsShip(fromShipId)
	local toShip = mCharManager.GetShip(toShipId)
	local toCsShip = mCharManager.GetCsShip(toShipId)
	local missCount = 0
	if AttackType.Miss == attackType then
		missCount = 3
	elseif AttackType.Hit == attackType then
		missCount = math.min(math.ceil(count*0.3),3)
	end

	if fromShip and fromCsShip and toShip and toCsShip then
		mBulletManager.InitBullet(count, missCount, attackType, damageTotal, realDeltaHp, fromCsShip, toCsShip, fromShip, toShip, destroy)
	elseif toShip and toCsShip then
		mBulletManager.ChangeHp(toShip, realDeltaHp, destroy)
	end
	
	if fromShip then
		if skill == 1 then
			mSceneTip.ShowTip(fromShip.x,0,fromShip.y-40, "连击", Color.OrangeStr, "Rise&Sacle")
		elseif skill == 2 then
			mSceneTip.ShowTip(fromShip.x,0,fromShip.y-40, "散射", Color.OrangeStr, "Rise&Sacle")
		end
	end
end

function AddBattleField(cs_ByteArray)
	-- print("AddBattleField")
	local battleField = {}
	battleField.charList = {}
	battleField.team = {[0]={},[1]={}}
	battleField.id = ByteArray.ReadInt(cs_ByteArray)
	local nCount = ByteArray.ReadByte(cs_ByteArray)
	battleField.x = ByteArray.ReadShort(cs_ByteArray)
	battleField.y = ByteArray.ReadShort(cs_ByteArray)
	
	
	-- mBattleLogs[battleField.id] = {"AddBattleField " .. battleField.id}
	
	
	local hero = mHeroManager.GetHero()
	-- print(battleField.x, battleField.y)
	for i=1,nCount,1 do
		local charId = ByteArray.ReadInt(cs_ByteArray)
		local type = ByteArray.ReadByte(cs_ByteArray)
		local team = ByteArray.ReadByte(cs_ByteArray)
		local char = {id=charId,type=type,team=team}
		-- print(team)
		-- print(battleField.team)
		table.insert(battleField.team[team], char)
		
		local id = charId * 10 + type
		battleField.charList[id] = char
		
		local mChar = mCharManager.GetChar(char.id)
		if mChar and mChar.id ~= hero.id then
			mChar.battleId = battleField.id
			mChar.team = team
			
			InitBattleIcon(mChar)
		end
		
		-- table.insert(mBattleLogs[battleField.id], 
			-- string.format("add char id = %d type = %d char = %s", charId, type, tostring(mChar)))
		
	end
	if not mBattleFieldListById[battleField.id] then
		table.insert(mBattleFieldList, battleField)
	end
	
	mBattleFieldListById[battleField.id] = battleField
	
	-- table.insert(mBattleLogs[battleField.id], "AddBattleField Over!")
end


function SEND_BATTLE_FIELD_ADD_PLAYER(cs_ByteArray)
	-- print("SEND_BATTLE_FIELD_ADD_PLAYER")
	local battleId = ByteArray.ReadInt(cs_ByteArray)
	local charId = ByteArray.ReadInt(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local team = ByteArray.ReadByte(cs_ByteArray)
	
	local id = charId * 10 + type
	local battleField = mBattleFieldListById[battleId]
	if battleField and not battleField.charList[id] then
		local char = {id=charId,type=type,team=team}
		battleField.charList[id] = char
		table.insert(battleField.team[team], char)
	end
	
	if battleField then
		battleField.teamInfo1 = nil
		battleField.teamInfo2 = nil
		battleField.shortInfo = nil
	end
	
	local char = mCharManager.GetChar(charId)
	local hero = mHeroManager.GetHero()
	if char and hero.id ~= charId then
		char.battleId = battleId
		char.team = team
		char.fake = true
		
		InitBattleIcon(char)
	end
	
	-- mBattleLogs[battleId] = mBattleLogs[battleId] or {}
	-- table.insert(mBattleLogs[battleId], 
			-- string.format("add char id = %d type = %d char = %s", charId, type, tostring(char)))
end

function SEND_BATTLE_FIELD_DEL_PLAYER(cs_ByteArray)
	-- print("SEND_BATTLE_FIELD_DEL_PLAYER")
	local type = ByteArray.ReadByte(cs_ByteArray)
	local battleId = ByteArray.ReadInt(cs_ByteArray)
	local charId = ByteArray.ReadInt(cs_ByteArray)
	local battleField = mBattleFieldListById[battleId]
	if battleField then
		local id = charId * 10 + type
		local char = battleField.charList[id]	
		if char then
			local team = battleField.team[char.team]
			
			battleField.charList[id] = nil
			for k,v in pairs(team) do
				if v.id == charId then
					table.remove(team, k)
					break
				end
			end
			
			battleField.teamInfo1 = nil
			battleField.teamInfo2 = nil
			battleField.shortInfo = nil
		end
	end
	
	
	local char = mCharManager.GetChar(charId)
	DestroyBattleIcon(char)
	
	local hero = mHeroManager.GetHero()
	if charId == hero.id then
		char.battleId = nil
	elseif char then
		if char.fake then
			mCharManager.DestroyChar(char)
		end
		char.battleId = nil
	end
	
	-- mBattleLogs[battleId] = mBattleLogs[battleId] or {}
	-- table.insert(mBattleLogs[battleId], 
			-- string.format("remove char id = %d type = %d char = %s", charId, type, tostring(char)))
end

function SEND_DEL_BATTLE_FIELD(cs_ByteArray)
	-- print("SEND_DEL_BATTLE_FIELD")
	local battleId = ByteArray.ReadInt(cs_ByteArray)
	local battleField = mBattleFieldListById[battleId]
	-- print(battleField.charList)
	if battleField then
		for _,char in pairs(battleField.charList) do
			local char = mCharManager.GetChar(char.id)
			if char then
				char.battleId = nil
			end
		end
	end
	for k,battle in pairs(mBattleFieldList) do
		if battle.id == battleId then
			table.remove(mBattleFieldList, k)
			break
		end
	end
	mBattleFieldListById[battleId] = nil
	
	-- mBattleLogs[battleId] = mBattleLogs[battleId] or {}
	-- table.insert(mBattleLogs[battleId], "RemoveBattleField Over!")
end

function SEND_BATTLE_FILED_OUT_VIEW(cs_ByteArray)
	-- print("SEND_BATTLE_FILED_OUT_VIEW")
	local battleId = ByteArray.ReadInt(cs_ByteArray)
	local battleField = mBattleFieldListById[battleId]
	local hero = mHeroManager.GetHero()
	-- print(battleField.charList)
	if battleField then
		for _,char in pairs(battleField.charList) do
			local char = mCharManager.GetChar(char.id)
			if char and hero.id ~= char.id then
				mCharManager.DestroyChar(char)
			end
		end
	end
	for k,battle in pairs(mBattleFieldList) do
		if battle.id == battleId then
			table.remove(mBattleFieldList, k)
			break
		end
	end
	mBattleFieldListById[battleId] = nil
	
	-- mBattleLogs[battleId] = mBattleLogs[battleId] or {}
	-- table.insert(mBattleLogs[battleId], "BattleField Out View!")
end

function SEND_BATTLE_END(cs_ByteArray)
	local win = ByteArray.ReadBool(cs_ByteArray)
	if win then
		mBattleSuccessTip.ShowTip()
		mAudioManager.StopAuidioLoop()
		mAudioManager.PlayAudioOneShot(AudioData.battleSucc)
	else
		mBattleFailTip.ShowTip()
	end
end

function SEND_SHIP_HP_CHG(cs_ByteArray)
	-- print("SEND_SHIP_HP_CHG")
	local ftype = ByteArray.ReadByte(cs_ByteArray)
	local fid = ByteArray.ReadInt(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local index = ByteArray.ReadInt(cs_ByteArray)
	local deltaHp = ByteArray.ReadInt(cs_ByteArray)
	local realDeltaHp = ByteArray.ReadInt(cs_ByteArray)
	local destroy = ByteArray.ReadByte(cs_ByteArray)
	
	-- print(type, id, index,deltaHp,realDeltaHp)
	local shipId = mCommonlyFunc.GetUid(id,type,index)
	local ship = mCharManager.GetShip(shipId)
	if not ship then
		return
	end
	mBulletManager.ChangeHp(ship, realDeltaHp, destroy)
	
	local hero = mHeroManager.GetHero()
	if fid == hero.id or id == hero.id then
		if deltaHp < 0 then
			mSceneTip.ShowTip(ship.x,0,ship.y-40, "反伤\n"..deltaHp, Color.RedStr)
		elseif deltaHp > 0 then
			mSceneTip.ShowTip(ship.x,0,ship.y-40, "+"..deltaHp, Color.LimeStr)
		end
	end
end

function SEND_BOSS_DMG_RANK(cs_ByteArray)
	-- print("SEND_BOSS_DMG_RANK")
	local battleId = ByteArray.ReadInt(cs_ByteArray)
	if mBattleRankId then
		if mBattleRankId ~= battleId then
			return
		end
	else
		mBattleRankId = battleId
	end
	
	local rank = ByteArray.ReadByte(cs_ByteArray)
	local hurt = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	
	mHurtList = {}
	mHurtList.battleId = battleId
	mHurtList.rank = rank
	mHurtList.hurt = math.floor(hurt/100).."K"
	mHurtList.rankList = {}
	for i=1,count do
		local id = ByteArray.ReadInt(cs_ByteArray)
		local hurt = ByteArray.ReadInt(cs_ByteArray)
		
		table.insert(mHurtList.rankList, {id=id,hurt=math.floor(hurt/100).."K"})
	end
end

function SEND_BOSS_AWARD(cs_ByteArray)
	local eid = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	local money = ByteArray.ReadInt(cs_ByteArray)
	local exp = ByteArray.ReadInt(cs_ByteArray)
	-- print(count)
	local items = {}
	for i=1,count do
		local type = ByteArray.ReadByte(cs_ByteArray)
		-- print(type)
		local index = ByteArray.ReadInt(cs_ByteArray)
		-- print(index)
		local count = ByteArray.ReadInt(cs_ByteArray)
		-- print(count)
		local item = {type=type,index=index,count=count}
		
		if item.type == 0 then
			item.id = item.index
		elseif item.type == 1 then
			local obj = mEquipManager.GetEquipByIndex(item.index)
			item.id = obj.id
		elseif item.type == 2 then
			local obj = mShipEquipManager.GetEquipByIndex(item.index)
			item.id = obj.id
		end
		
		-- item.star = 0
		item.notExist = true
		table.insert(items, item)
	end
	local award = {items=items,money=money,exp=exp,eid=eid}
	
	mBossAwardTip.AddAward(award)
end


function CLIENT_SEND_BATTLE_COMMAND(cs_ByteArray)
	-- local cs_ByteArray = ByteArray.Init()
	-- ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	-- ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_SEND_BATTLE_COMMAND)
	local hero = mHeroManager.GetHero()
	-- if hero.SceneType ~= SceneType.Battle then
		-- return
	-- end
	
	local type = ByteArray.ReadInt(cs_ByteArray)
	local x = ByteArray.ReadInt(cs_ByteArray)
	local y = ByteArray.ReadInt(cs_ByteArray)
	local team = ByteArray.ReadInt(cs_ByteArray)
	local name = ByteArray.ReadUTF(cs_ByteArray,40)
	if team ~= hero.team then
		return
	end
	local str = nil
	local animatorName = nil
	if type == 1 then
		str = string.format(Language[224], name)
		animatorName = "Red"
	else
		str = string.format(Language[225], name)
		animatorName = "Greed"
	end
	mBattleTargetManager.ShowTarget(str, x, y, animatorName)
end


function RequestLeave()
	-- print("RequestLeave")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_LEAVE_BATTLE)
	mNetManager.SendData(cs_ByteArray)
end

function RunAway()
	-- print("RunAway")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.PLAYER_RUN_AWAY)
	mNetManager.SendData(cs_ByteArray)
end

function RequestJoin(mBattleFieldId, team)
	-- print(mBattleFieldId, team)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_JOIN_BATTLE)
	ByteArray.WriteInt(cs_ByteArray,mBattleFieldId)
	ByteArray.WriteByte(cs_ByteArray,team)
	mNetManager.SendData(cs_ByteArray)
end

function RequestAttack(mBattleFieldId, team)
	if team == 1 then
		team = 0
	else
		team = 1
	end
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_JOIN_BATTLE)
	ByteArray.WriteInt(cs_ByteArray,mBattleFieldId)
	ByteArray.WriteByte(cs_ByteArray,team)
	mNetManager.SendData(cs_ByteArray)
end

function RequestCommand(type, x, y, team, name)
	-- print("RequestCommand",type, x, y, team, name)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_SEND_BATTLE_COMMAND)
	ByteArray.WriteInt(cs_ByteArray,type)
	ByteArray.WriteInt(cs_ByteArray,x)
	ByteArray.WriteInt(cs_ByteArray,y)
	ByteArray.WriteInt(cs_ByteArray,team)
	ByteArray.WriteUTF(cs_ByteArray,name,40)
	mNetManager.SendData(cs_ByteArray)
end

function RequestUseSkill(id)
	-- print("RequestUseSkill", id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_USE_SKILL)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function DestroyBattleIcon(char)
	if not char or not char.ships then
		return
	end
	for _,ship in pairs(char.ships) do
		Destroy(mBattleIconBySid[ship.id])
		mBattleIconBySid[ship.id] = nil
	end
end

function InitBattleIcon(char)
	local asset = mAssetManager.GetAsset(AssetPath.BattleIcon, AssetType.Forever)
	
	for k,ship in pairs(char.ships) do
		local battleIcon = mBattleIconBySid[ship.id] or Instantiate(asset)
		
		CsSetPosition(GetTransform(battleIcon), ship.x, 115, ship.y)
		mBattleIconBySid[ship.id] = battleIcon
	end
end

function ChangeAllX()
	for k,v in pairs(mBattleIconBySid) do
		local ship = mCharManager.GetShip(k)
		if ship then
			CsSetPosition(GetTransform(v), ship.x, 115, ship.y)
		end
	end
end

function ENEMY_SUPER_ATTACK()
	-- print("ENEMY_SUPER_ATTACK")
	local skillFunc = mSkill.GetSkill(1)
	skillFunc()
end

function SEND_ENEMY_SUPER_ATTACK_TIME(cs_ByteArray)
	-- print("SEND_ENEMY_SUPER_ATTACK_TIME")
	mSuperSkillTime = ByteArray.ReadShort(cs_ByteArray)
	mUpdateTime = os.oldTime
end

function SEND_ENEMY_SUPER_ATTACK_END()
	-- print("SEND_ENEMY_SUPER_ATTACK_END")
	mSuperSkillTime = nil
end