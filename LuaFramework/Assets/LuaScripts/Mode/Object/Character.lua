local CharacterType,print,CFG_Enemy,CFG_role,require,SceneType,CFG_harbor,pairs,CFG_ship,ByteArray,math = 
CharacterType,print,CFG_Enemy,CFG_role,require,SceneType,CFG_harbor,pairs,CFG_ship,ByteArray,math
local CFG_EnemyPosition,platform,IPhonePlayer,IosTestScript = CFG_EnemyPosition,platform,IPhonePlayer,IosTestScript
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.Mode.Object.Character")
function ReadHeroData(cs_ByteArray)
	local data = {}
	data.type = CharacterType.Player
	data.id = ByteArray.ReadInt(cs_ByteArray)
	data.map = 1
	data.x = 0
	data.y = 0
	data.name = ByteArray.ReadUTF(cs_ByteArray,40)
	data.role = ByteArray.ReadInt(cs_ByteArray)
	data.speed = ByteArray.ReadShort(cs_ByteArray)
	data.realSpeed = data.speed * 9
	-- data.speed = 120
	data.level = ByteArray.ReadShort(cs_ByteArray)
	data.exp = ByteArray.ReadInt(cs_ByteArray)
	data.money = ByteArray.ReadInt(cs_ByteArray)
	data.gold = ByteArray.ReadInt(cs_ByteArray)
	data.vipLevel = ByteArray.ReadByte(cs_ByteArray)
	data.vipExp = ByteArray.ReadInt(cs_ByteArray)
	
	data.familyId = ByteArray.ReadInt(cs_ByteArray)
	data.familyName = ByteArray.ReadUTF(cs_ByteArray,40)
	data.post = ByteArray.ReadByte(cs_ByteArray)
	data.copyMapCount = ByteArray.ReadInt(cs_ByteArray)
	data.copyMapBuyCount = ByteArray.ReadInt(cs_ByteArray)
	
	data.firstRecharge = ByteArray.ReadInt(cs_ByteArray)
	data.totalRecharge = ByteArray.ReadInt(cs_ByteArray)
	data.firstRefreshSailor = ByteArray.ReadBool(cs_ByteArray)
	data.mode = ByteArray.ReadByte(cs_ByteArray)
	data.starPoint = ByteArray.ReadInt(cs_ByteArray)
	
	data.totalCost = 500
	data.business = 0
	-- data.freeRefreshCount = ByteArray.ReadByte(cs_ByteArray)
	if data.familyId == 0 then
		data.familyId = nil
		data.familyName = nil
		data.post = nil
	end
	
	local cfg_role = CFG_role[data.role]
	data.quality = cfg_role.quality
	data.resId = cfg_role.resId
	data.power = ByteArray.ReadInt(cs_ByteArray)
	data.fish = ByteArray.ReadInt(cs_ByteArray)
	data.mlevelAward = ByteArray.ReadInt(cs_ByteArray)
	data.sendId = 1
	-- data.angles = 0
	-- data.MothCard = 1
	-- data.LifeMember  = 1
	--ios test script
	if IosTestScript then
		data.firstRecharge = 1
	end
	return data
end

function ReadEnemyData(cs_ByteArray)
	local data = {}
	data.type = CharacterType.Enemy
	data.id = ByteArray.ReadInt(cs_ByteArray)
	-- print(data.id)
	local eid = ByteArray.ReadShort(cs_ByteArray)
	local cfg_Enemy = CFG_Enemy[eid]
	data.name = cfg_Enemy.name
	data.resId = cfg_Enemy.resId
	data.level = cfg_Enemy.level
	data.power = cfg_Enemy.power
	data.quality = cfg_Enemy.quality
	data.eid = eid
	
	data.ships = {}
	local bid = ByteArray.ReadInt(cs_ByteArray)
	local nShipHp = ByteArray.ReadInt(cs_ByteArray)
	local nShipMaxHp = ByteArray.ReadInt(cs_ByteArray)
	local nindex = 1
	local nShipId = mCommonlyFunc.GetUid(data.id,CharacterType.Enemy,nindex)
	local wShipX = ByteArray.ReadShort(cs_ByteArray)
	local wShipY = ByteArray.ReadShort(cs_ByteArray)
	local wShipDestX = ByteArray.ReadShort(cs_ByteArray)
	local wShipDestY = ByteArray.ReadShort(cs_ByteArray)
	
	if nShipHp == 0 then
		return
	end
	
	local ship = {}
	ship.bid = bid
	ship.index = nindex
	ship.cid = data.id
	ship.id = nShipId
	ship.hp = nShipHp
	ship.maxHp = nShipMaxHp
	ship.x = wShipX
	ship.y = wShipY
	ship.dead = nShipHp==0
	data.ships[nindex] = ship
	
	if wShipX ~= wShipDestX or wShipY ~= wShipDestY then
		data.ships[nindex].move = {}
		data.ships[nindex].move.path = {wShipDestX, wShipDestY}
	end

	data.x = data.ships[nindex].x
	data.y = data.ships[nindex].y
	data.speed = ByteArray.ReadShort(cs_ByteArray)
	data.team = ByteArray.ReadByte(cs_ByteArray)
	
	if mCommonlyFunc.InBattle() then
		ship.angles = (data.team % 2) * 90 + 135
	else
		local cfg_EnemyPosition = CFG_EnemyPosition[eid]
		if not cfg_EnemyPosition then
			ship.angles = math.random(360)
		else
			ship.angles = cfg_EnemyPosition.angles
		end
	end
	
	return data
end

function ReadBattleCharData(cs_ByteArray, char)
	-- print("ReadBattleCharData")
	local data = char or {}
	data.type = CharacterType.Player
	data.id = ByteArray.ReadInt(cs_ByteArray)
	data.name = ByteArray.ReadUTF(cs_ByteArray,40)
	data.role = ByteArray.ReadByte(cs_ByteArray)
	data.level = ByteArray.ReadInt(cs_ByteArray)
	data.power = ByteArray.ReadInt(cs_ByteArray)
	data.ships = {}
	for i=1,3,1 do
		local nShipBaseIndex = ByteArray.ReadInt(cs_ByteArray)
		local nindex = ByteArray.ReadInt(cs_ByteArray)
		local nShipId = mCommonlyFunc.GetUid(data.id,CharacterType.Player,nindex)
		local nShipHp = ByteArray.ReadInt(cs_ByteArray)
		local nShipMaxHp = ByteArray.ReadInt(cs_ByteArray)
		local wShipX = ByteArray.ReadShort(cs_ByteArray)
		local wShipY = ByteArray.ReadShort(cs_ByteArray)
		local wShipDestX = ByteArray.ReadShort(cs_ByteArray)
		local wShipDestY = ByteArray.ReadShort(cs_ByteArray)
		local wShipState = ByteArray.ReadBool(cs_ByteArray)
		-- print(nShipHp,nShipMaxHp)
		if nindex ~= 0 and nShipHp ~= 0 then
			ship = {}
			ship.bid = nShipBaseIndex
			ship.index = nindex
			ship.cid = data.id
			ship.id = nShipId
			ship.hp = nShipHp
			ship.maxHp = nShipMaxHp
			ship.x = wShipX
			ship.y = wShipY
			-- ship.dead = nShipHp==0
			if wShipState then
				ship.move = {}
				ship.move.path = {wShipDestX, wShipDestY}
			end
			
			data.ships[i] = ship
		end
	end
	
	if not data.ships[1] then
		return
	end
	
	data.x = data.ships[1].x
	data.y = data.ships[1].y
	data.speed = ByteArray.ReadShort(cs_ByteArray)
	
	data.familyId = ByteArray.ReadInt(cs_ByteArray)
	data.post = ByteArray.ReadByte(cs_ByteArray)
	data.familyName = ByteArray.ReadUTF(cs_ByteArray,40)
	data.team = ByteArray.ReadByte(cs_ByteArray)
	data.protectState = ByteArray.ReadBool(cs_ByteArray)
	data.mode = ByteArray.ReadByte(cs_ByteArray)
	
	data.title = ByteArray.ReadByte(cs_ByteArray)
	
	local angles = (data.team % 2) * 90 + 135
	for k,ship in pairs(data.ships) do
		ship.angles = angles
	end
	
	
	if data.familyId == 0 then
		data.familyId = nil
		data.familyName = nil
		data.post = nil
	end
	local cfg_role = CFG_role[data.role]
	data.quality = cfg_role.quality
	data.resId = cfg_role.resId
	return data
end



function ReadShipTeamData(cs_ByteArray)
	-- print("ReadShipTeamData")
	local data = {}
	
	mHeroManager = mHeroManager or require "LuaScript.Control.Scene.HeroManager"
	local hero = mHeroManager.GetHero()
	data.type = CharacterType.ShipTeam
	data.id = ByteArray.ReadInt(cs_ByteArray)
	data.charId = ByteArray.ReadInt(cs_ByteArray)
	data.name = "【商】"..ByteArray.ReadUTF(cs_ByteArray,40)
	data.ships = {}
	local nShipBaseIndex = ByteArray.ReadInt(cs_ByteArray)
	local nindex = 1
	local nShipId = mCommonlyFunc.GetUid(data.id,data.type,nindex)
	local nShipHp = ByteArray.ReadInt(cs_ByteArray)
	local nShipMaxHp = ByteArray.ReadInt(cs_ByteArray)
	local wShipX = ByteArray.ReadShort(cs_ByteArray)
	local wShipY = ByteArray.ReadShort(cs_ByteArray)
	local wShipDestX = ByteArray.ReadShort(cs_ByteArray)
	local wShipDestY = ByteArray.ReadShort(cs_ByteArray)
	-- print(wShipX, wShipY)
	
	if nShipHp == 0 then
		return
	end
	
	ship = {}
	ship.bid = nShipBaseIndex
	ship.index = nindex
	ship.cid = data.id
	ship.id = nShipId
	ship.hp = nShipHp
	ship.maxHp = nShipMaxHp
	ship.x = wShipX
	ship.y = wShipY
	ship.dead = nShipHp==0
	data.ships[nindex] = ship

	if wShipDestX ~= wShipX or wShipDestY ~= wShipY then
		ship.move = {}
		ship.move.path = {wShipDestX, wShipDestY}
	end
		
	data.x = ship.x
	data.y = ship.y
	data.speed = ByteArray.ReadShort(cs_ByteArray)
	
	data.power = ByteArray.ReadInt(cs_ByteArray)
	data.role = ByteArray.ReadByte(cs_ByteArray)
	data.team = ByteArray.ReadByte(cs_ByteArray)
	
	local cfg_role = CFG_role[data.role]
	data.quality = cfg_role.quality
	data.resId = cfg_role.resId
	
	ship.angles = 135
	return data
end


function ReadHarborData(cs_ByteArray)
	print("ReadHarborData")
	local data = {}
	data.type = CharacterType.Harbor
	data.id = ByteArray.ReadInt(cs_ByteArray)
	data.harborId = ByteArray.ReadInt(cs_ByteArray)
	local cfg_harbor = CFG_harbor[data.harborId]
	data.name = cfg_harbor.name
	data.ships = {}
	local nShipBaseIndex = ByteArray.ReadInt(cs_ByteArray)
	local nindex = 1
	local nShipId = mCommonlyFunc.GetUid(data.id,data.type,nindex)
	local nShipHp = ByteArray.ReadInt(cs_ByteArray)
	local nShipMaxHp = ByteArray.ReadInt(cs_ByteArray)
	local wShipX = ByteArray.ReadShort(cs_ByteArray)
	local wShipY = ByteArray.ReadShort(cs_ByteArray)
	local wShipDestX = ByteArray.ReadShort(cs_ByteArray)
	local wShipDestY = ByteArray.ReadShort(cs_ByteArray)
	
	if nShipHp == 0 then
		return
	end
	
	ship = {}
	ship.bid = nShipBaseIndex
	ship.index = nindex
	ship.cid = data.id
	ship.id = nShipId
	ship.hp = nShipHp
	ship.maxHp = nShipMaxHp
	ship.x = wShipX
	ship.y = wShipY
	ship.dead = nShipHp==0
	data.ships[nindex] = ship
		
	data.x = ship.x
	data.y = ship.y
	data.team = ByteArray.ReadByte(cs_ByteArray)
	
	ship.angles = 0
	
	return data
end

function InitNpcShipTeam(cfg_npcShipTeam)
	-- print("InitNpcShipTeam")
	
	local cfg_Enemy = CFG_Enemy[cfg_npcShipTeam.enemyId1]
	
	local data = {}
	data.type = CharacterType.NpcShipTeam
	data.id = cfg_npcShipTeam.id
	data.name = cfg_Enemy.name
	
	data.level = cfg_Enemy.level
	data.speed = 100
	data.power = cfg_npcShipTeam.power
	data.quality = cfg_Enemy.quality
	
	data.quality = 2
	data.resId = cfg_Enemy.resId
	
	data.ships = {}
	for i=1,3,1 do
		local cfg_Enemy = CFG_Enemy[cfg_npcShipTeam["enemyId"..i]]
		local nShipId = mCommonlyFunc.GetUid(data.id,data.type,i)
		
		ship = {}
		ship.bid = cfg_Enemy.shipid
		ship.index = i
		ship.cid = data.id
		ship.id = nShipId
		ship.hp = 20
		ship.maxHp = 20
		ship.x = 900
		ship.y = 900
		ship.angles = 135
		data.ships[i] = ship
	end
	
	return data
end
