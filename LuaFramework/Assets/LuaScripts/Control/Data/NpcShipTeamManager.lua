local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_Equip,require,table,PackatHead,Packat_Equip,ByteArray = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_Equip,require,table,PackatHead,Packat_Equip,ByteArray
local CFG_EquipSuit,AppearEvent,EventType,Color,math,CFG_npcShipTeam,CFG_harbor,CFG_ship,os,Packat_Enemymerchant = 
CFG_EquipSuit,AppearEvent,EventType,Color,math,CFG_npcShipTeam,CFG_harbor,CFG_ship,os,Packat_Enemymerchant
local mNetManager = nil
local mEventManager = nil
local mHeroManager = nil
local mCharManager = nil
local mMoveManager = nil
local mTimer = require "LuaScript.Common.Timer"
local mCharacter = require "LuaScript.Mode.Object.Character"

module("LuaScript.Control.Data.NpcShipTeamManager")

mActiveList = nil
mUnActiveList = nil
mDeadList = {}
mTimeoutList = {}

local mHarborList = {[0] = 211,[1] = 212,[2] = 213}
local mLastBornTime = -100000

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mMoveManager = require "LuaScript.Control.Scene.MoveManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.IntoNormalScene, IntoNormalScene)
	
	mNetManager.AddListen(PackatHead.ENEMYMERCHANT, Packat_Enemymerchant.SEND_ENEMY_MERCHANT_CAN_REFRESH, SEND_ENEMY_MERCHANT_CAN_REFRESH)
	mNetManager.AddListen(PackatHead.ENEMYMERCHANT, Packat_Enemymerchant.SEND_ALL_DEFEATED_ENEMY_MERCHANT, SEND_ALL_DEFEATED_ENEMY_MERCHANT)
	mNetManager.AddListen(PackatHead.ENEMYMERCHANT, Packat_Enemymerchant.SEND_ENEMY_MERCHANT_DEFEATED, SEND_ENEMY_MERCHANT_DEFEATED)
end

function SEND_ALL_DEFEATED_ENEMY_MERCHANT(cs_ByteArray)
	-- print("SEND_ALL_DEFEATED_ENEMY_MERCHANT")
	mDeadList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local id = ByteArray.ReadInt(cs_ByteArray)
		mDeadList[id] = true
	end
end

function SEND_ENEMY_MERCHANT_CAN_REFRESH(cs_ByteArray)
	-- print("SEND_ENEMY_MERCHANT_CAN_REFRESH")
	local id = ByteArray.ReadInt(cs_ByteArray)
	mDeadList[id] = nil
	
	if mUnActiveList then
		local hero = mHeroManager.GetHero()
		for k,cfg_npcShipTeam in pairs(CFG_npcShipTeam) do
			if cfg_npcShipTeam.shipTeam == id and cfg_npcShipTeam.minLevel <= hero.level 
				and cfg_npcShipTeam.maxLevel >= hero.level then
				local char = mCharacter.InitNpcShipTeam(cfg_npcShipTeam)
				table.insert(mUnActiveList, char)
			end
		end
	end
end

function SEND_ENEMY_MERCHANT_DEFEATED(cs_ByteArray)
	-- print("SEND_ENEMY_MERCHANT_DEFEATED")
	local id = ByteArray.ReadInt(cs_ByteArray)
	mDeadList[id] = true
end

function IntoNormalScene()
	local hero = mHeroManager.GetHero()
	if hero.map ~= 2 then
		return
	end
	mActiveList = {}
	mUnActiveList = {}
	
	for k,timeout in pairs(mTimeoutList) do
		mTimer.RemoveTimer(timeout)
	end
	mTimeoutList = {}
	
	for k,cfg_npcShipTeam in pairs(CFG_npcShipTeam) do
		if not mDeadList[cfg_npcShipTeam.shipTeam] and cfg_npcShipTeam.minLevel <= hero.level 
			and cfg_npcShipTeam.maxLevel >= hero.level then
			local char = mCharacter.InitNpcShipTeam(cfg_npcShipTeam)
			table.insert(mUnActiveList, char)
			-- table.insert(mUnActiveList, char)
			-- table.insert(mUnActiveList, char)
			-- table.insert(mUnActiveList, char)
		end
	end
	
	-- local count = math.random(3)
	-- for i=1,count,1 do
		-- RandomRorn(true)
		-- RandomRorn(true)
		-- RandomRorn(true)
		-- RandomRorn(true)
		-- RandomRorn(true)
		-- RandomRorn(true)
		-- RandomRorn(true)
		-- RandomRorn(true)
		RandomRorn(true)
	-- end
end

function RandomRorn(randomPosition)
	local count = #mUnActiveList
	-- local count = 0
	if count > 0 then
		local index = math.random(count)
		local shipTeam = mUnActiveList[index]
		table.insert(mActiveList, shipTeam)
		table.remove(mUnActiveList, index)
		
		if randomPosition then
			local index = math.random(3) - 1
			local fromHarborId = mHarborList[index]
			local fromHarbor = CFG_harbor[fromHarborId]
			
			
			index = (index + math.random(2)) % 3
			local toHarborId = mHarborList[index]
			local toHarbor = CFG_harbor[toHarborId]
			
			local moveX = toHarbor.x - fromHarbor.x
			local moveY = toHarbor.y - fromHarbor.y
			local moveL = math.sqrt(moveX^2+ moveY^2)
			
			local overLength = 0.2+math.random()*0.6
			local ship1 = shipTeam.ships[1]
			ship1.x = moveX*overLength + fromHarbor.x
			ship1.y = moveY*overLength + fromHarbor.y
			mMoveManager.StarMove(ship1, {toHarbor.x, toHarbor.y})
			
			local ship2 = shipTeam.ships[2]
			local cfg_ship = CFG_ship[ship1.bid]
			local cfg_lastship = CFG_ship[ship2.bid]
			local spacing = (cfg_ship.scale*100 + cfg_lastship.scale*100) * 0.5
			
			overLength = overLength - spacing/moveL
			ship2.x = moveX*overLength + fromHarbor.x
			ship2.y = moveY*overLength + fromHarbor.y
			mMoveManager.StarMove(ship2, {toHarbor.x, toHarbor.y})
			
			local ship3 = shipTeam.ships[3]
			local cfg_ship = CFG_ship[ship2.bid]
			local cfg_lastship = CFG_ship[ship3.bid]
			local spacing = (cfg_ship.scale*100 + cfg_lastship.scale*100) * 0.5
			overLength = overLength - spacing/moveL
			
			ship3.x = moveX*overLength + fromHarbor.x
			ship3.y = moveY*overLength + fromHarbor.y
			mMoveManager.StarMove(ship3, {toHarbor.x, toHarbor.y})
			
			shipTeam.x = ship1.x
			shipTeam.y = ship1.y
			shipTeam.harborId = index
			-- print(shipTeam.id, index)
		else
			-- print(shipTeam.id, shipTeam.harborId)
			local index = shipTeam.harborId
			if not index then
				index = math.random(3) - 1
			end
			
			local fromHarborId = mHarborList[index]
			local fromHarbor = CFG_harbor[fromHarborId]

			index = (index + math.random(2)) % 3
			local toHarborId = mHarborList[index]
			local toHarbor = CFG_harbor[toHarborId]
			
			local ship1 = shipTeam.ships[1]
			ship1.x = fromHarbor.x
			ship1.y = fromHarbor.y
			mMoveManager.StarMove(ship1, {toHarbor.x, toHarbor.y})
			
			local ship2 = shipTeam.ships[2]
			ship2.x = fromHarbor.x
			ship2.y = fromHarbor.y
			ship2.move = nil
			
			local ship3 = shipTeam.ships[3]
			ship3.x = fromHarbor.x
			ship3.y = fromHarbor.y
			ship3.move = nil
			
			shipTeam.x = ship1.x
			shipTeam.y = ship1.y
			shipTeam.harborId = index
		end
		-- print(ship1.x, ship1.y, ship2.x, ship2.y, ship3.x, ship3.y)
		mCharManager.InitChar(shipTeam)
	end
end

function Update()
	if not mActiveList then
		return
	end
	local hero = mHeroManager.GetHero()
	if hero.map ~= 2 then
		return
	end
	if os.oldClock - mLastBornTime > 6 then
		local count = #mActiveList
		-- if math.random(20^count) == 1 then
			RandomRorn()
			mLastBornTime = os.oldClock
		-- end
	end
	
end

function OverMove(char)
	
	function destroyChar()
		mCharManager.DestroyChar(char)
		for k,v in pairs(mActiveList) do
			if v == char then
				table.remove(mActiveList, k)
				break
			end
		end
		
		
		function recover()
			table.insert(mUnActiveList, char)
		end
		
		table.insert(mTimeoutList, mTimer.SetTimeout(recover, math.random(10)+5))
	end
	
	table.insert(mTimeoutList, mTimer.SetTimeout(destroyChar, 0.1))
end
