local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Fleet,Language = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Fleet,Language
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local Packat_Merchant,ConstValue = Packat_Merchant,ConstValue
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mSystemTip = nil
local mSailorManager = nil
local mEquipManager = nil
module("LuaScript.Control.Data.ShipTeamManager")

local mShipTeam = nil
local mShipTeamById = nil
local mLastUpdateTime = -10000
local mMoneyAward = 0

function GetMoneyAward()
	return mMoneyAward
end

function GetShipTeam()
	return mShipTeam
end

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"

	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SEND_ALL_MERCHANT, SEND_ALL_MERCHANT)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SEND_ADD_MERCHANT, SEND_ADD_MERCHANT)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SEND_DEL_MERCHANT, SEND_DEL_MERCHANT)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SEND_CHG_MERCHANT_SAILOR, SEND_CHG_MERCHANT_SAILOR)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SEND_CHG_MERCHANT_SHIP, SEND_CHG_MERCHANT_SHIP)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SEND_MERCHANT_DETAIL, SEND_MERCHANT_DETAIL)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SERVER_SEND_MERCHANT_MONEY, SERVER_SEND_MERCHANT_MONEY)
end

function SEND_ALL_MERCHANT(cs_ByteArray)
	-- print("SEND_ALL_MERCHANT")
	mMoneyAward = 0
	mShipTeam = {}
	mShipTeamById = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local id = ByteArray.ReadInt(cs_ByteArray)
		local shipId = ByteArray.ReadInt(cs_ByteArray)
		local sailorId = ByteArray.ReadInt(cs_ByteArray)
		local income = ByteArray.ReadInt(cs_ByteArray)
		local shipTeam = {}
		shipTeam.id = id
		shipTeam.sailor = mSailorManager.GetSailorById(sailorId)
		shipTeam.shipId = shipId
		shipTeam.income = income
		table.insert(mShipTeam, shipTeam)
		mShipTeamById[id] = shipTeam
	end
end

function SEND_ADD_MERCHANT(cs_ByteArray)
	-- print("SEND_ADD_MERCHANT")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local shipId = ByteArray.ReadInt(cs_ByteArray)
	local sailorId = ByteArray.ReadInt(cs_ByteArray)
	local income = ByteArray.ReadInt(cs_ByteArray)
	
	mSailorManager.MoveToShipTeam(sailorId)
	local shipTeam = {}
	shipTeam.id = id
	shipTeam.sailor = mSailorManager.GetSailorById(sailorId)
	shipTeam.shipId = shipId
	shipTeam.income = income
	
	table.insert(mShipTeam, shipTeam)
	mShipTeamById[id] = shipTeam
end

function SEND_DEL_MERCHANT(cs_ByteArray)
	-- print("SEND_DEL_MERCHANT")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local shipTeam = mShipTeamById[id]
	
	
	mSailorManager.MoveFromShipTeam(shipTeam.sailor.id)
	
	
	mShipTeamById[id] = nil
	for k,v in pairs(mShipTeam) do
		if v == shipTeam then
			table.remove(mShipTeam, k)
			return
		end
	end
	-- local sailorId = ByteArray.ReadInt(cs_ByteArray)
	-- local shipId = ByteArray.ReadInt(cs_ByteArray)
	-- mSailorManager.MoveToShipTeam(sailorId)
	-- print(sailorId)
	-- local shipTeam = {}
	-- shipTeam.id = id
	-- shipTeam.sailor = mSailorManager.GetSailorById(sailorId)
	-- shipTeam.shipId = shipId
	-- table.insert(mShipTeam, shipTeam)
	
end

function SEND_CHG_MERCHANT_SAILOR(cs_ByteArray)
	-- print("SEND_CHG_MERCHANT_SAILOR")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local sailorId = ByteArray.ReadInt(cs_ByteArray)
	-- print(sailorId)
	local shipTeam = mShipTeamById[id]
	mSailorManager.MoveToShipTeam(sailorId)
	mSailorManager.MoveFromShipTeam(shipTeam.sailor.id)
	shipTeam.sailor = mSailorManager.GetSailorById(sailorId)
end

function SERVER_SEND_MERCHANT_MONEY(cs_ByteArray)
	-- print("SEND_CHG_MERCHANT_SAILOR")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local money = ByteArray.ReadInt(cs_ByteArray)
	-- print(sailorId)
	mMoneyAward = money
	print(mMoneyAward)
end

function SEND_CHG_MERCHANT_SHIP(cs_ByteArray)
	-- print("SEND_CHG_MERCHANT_SHIP")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local shipId = ByteArray.ReadInt(cs_ByteArray)
	local shipTeam = mShipTeamById[id]
	shipTeam.shipId = shipId
end

function SEND_MERCHANT_DETAIL(cs_ByteArray)
	-- print("SEND_MERCHANT_DETAIL")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local income = ByteArray.ReadInt(cs_ByteArray)
	local lastTime = ByteArray.ReadInt(cs_ByteArray)
	local robed = ByteArray.ReadBool(cs_ByteArray)
	local robedName = ByteArray.ReadUTF(cs_ByteArray)
	-- local robedId = ByteArray.ReadShort(cs_ByteArray)
	
	local shipTeam = mShipTeamById[id]
	if shipTeam then
		shipTeam.income = income
		shipTeam.lastTime = lastTime
		shipTeam.updateTime = os.oldClock
		shipTeam.robed = robed
		shipTeam.robedName = robedName
		-- shipTeam.robedId = robedId
	end
end


-- function SEND_DEL_Fleet(cs_ByteArray)
	-- print("SEND_DEL_Fleet")
	-- local index = ByteArray.ReadInt(cs_ByteArray)
	-- for k,fleet in pairs(mFleets) do
		-- if fleet.index == index then
			-- table.remove(mFleets, k)
			-- break
		-- end
	-- end
	-- AppearEvent(nil, EventType.RefreshUseFleet)
-- end

function RequestShipTeamDetail()
	if os.oldClock - mLastUpdateTime  < ConstValue.UpdateShipTeamTime then
		return
	end
	mLastUpdateTime = os.oldClock
	-- print("RequestShipTeamDetail")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.MERCHANT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Merchant.CLIENT_REQUEST_MERCHANT_DETAIL)
	mNetManager.SendData(cs_ByteArray)
end

function RequestBuildShipTeam(shipId,sailorId)
	-- print("RequestBuildShipTeam")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.MERCHANT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Merchant.CLIENT_REQUEST_ADD_MERCHANT)
	ByteArray.WriteInt(cs_ByteArray,shipId)
	ByteArray.WriteInt(cs_ByteArray,sailorId)
	-- print(sailorId)
	mNetManager.SendData(cs_ByteArray)
end

function RequestChangeSailor(shipTeamId,sailorId)
	-- print("RequestChangeSailor",sailorId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.MERCHANT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Merchant.CLIENT_REQUEST_CHG_MERCHANT_SAILOR)
	ByteArray.WriteInt(cs_ByteArray,shipTeamId)
	ByteArray.WriteInt(cs_ByteArray,sailorId)
	mNetManager.SendData(cs_ByteArray)
end

function RequestChangeShip(shipTeamId,shipId)
	-- print("RequestChangeShip")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.MERCHANT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Merchant.CLIENT_REQUEST_CHG_MERCHANT_SHIP)
	ByteArray.WriteInt(cs_ByteArray,shipTeamId)
	ByteArray.WriteInt(cs_ByteArray,shipId)
	mNetManager.SendData(cs_ByteArray)
end

function RequestDelShipTeam(id)
	-- print("RequestDelShipTeam"..id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.MERCHANT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Merchant.CLIENT_REQUEST_DEL_MERCHANT)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

