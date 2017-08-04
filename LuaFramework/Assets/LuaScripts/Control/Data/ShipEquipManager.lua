local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_Equip,require,table,PackatHead,Packat_ShipEquip,ByteArray = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_Equip,require,table,PackatHead,Packat_ShipEquip,ByteArray
local CFG_EquipSuit,AppearEvent,EventType,Color,math,CFG_shipEquip = 
CFG_EquipSuit,AppearEvent,EventType,Color,math,CFG_shipEquip
local mNetManager = nil
local mSystemTip = nil
local mHeroTip = nil
local mEventManager = nil
local mSailorManager = nil
local mCommonlyFunc = nil
local mSetManager = nil
local mAddItemTip = nil
local mShipManager = nil

module("LuaScript.Control.Data.ShipEquipManager")

local mEquips = {}
local mEquipsByShip = {}
local mEquipsByType = {{},{},{},{},{}}

function GetEquips()
	return mEquips
end

function GetRestEquips(indexList)
	local list = {}
	for k,v in pairs(mEquips) do
		if v.sid == 0 and not v.protect and  (not indexList or not indexList[v.index]) then
			table.insert(list, v)
		end
	end
	return list
end

function GetEquipsBySid(sid)
	-- mEquipsByShip[sid] = mEquipsByShip[sid] or {}
	return mEquipsByShip[sid]
end

function GetEquipsByType(type)
	return mEquipsByType[type]
end

function GetEquipByIndex(index)
	for k,v in pairs(mEquips) do
		if v.index == index then
			return v
		end
	end
end

function GetEquipByQuality(quality, duty)
	if duty ~= nil then
		local list = {}
		for k,v in pairs(mEquips) do
			local cfg_Equip = CFG_shipEquip[v.id]
			if not v.protect and duty and v.sid ~= 0 and cfg_Equip.quality == quality then
				table.insert(list, v)
			elseif not v.protect and not duty and v.sid == 0 and cfg_Equip.quality == quality then
				table.insert(list, v)
			end
		end
		return list
	else
		local list = {}
		for k,v in pairs(mEquips) do
			local cfg_Equip = CFG_Equip[v.id]
			if v.sid ~= 0 and cfg_Equip.quality == quality then
				table.insert(list, v)
			end
		end
		return list
	end
end

local mPower = nil
function GetTotalPower()
	if mPower then
		return mPower
	end
	mPower = 0
	for k, equip in pairs(mEquips) do
		if equip.sid ~= 0 then
			mPower = mPower + mCommonlyFunc.GetShipEquipPower(equip)
		end
	end
	return mPower
end

function GetpowerBySid(sid)
	local power = 0
	for k, equip in pairs(mEquips) do
		if equip.sid == sid then
			power = power + mCommonlyFunc.GetShipEquipPower(equip)
		end
	end
	return power
end

function Init()
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mHeroTip = require "LuaScript.View.Tip.HeroTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	mShipManager = require "LuaScript.Control.Data.ShipManager"

	mNetManager.AddListen(PackatHead.SHIPEQUIP, Packat_ShipEquip.SEND_ALL_SHIP_EQUIP, SEND_ALL_SHIP_EQUIP)
	mNetManager.AddListen(PackatHead.SHIPEQUIP, Packat_ShipEquip.SEND_ADD_SHIP_EQUIP, SEND_ADD_SHIP_EQUIP)
	mNetManager.AddListen(PackatHead.SHIPEQUIP, Packat_ShipEquip.SEND_DEL_SHIP_EQUIP, SEND_DEL_SHIP_EQUIP)
	mNetManager.AddListen(PackatHead.SHIPEQUIP, Packat_ShipEquip.SEND_SHIP_EQUIP_SHIP_INDEX_CHG, SEND_SHIP_EQUIP_SHIP_INDEX_CHG)
	mNetManager.AddListen(PackatHead.SHIPEQUIP, Packat_ShipEquip.SEND_SHIP_EQUIP_STAR_INFO, SEND_SHIP_EQUIP_STAR_INFO)
	mNetManager.AddListen(PackatHead.SHIPEQUIP, Packat_ShipEquip.SEND_SHIP_EQUIP_PROTECT, SEND_SHIP_EQUIP_PROTECT)
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
end

function ConnectFailure()
	mPower = nil
end

function EquipMove(sourceId, destId)
	if not sourceId or not destId then
		return
	end	
	-- print(sourceId, destId)
	mEquipsByShip[destId] = mEquipsByShip[sourceId]
	mEquipsByShip[sourceId] = nil
	
	if mEquipsByShip[destId] then
		for k,equipe in pairs(mEquipsByShip[destId]) do
			equipe.sid = destId
		end
	end
end

function UnWearByShip(sid)
	-- print(sid, mEquipsByShip[sid])
	if mEquipsByShip[sid] then
		for k,equip in pairs(mEquipsByShip[sid]) do
			equip.sid = 0
		end
	end
	mEquipsByShip[sid] = nil
end

-- function EquipMove(sourceId, destId)
	-- if not sourceId or not destId then
		-- return
	-- end	
	-- mEquipsByShip[destId] = mEquipsByShip[sourceId]
	-- mEquipsByShip[sourceId] = nil
	
	-- if mEquipsByShip[destId] then
		-- for k,equipe in pairs(mEquipsByShip[destId]) do
			-- equipe.sid = destId
		-- end
	-- end
-- end

function SEND_ALL_SHIP_EQUIP(cs_ByteArray)
	-- print("SEND_ALL_SHIP_EQUIP")
	mEquips = {}
	mEquipsByShip = {}
	mEquipsByType = {{},{},{},{},{}}
	
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local equip = {}
		equip.index = ByteArray.ReadInt(cs_ByteArray)
		equip.id = ByteArray.ReadInt(cs_ByteArray)
		equip.sid = ByteArray.ReadInt(cs_ByteArray)
		equip.star = ByteArray.ReadByte(cs_ByteArray)
		equip.exp = ByteArray.ReadInt(cs_ByteArray)
		equip.protect = ByteArray.ReadBool(cs_ByteArray)
		
		local cfg_shipEquip = CFG_shipEquip[equip.id]
		local type = cfg_shipEquip.type
		mEquipsByShip[equip.sid] = mEquipsByShip[equip.sid] or {}
		mEquipsByShip[equip.sid][type] = equip
		
		-- print(equip.id, type)
		table.insert(mEquipsByType[type], equip)
		table.insert(mEquips, equip)
	end
	
	table.sort(mEquips, SortFunc)
	
	-- mShipManager.UpdateAllProperty()
end


function SortFunc(a, b)
	local cfg_a = CFG_shipEquip[a.id]
	local cfg_b = CFG_shipEquip[b.id]
	if cfg_a.quality > cfg_b.quality then
		return true
	elseif cfg_a.quality < cfg_b.quality then
		return false
	end
	if cfg_a.type < cfg_b.type then
		return true
	elseif cfg_a.type > cfg_b.type then
		return false
	end
	-- if a.power > b.power then
		-- return true
	-- elseif a.power < b.power then
		-- return false
	-- end
	if a.id > b.id then
		return true
	elseif a.id < b.id then
		return false
	end
	return false
end

function SEND_ADD_SHIP_EQUIP(cs_ByteArray)
	-- print("SEND_ADD_SHIP_EQUIP")
	local equip = {}
	equip.index = ByteArray.ReadInt(cs_ByteArray)
	equip.id = ByteArray.ReadInt(cs_ByteArray)
	equip.sid = 0
	equip.star = 0
	equip.exp = 0
	equip.protect = false
	-- equip.power = mCommonlyFunc.GetEquipPower(equip)
	-- print(equip.index)
	local cfg_shipEquip = CFG_shipEquip[equip.id]
	local type = cfg_shipEquip.type
	-- mEquipsByShip[equip.sid] = mEquips[equip.sid] or {}
	-- mEquipsByShip[equip.sid][type] = equip
	
	table.insert(mEquipsByType[type], equip)
	table.insert(mEquips, equip)
	-- table.sort(mEquipsByType[type], SortFunc)
	table.sort(mEquips, SortFunc)
	mAddItemTip.ShowTip(2, equip.id)
	
	-- if mDestroyQuality[cfg_Equip.quality] then
		-- RequestDestroyEquip(equip.index)
	-- end
end

function SEND_DEL_SHIP_EQUIP(cs_ByteArray)
	-- print("SEND_DEL_SHIP_EQUIP")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local equip = nil
	for k,v in pairs(mEquips) do
		if v.index == index then
			equip = v
			table.remove(mEquips, k)
			break
		end
	end
	
	local cfg_equip = CFG_shipEquip[equip.id]
	local type = cfg_equip.type
	if equip.sid ~= 0 then
		mEquipsByShip[equip.sid][type] = nil
	end
	
	for k,v in pairs(mEquipsByType[type]) do
		if v.index == index then
			table.remove(mEquipsByType[type], k)
			break
		end
	end
	-- AppearEvent(nil, EventType.RefreshEquip)
end

function SEND_SHIP_EQUIP_SHIP_INDEX_CHG(cs_ByteArray)
	-- print("SEND_SHIP_EQUIP_SHIP_INDEX_CHG")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local sid = ByteArray.ReadInt(cs_ByteArray)
	local equip = nil
	
	for k,v in pairs(mEquips) do
		if v.index == index then
			equip = v
			break
		end
	end
	
	local cfg_equip = CFG_shipEquip[equip.id]
	if mEquipsByShip[equip.sid] then
		mEquipsByShip[equip.sid][cfg_equip.type] = nil
	end
	
	local ship = mShipManager.GetShip(equip.sid)
	if ship then
		mShipManager.UpdateProperty(ship)
	end
	
	if mEquipsByShip[sid] then
		local oldEquip = mEquipsByShip[sid][cfg_equip.type]
		if oldEquip then
			oldEquip.sid = 0
		end
	end
	equip.sid = sid
	mEquipsByShip[sid] = mEquipsByShip[sid] or {}
	mEquipsByShip[sid][cfg_equip.type] = equip
	
	local ship = mShipManager.GetShip(sid)
	if ship then
		mShipManager.UpdateProperty(ship)
	end
	
	mPower = nil
	AppearEvent(nil, EventType.UpdateHeroPower)
end

function SEND_SHIP_EQUIP_STAR_INFO(cs_ByteArray)
	-- print("SEND_SHIP_EQUIP_STAR_INFO")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local star = ByteArray.ReadByte(cs_ByteArray)
	local exp = ByteArray.ReadInt(cs_ByteArray)
	for k,v in pairs(mEquips) do
		if v.index == index then
			v.star = star
			v.exp = exp
			
			local ship = mShipManager.GetShip(v.sid)
			if ship then
				mShipManager.UpdateProperty(ship)
			end
			break
		end
	end
	
	
	
	AppearEvent(nil, EventType.RefreshShipEquipUp)
	
	mPower = nil
	AppearEvent(nil, EventType.UpdateHeroPower)
end

function SEND_SHIP_EQUIP_PROTECT(cs_ByteArray)
	-- print("SEND_SHIP_EQUIP_PROTECT")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local protect = ByteArray.ReadBool(cs_ByteArray)
	
	for k,v in pairs(mEquips) do
		if v.index == index then
			v.protect = protect
			break
		end
	end
end

function RequestWearEquip(index, sid)
	-- print("RequestWearEquip"..index.." "..sid)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIPEQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_ShipEquip.CLIENT_REQUEST_PUT_ON_SHIP_EQUIP)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteInt(cs_ByteArray,sid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestAutoWearEquip(sid)
	-- print("RequestAutoWearEquip")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIPEQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_ShipEquip.CLIENT_REQUEST_AUTO_EQUIP_SHIP)
	ByteArray.WriteInt(cs_ByteArray,sid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestUp(id, list)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIPEQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_ShipEquip.CLIENT_REQUEST_STAR_UP_SHIP_EQUIP)
	ByteArray.WriteInt(cs_ByteArray,id)
	
	for i=1,5 do
		local equip = list[i]
		if equip then
			ByteArray.WriteInt(cs_ByteArray,equip.index)
		else
			ByteArray.WriteInt(cs_ByteArray,0)
		end
	end
	
	
	mNetManager.SendData(cs_ByteArray)
end

function RequestProtect(index, protect)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIPEQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_ShipEquip.CLIENT_REQUEST_PROTECT_SHIP_EQUIP)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteByte(cs_ByteArray,protect)	
	mNetManager.SendData(cs_ByteArray)
end

function GetEquipProperty(ship)
	local equips = GetEquipsBySid(ship.index)
	if not equips then
		return
	end
	local property = {}
	for k,equip in pairs(equips) do
		local cfg_equip = CFG_shipEquip[equip.id]
		-- local value,type = cfg_equip.propertyValue1, cfg_equip.propertyId1
		-- property[type] = property[type] or 0
		-- property[type] = property[type] + value
		
		local value,type = mCommonlyFunc.GetShipEquipProperty(equip)
		property[type] = property[type] or 0
		property[type] = property[type] + value
		
		
		local value,type = cfg_equip.propertyValue2, cfg_equip.propertyId2
		property[type] = property[type] or 0
		property[type] = property[type] + value
	end
	return property
end