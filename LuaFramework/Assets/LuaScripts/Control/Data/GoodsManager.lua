local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_ship,CFG_harbor,AudioData,CFG_product = CFG_ship,CFG_harbor,AudioData,CFG_product
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mShipManager = nil
local mTaskManager = nil
local mHeroManager = nil
local mGuideManager = nil
local mAudioManager = nil
module("LuaScript.Control.Data.GoodsManager")

local mGoodsList = {{},{},{}}
local mGoodsPriceList = {}
local mRequestPriceing = false
local mPopularType = nil
local mPopularCount = nil

function GetPopularType()
	return mPopularType
end

function GetPopularCount()
	return mPopularCount
end

function GetGoodsList()
	return mGoodsList
end

function GetGoodsPriceList()
	return mGoodsPriceList
end

function CleanGoodsPriceList()
	mGoodsPriceList = {}
end

function HaveEnoughGoods(id, count)
	-- print(id, count)
	for k,goodsId in pairs(mGoodsList[1]) do
		if goodsId == id then
			count = count - 1
		end
	end
	for k,goodsId in pairs(mGoodsList[2]) do
		if goodsId == id then
			count = count - 1
		end
	end
	for k,goodsId in pairs(mGoodsList[3]) do
		if goodsId == id then
			count = count - 1
		end
	end
	-- print(count)
	if count <= 0 then
		return true
	end
end

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mGuideManager = require "LuaScript.Control.Data.GuideManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"

	mNetManager.AddListen(PackatHead.GOODS, Packat_Goods.SEND_ALL_GOODS, SEND_ALL_GOODS)
	mNetManager.AddListen(PackatHead.GOODS, Packat_Goods.SEND_ADD_GOODS, SEND_ADD_GOODS)
	mNetManager.AddListen(PackatHead.GOODS, Packat_Goods.SEND_DEL_GOODS, SEND_DEL_GOODS)
	mNetManager.AddListen(PackatHead.GOODS, Packat_Goods.SEND_GOODS_PRICE, SEND_GOODS_PRICE)
	mNetManager.AddListen(PackatHead.GOODS, Packat_Goods.SEND_GOODS_POPULAR, SEND_GOODS_POPULAR)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_BONUS_GOODS, SEND_BONUS_GOODS)
	mNetManager.AddListen(PackatHead.GOODS, Packat_Goods.SEND_DEL_All_GOODS, SEND_DEL_All_GOODS)
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
end

function ConnectFailure()
	mRequestPriceing = false
	CleanGoodsPriceList()
end

function SEND_ALL_GOODS(cs_ByteArray)
	-- print("SEND_ALL_GOODS")
	mGoodsList[1][1] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][2] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][3] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][4] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][5] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][6] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][7] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][8] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][9] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][10] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][11] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][12] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][13] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][14] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[1][15] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][1] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][2] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][3] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][4] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][5] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][6] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][7] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][8] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][9] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][10] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][11] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][12] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][13] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][14] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[2][15] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][1] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][2] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][3] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][4] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][5] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][6] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][7] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][8] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][9] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][10] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][11] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][12] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][13] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][14] = ByteArray.ReadInt(cs_ByteArray)
	mGoodsList[3][15] = ByteArray.ReadInt(cs_ByteArray)
end

function SEND_ADD_GOODS(cs_ByteArray)
	-- print("SEND_ADD_GOODS")
	
	-- mAudioManager.PlayAudioOneShot(AudioData.business)
	local goodsID = ByteArray.ReadInt(cs_ByteArray)
	local goodsCount = ByteArray.ReadInt(cs_ByteArray)
	local ships = mShipManager.GetShips()
	for k,ship in pairs(ships) do
		if ship.duty == 0 then
			break
		end
		local goods = mGoodsList[k]
		local cfgShip = CFG_ship[ship.bid]
		for k=1,ship.store,1 do
			if not goods[k] or goods[k] == 0 then
				goods[k] = goodsID
				goodsCount = goodsCount - 1
			end
			if goodsCount <= 0 then
				break
			end
		end
		if goodsCount <= 0 then
			break
		end
	end
end


function HaveGoods(ship)
	if not ship then
		return
	end
	local goods = mGoodsList[ship.duty]
	local value = 0
	for k,v in pairs(goods) do
		value = v + value
	end
	return value ~= 0
end

function HaveGoodsByHero()
	local value = 0
	for _,goods in pairs(mGoodsList) do
		for k,v in pairs(goods) do
			value = v + value
		end
	end
	return value ~= 0
end

function GetMainId()
	local list = {}
	for i=1,3,1 do
		for k,v in pairs(mGoodsList[i]) do
			if v ~= 0 then
				list[v] = list[v] or 0
				list[v] = list[v] + 1
			end
		end
	end
	print(list)
	local maxCount = 0
	local maxGoodsId = 0
	for k,v in pairs(list) do
		if maxCount < v then
			maxCount = v
			maxGoodsId = k
		end
	end
	return maxGoodsId
end


-- function HaveGoods(ship, )
	-- local 
	-- local goods = mGoodsList[ship.duty]
	-- local value = 0
	-- for k,v in pairs(goods) dp
		-- value = v + value
	-- end
	-- return value ~= 0
-- end

function ClearGoods(duty)
	-- print("ClearGoods",duty)
	mGoodsList[duty] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

function MoveGoods(fromDuty, toDuty)
	-- print("MoveGoods",duty)
	mGoodsList[toDuty],mGoodsList[fromDuty] = mGoodsList[fromDuty],mGoodsList[toDuty]
	-- if duty < 2 then
		-- mGoodsList[1] = mGoodsList[2]
	-- end
	-- if duty < 3 then
		-- mGoodsList[2] = mGoodsList[3]
	-- end
	-- mGoodsList[3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

function RomveGoods(duty)
	-- print("RomveGoods",duty)
	if duty < 2 then
		mGoodsList[1] = mGoodsList[2]
	end
	if duty < 3 then
		mGoodsList[2] = mGoodsList[3]
	end
	mGoodsList[3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

function UpdateStore(duty, store)
	if duty == nil or duty == 0 then
		return
	end
	local goods = mGoodsList[duty]
	if not goods then
		return
	end
	for i=store+1,15 do
		goods[i] = 0
	end
end

function GetMaxBuyCount(prouceId)
	local hero = mHeroManager.GetHero()
	local store = GetEmptyStoreCount()
	local product = CFG_product[prouceId]
	local count = math.floor(hero.money/product.price)
	return math.min(store, count)
end

function GetEmptyStoreCount()
	local hero = mHeroManager.GetHero()
	local store = ShipEmptyStoreCount(1)
	store = store + ShipEmptyStoreCount(2)
	store = store + ShipEmptyStoreCount(3)
	return store
end

function ShipEmptyStoreCount(index)
	local ships = mShipManager.GetShips()
	local ship = ships[index]
	if ship and ship.duty == index then
		local store = 0
		local goodsList = GetGoodsList()
		local goods = goodsList[index]
		local cfgShip = CFG_ship[ship.bid]
		for k=1,ship.store,1 do
			if not goods or not goods[k] or goods[k] == 0 then
				store = store + 1
			end
		end
		return store
	else
		return 0
	end
end

function SEND_DEL_GOODS(cs_ByteArray)
	-- mAudioManager.PlayAudioOneShot(AudioData.business)
	local shipIndex = ByteArray.ReadInt(cs_ByteArray) + 1
	local pos = ByteArray.ReadByte(cs_ByteArray) + 1
	mGoodsList[shipIndex][pos] = 0
end

function SEND_GOODS_PRICE(cs_ByteArray)
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	mRequestPriceing = false
	
	local hero = mHeroManager.GetHero()
	if harborId ~= hero.harborId then
		return
	end
	
	mGoodsPriceList = {}
	local count = ByteArray.ReadByte(cs_ByteArray)
	for k,goods in pairs(mGoodsList) do
		for k,v in pairs(goods) do
			if v ~= 0 then
				mGoodsPriceList[v] = ByteArray.ReadInt(cs_ByteArray)
			end
		end
	end
end

function SEND_GOODS_POPULAR(cs_ByteArray)
	mPopularType = ByteArray.ReadInt(cs_ByteArray)
	-- print("SEND_GOODS_POPULAR"..mPopularType)
end

function SEND_BONUS_GOODS(cs_ByteArray)
	mPopularCount = ByteArray.ReadInt(cs_ByteArray)
	-- print("SEND_BONUS_GOODS"..mPopularCount)
end

function SEND_DEL_All_GOODS(cs_ByteArray)
	print("SEND_DEL_All_GOODS")
	mGoodsList = {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}
	AppearEvent(nil,EventType.SellAllGoods)
	-- print("SEND_BONUS_GOODS"..mPopularCount)
end

function RequestBuyGoods(goodsId, count)
	if count <= 0 then
		return
	end
	-- print("RequestBuyGoods")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.GOODS)
	ByteArray.WriteByte(cs_ByteArray,Packat_Goods.CLIENT_BUY_GOODS)
	ByteArray.WriteInt(cs_ByteArray,goodsId)
	ByteArray.WriteInt(cs_ByteArray,count)
	mNetManager.SendData(cs_ByteArray)
	
	mGuideManager.SetStopGuide(true)
end


-- function RequestBuyFullGoods(goodsID)
	-- local cs_ByteArray = ByteArray.Init()
	-- ByteArray.WriteByte(cs_ByteArray,PackatHead.GOODS)
	-- ByteArray.WriteByte(cs_ByteArray,Packat_Goods.CLIENT_FULL_BUY_GOODS)
	-- ByteArray.WriteInt(cs_ByteArray,goodsID)
	-- mNetManager.SendData(cs_ByteArray)
-- end

function RequestSellGoods(shipIndex, pos)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.GOODS)
	ByteArray.WriteByte(cs_ByteArray,Packat_Goods.CLINET_SELL_GOODS)
	ByteArray.WriteInt(cs_ByteArray,shipIndex)
	ByteArray.WriteByte(cs_ByteArray,pos)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSellAllGoods()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.GOODS)
	ByteArray.WriteByte(cs_ByteArray,Packat_Goods.CLIENT_FULL_SELL_GOODS)
	mNetManager.SendData(cs_ByteArray)
end

function RequesGoodPrice()
	if mRequestPriceing then
		return
	end
	mRequestPriceing = true
	
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.GOODS)
	ByteArray.WriteByte(cs_ByteArray,Packat_Goods.CLIENT_REQUEST_GOODS_PRICE)
	mNetManager.SendData(cs_ByteArray)
end