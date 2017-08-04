local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Ship,Language = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Ship,Language
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_ship,CFG_harbor,LogbookType,Color = CFG_ship,CFG_harbor,LogbookType,Color
local mAlert = nil
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mSystemTip = nil
local mLogbookManager = nil
local mCommonlyFunc = nil
local mPanelManager = nil
local mShipyardPanel = nil
local mGuideManager = nil
local mShipEquipManager = nil
local mFleetPanel = nil
local mLabManager = nil
local mGoodsManager = nil
module("LuaScript.Control.Data.ShipManager")

local mShips = nil
local mShipsByIndex = nil
local mBuildShips = {}

function GetShips()
	return mShips
end

function GetShip(index)
	return mShipsByIndex[index]
end

function GetDutyShip(index)
	local ship = mShips[index]
	if ship and ship.duty == index then
		return ship
	end
end

function GetRestShip()
	local restShipList = {}
	for k,ship in pairs(mShips) do
		if ship.duty == 0 then
			table.insert(restShipList, ship)
		end
	end
	return restShipList
end

function GetRestShipById(id)
	local list = {}
	for k,ship in pairs(mShips) do
		if ship.duty == 0 and ship.bid == id then
			table.insert(list, ship)
		end
	end
	return list
end

function GetBuildShips(harborId)
	if mBuildShips[harborId] then
		return mBuildShips[harborId]
	else
		mBuildShips[harborId] = {}
		RequestBuildList(harborId)
		return mBuildShips[harborId]
	end
end

function GetUseCount()
	if mShips[3] and mShips[3].duty ~= 0 then
		return 3
	elseif mShips[2] and mShips[2].duty ~= 0 then
		return 2
	elseif mShips[1] and mShips[1].duty ~= 0 then
		return 1
	end
	return 0
end

local mPower = nil
function GetTotalPower()
	if not mShips then
		return 0
	end
	if mPower then
		return mPower
	end
	mPower = 0
	for k, ship in pairs(mShips) do
		if ship.duty ~= 0 then
			mPower = mPower + mCommonlyFunc.GetShipPower(ship.bid)
		end
	end
	return mPower
end

function CheckDutyShip()
	if not mShips[1] or mShips[1].duty == 0 then
		local info = "未设置上阵船只，请在"
		info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. "菜单·舰队"
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "处设置"
		mAlert.Show(info)
		return false
	else
		return true
	end
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mLogbookManager = require "LuaScript.Control.Data.LogbookManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mGuideManager = require "LuaScript.Control.Data.GuideManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"

	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_ALL_SHIP, SEND_ALL_SHIP)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_ADD_SHIP, SEND_ADD_SHIP)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_DEL_SHIP, SEND_DEL_SHIP)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_SHIP_BUILD_INFO, SEND_SHIP_BUILD_INFO)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_SHIP_BUILD_TIME, SEND_SHIP_BUILD_TIME)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_ADD_SHIP_BUILD, SEND_ADD_SHIP_BUILD)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_DEL_SHIP_BUILD, SEND_DEL_SHIP_BUILD)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_SHIP_BUILD_FINISH, SEND_SHIP_BUILD_FINISH)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_SHIP_SLOT, SEND_SHIP_SLOT)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_SHIP_LIFE, SEND_SHIP_LIFE)
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_DEL_ALL_HARBOR_SHIP_BUILD, SEND_DEL_ALL_HARBOR_SHIP_BUILD)
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
end

function ConnectFailure()
	mPower = nil
end

function SEND_ALL_SHIP(cs_ByteArray)
	print("SEND_ALL_SHIP")
	mShips = {}
	mShipsByIndex = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local ship = {}
		ship.index = ByteArray.ReadInt(cs_ByteArray)
		ship.bid = ByteArray.ReadInt(cs_ByteArray)
		ship.duty = ByteArray.ReadByte(cs_ByteArray)
		ship.life = ByteArray.ReadByte(cs_ByteArray)
		mShipsByIndex[ship.index] = ship
		table.insert(mShips, ship)
		
		UpdateProperty(ship)
	end
	
	table.sort(mShips, sortFunc)
end

function UpdateAllProperty(showPowerChange)
	if not mShips then
		return
	end
	for k,ship in pairs(mShips) do
		UpdateProperty(ship, showPowerChange)
	end
end

function UpdateProperty(ship, showPowerChange)
	local cfg_ship = CFG_ship[ship.bid]
	ship.attack = cfg_ship.attack
	ship.defense = cfg_ship.defense
	ship.hp = cfg_ship.hp
	ship.range = cfg_ship.range
	ship.store = cfg_ship.store
	ship.speed = cfg_ship.speed
	
	if ship.duty ~= 0 then
		local equipProperty = mShipEquipManager.GetEquipProperty(ship)
		if equipProperty then
			ship.attack = ship.attack + (equipProperty[57] or 0)
			ship.defense = ship.defense + (equipProperty[58] or 0)
			ship.hp = ship.hp + (equipProperty[60] or 0)
			ship.speed = ship.speed + (equipProperty[59] or 0)
			ship.store = ship.store + (equipProperty[38] or 0)
		end
	end
	
	local property = mLabManager.GetLabProperty()
	ship.attack = ship.attack * ((property[22] or 0) * 0.01 + 1)
	ship.defense = ship.defense * ((property[23] or 0) * 0.01 + 1)
	ship.range = ship.range * ((property[24] or 0) * 0.01 + 1)
	ship.speed = ship.speed  + (property[59] or 0)
	
	ship.hp = math.floor(ship.hp)
	ship.attack = math.floor(ship.attack)
	ship.defense = math.floor(ship.defense)
	ship.range = math.floor(ship.range)
	ship.speed = math.floor(ship.speed)
	
	mGoodsManager.UpdateStore(ship.duty, ship.store)
	
	ship.power = nil
	ship.power = mCommonlyFunc.GetShipPower(ship.bid, ship)
end 

function sortFunc(a, b)
	if a.duty == b.duty then
		if a.bid > b.bid then
			return true
		end
	elseif a.duty == 0 then
		return false
	elseif b.duty == 0 then
		return true
	elseif a.duty < b.duty then
		return true
	end
	return false
end

function SEND_ADD_SHIP(cs_ByteArray)
	-- print("SEND_ADD_SHIP")
	local ship = {}
	ship.index = ByteArray.ReadInt(cs_ByteArray)
	ship.bid = ByteArray.ReadInt(cs_ByteArray)
	ship.duty = ByteArray.ReadByte(cs_ByteArray)
	ship.life = ByteArray.ReadByte(cs_ByteArray)
	mShipsByIndex[ship.index] = ship
	table.insert(mShips, ship)
	
	UpdateProperty(ship)
	
	table.sort(mShips, sortFunc)
	
	AppearEvent(nil, EventType.RefreshRestShip)
end

function SEND_DEL_SHIP(cs_ByteArray)
	-- print("SEND_DEL_SHIP")
	local index = ByteArray.ReadInt(cs_ByteArray)
	for k,ship in pairs(mShips) do
		if ship.index == index then
			table.remove(mShips, k)
			break
		end
	end
	mShipsByIndex[index] = nil
	mShipEquipManager.UnWearByShip(index)
	
	AppearEvent(nil, EventType.RefreshUseShip)
	AppearEvent(nil, EventType.RefreshRestShip)
end

function SEND_SHIP_BUILD_INFO(cs_ByteArray)
	-- print("SEND_SHIP_BUILD_INFO")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local finishTime = ByteArray.ReadInt(cs_ByteArray)
	-- print(finishTime)
	local ships = {}
	for i=1,10,1 do
		local shipBaseId = ByteArray.ReadInt(cs_ByteArray)
		if shipBaseId ~= 0 then
			table.insert(ships, shipBaseId)
		end
	end
	mBuildShips[harborId] = {}
	mBuildShips[harborId].finishTime = finishTime
	mBuildShips[harborId].startTime = os.oldClock
	mBuildShips[harborId].ships = ships
end

function SEND_SHIP_BUILD_TIME(cs_ByteArray)
	-- print("SEND_SHIP_BUILD_TIME")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local finishTime = ByteArray.ReadInt(cs_ByteArray)
	-- print(finishTime)
	mBuildShips[harborId] = mBuildShips[harborId] or {}
	mBuildShips[harborId].finishTime = finishTime
	mBuildShips[harborId].startTime = os.oldClock
end

function SEND_ADD_SHIP_BUILD(cs_ByteArray)
	-- print("SEND_ADD_SHIP_BUILD")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local shipBaseId = ByteArray.ReadInt(cs_ByteArray)
	mBuildShips[harborId] = mBuildShips[harborId] or {}
	mBuildShips[harborId].ships = mBuildShips[harborId].ships or {}
	table.insert(mBuildShips[harborId].ships, shipBaseId)
end

function SEND_DEL_SHIP_BUILD(cs_ByteArray)
	-- print("SEND_DEL_SHIP_BUILD")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local index = ByteArray.ReadInt(cs_ByteArray)
	table.remove(mBuildShips[harborId].ships, index+1)
end

function MoveToShipTeam(index)
	for k,ship in pairs(mShips) do
		if ship.index == index then
			table.remove(mShips, k)
			break
		end
	end
	mShipsByIndex[index] = nil
	AppearEvent(nil, EventType.RefreshUseShip)
end

function SEND_SHIP_BUILD_FINISH(cs_ByteArray)
	-- print("RequestBuildList")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	local shipBaseId = ByteArray.ReadInt(cs_ByteArray)
	if mBuildShips[harborId] and mBuildShips[harborId].ships then
		table.remove(mBuildShips[harborId].ships, 1)
	end
	local cfg_harbor = CFG_harbor[harborId]
	local cfg_ship = CFG_ship[shipBaseId]
	local infoStr = cfg_harbor.name..cfg_ship.name..Language[148]
	mSystemTip.ShowTip(infoStr, Color.LimeStr)
	
	mLogbookManager.AddLog(LogbookType.Ship, os.oldTime, harborId, shipBaseId)
	
	-- print(shipBaseId .. "finish")
end

function CLIENT_REQUEST_ADD_BUILD(shipBaseId)
	-- print("CLIENT_REQUEST_ADD_BUILD" .. shipBaseId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Ship.CLIENT_REQUEST_ADD_BUILD)
	ByteArray.WriteInt(cs_ByteArray,shipBaseId)
	mNetManager.SendData(cs_ByteArray)
end

function CLIENT_REQUEST_DEL_BUILD(index)
	-- print("CLIENT_REQUEST_DEL_BUILD" .. index)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Ship.CLIENT_REQUEST_DEL_BUILD)
	ByteArray.WriteInt(cs_ByteArray,index-1)
	mNetManager.SendData(cs_ByteArray)
end

function CLIENT_REQUEST_SPEED_BUILD()
	-- print("CLIENT_REQUEST_SPEED_BUILD")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Ship.CLIENT_REQUEST_FAST_FINISH)
	-- ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function RequestBuildList(harborId)
	-- print("RequestBuildList"..harborId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Ship.CLIENT_REQUEST_BUILD_INFO)
	ByteArray.WriteInt(cs_ByteArray,harborId)
	mNetManager.SendData(cs_ByteArray)
end

function RequestDelShip(index)
	-- print("RequestBuildList"..index)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Ship.CLIENT_REQUEST_DEL_SHIP)
	ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_SHIP_SLOT(cs_ByteArray)
	-- print("SEND_SHIP_SLOT")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local duty = ByteArray.ReadByte(cs_ByteArray)
	-- print(index.."_"..duty)
	if not mShips then
		return
	end
	local oldShip = GetDutyShip(duty)
	if oldShip then
		oldShip.duty = 0
		-- mGoodsManager.ClearGoods(oldShip)
	end
	
	for k,ship in pairs(mShips) do
		if ship.index == index then
			if ship.duty == 0 and oldShip then
				mShipEquipManager.EquipMove(oldShip.index, index)
				mGoodsManager.ClearGoods(duty)
			elseif ship.duty ~= 0 and oldShip then
				mGoodsManager.RomveGoods(duty)
			elseif ship.duty ~= 0 and duty ~= 0 then
				mGoodsManager.MoveGoods(ship.duty, duty)
			elseif ship.duty ~= 0 and duty == 0 then
				mGoodsManager.ClearGoods(ship.duty)
			end
			
			
			
			ship.duty = duty
			UpdateProperty(ship)
			
			if oldShip then
				UpdateProperty(oldShip)
			end
			-- table.remove(mShips, k)
			break
		end
	end
	table.sort(mShips, sortFunc)
	
	mPower = nil
	
	AppearEvent(nil, EventType.RefreshUseShip)
	AppearEvent(nil, EventType.UpdateHeroPower)
	
	if duty ~= 0 then
		AppearEvent(nil, EventType.OnRefreshGuide)
	end
end

function SEND_SHIP_LIFE(cs_ByteArray)
	-- print("SEND_SHIP_LIFE")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local life = ByteArray.ReadByte(cs_ByteArray)
	
	for k,ship in pairs(mShips) do
		if ship.index == index then
			ship.life = life
			if life > 0 then
				mSystemTip.ShowTip("船只被击沉,耐久降低")
			else
				mSystemTip.ShowTip("船只被击毁")
			end
			break
		end
	end
end

function SEND_DEL_ALL_HARBOR_SHIP_BUILD(cs_ByteArray)
	-- print("SEND_DEL_ALL_HARBOR_SHIP_BUILD")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	mBuildShips[harborId] = nil
end

function RequestSetDuty(index, duty)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SHIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Ship.CLIENT_REQUEST_SET_SHIP_BATTLE)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteByte(cs_ByteArray,duty)
	mNetManager.SendData(cs_ByteArray)
end