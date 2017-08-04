local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_item,require,table,PackatHead,Packat_Item,ByteArray = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_item,require,table,PackatHead,Packat_Item,ByteArray
local CFG_itemSuit,math,Packat_CopyMap,CFG_copyMap,os,Packat_Player,EventType,AppearEvent,CFG_copyMapDrop,CFG_copyMapPassAward = 
CFG_itemSuit,math,Packat_CopyMap,CFG_copyMap,os,Packat_Player,EventType,AppearEvent,CFG_copyMapDrop,CFG_copyMapPassAward
local mNetManager = nil
local mSystemTip = nil
local mHeroTip = nil
local mEventManager = nil
local mCommonlyFunc = nil
-- 
local mChatPanel = nil
local mPanelManager = nil
local mEquipUpPanel = nil
local mMainPanel = nil
local mItemBagPanel = nil
local mHeroManager = nil
local mEquipManager = nil
local mItemManager = nil
local mBattleAwardPanel = nil
local mReceiveAwardPanel = nil
local mShipEquipManager = nil
module("LuaScript.Control.Data.CopyMapManager")

local mCleanInfo = nil
local mMaxCopyMapId = 0
local mMaxCopyMapLevel = 1
local mCleaning = false
local mRequestCleaning = false

local mAwardList = nil

function GetCleaning()
	return mCleaning
end

function GetCleanInfo()
	return mCleanInfo
end

function GetMaxCopyMapLevel()
	return mMaxCopyMapLevel
end

function GetMaxCopyMapId()
	return mMaxCopyMapId
end

function GetMaxCopyMapIdByAward(type, id)
	local key = type * 10000 + id
	if not mAwardList[key] then
		return
	end
	
	local cmId = mAwardList[key][1]
	for k,v in pairs(mAwardList[key]) do
		if v >= mMaxCopyMapId then
			break
		end
		cmId = v
	end
	return cmId
end

function BuyCountCost(count)
	local hero = mHeroManager.GetHero()
	local cost = 0
	for i=1,count,1 do
		-- local buyCount = math.min(i + hero.copyMapBuyCount, 7)
		cost = cost + math.floor((i + hero.copyMapBuyCount + 9)/10)*10
	end
	return cost
end

function InitAward(mCopyMapId)
	local awardList = {}
	for k,v in pairs(CFG_copyMapPassAward) do
		if v.copyMapId == mCopyMapId and mMaxCopyMapId < mCopyMapId then
			table.insert(awardList, {id=v.awardId,type=v.awardType,count=v.count,firstAward=true})
		end
	end
	for k,v in pairs(CFG_copyMapDrop) do
		if v.copyMap == mCopyMapId and v.activity == 0 then
			table.insert(awardList, {id=v.award,type=v.type,count=v.count})
		end
	end
	return awardList
end

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mHeroTip = require "LuaScript.View.Tip.HeroTip"
	-- 
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mChatPanel = require "LuaScript.View.Panel.Chat.ChatPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mBattleAwardPanel = require "LuaScript.View.Panel.Battle.BattleAwardPanel"
	mReceiveAwardPanel = require "LuaScript.View.Panel.Item.ReceiveAwardPanel"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_FINISHED_INSTANCE, SEND_FINISHED_INSTANCE)
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_AUTO_INSTANCE_INFO, SEND_AUTO_INSTANCE_INFO)
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_INSTANCE_AWARD, SEND_INSTANCE_AWARD)
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_ADD_FINISHED_INSTANCE, SEND_ADD_FINISHED_INSTANCE)
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_NEW_ENEMY_ROUND, SEND_NEW_ENEMY_ROUND)
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
	-- mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ADD_ITEM, SEND_ADD_ITEM)
	-- mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_DEL_ITEM, SEND_DEL_ITEM)
	-- mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ITEM_COUNT_CHG, SEND_ITEM_COUNT_CHG)
	
	mAwardList = {}
	for k,v in pairs(CFG_copyMap) do
		local key = v.type1 * 10000 + v.award1
		mAwardList[key] = mAwardList[key] or {}
		table.insert(mAwardList[key], k)
		
		local key = v.type2 * 10000 + v.award2
		mAwardList[key] = mAwardList[key] or {}
		table.insert(mAwardList[key], k)
		
		local key = v.type3 * 10000 + v.award3
		mAwardList[key] = mAwardList[key] or {}
		table.insert(mAwardList[key], k)
	end
	
end

function ConnectFailure()
	mCleanInfo = nil
	mMaxCopyMapId = 0
	mMaxCopyMapLevel = 1
	mCleaning = false
	mRequestCleaning = false
end

function SEND_FINISHED_INSTANCE(cs_ByteArray)
	-- print("SEND_FINISHED_INSTANCE")
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local id = ByteArray.ReadInt(cs_ByteArray)
		if id > mMaxCopyMapId then
			mMaxCopyMapId = id
		end
	end
	local cfg_copyMap = CFG_copyMap[mMaxCopyMapId]
	if cfg_copyMap then
		mMaxCopyMapLevel = cfg_copyMap.level
	end
	local cfg_copyMap = CFG_copyMap[mMaxCopyMapId+1]
	if cfg_copyMap then
		mMaxCopyMapLevel = cfg_copyMap.level
	end
end

function SEND_AUTO_INSTANCE_INFO(cs_ByteArray)
	-- print("SEND_AUTO_INSTANCE_INFO")
	mRequestCleaning = false
	
	mCleanInfo = mCleanInfo or {}
	mCleanInfo.id = ByteArray.ReadInt(cs_ByteArray)
	mCleanInfo.count = ByteArray.ReadByte(cs_ByteArray)
	mCleanInfo.maxCount = ByteArray.ReadByte(cs_ByteArray)
	mCleanInfo.cd = ByteArray.ReadInt(cs_ByteArray)
	mCleanInfo.cd = mCleanInfo.cd + (mCleanInfo.count-1)*300
	mCleanInfo.updateTime = os.oldTime

	mCleaning = (mCleanInfo.id ~= 0)
	
	if not mCleaning then
		AppearEvent(nil, EventType.CopyMapCleanOver)
	end
	-- if mCleanInfo.maxCount == 0 then
		-- mCleanInfo = nil
		-- return
	-- end
	
	mCleanInfo.awardInfo = mCleanInfo.awardInfo or {}
	if mCleanInfo.count == mCleanInfo.maxCount and  mCleanInfo.maxCount ~= 0 then
		mCleanInfo.awardInfo = {}
		-- print(1111111)
	end
	-- print(mCleanInfo)
end

function SEND_INSTANCE_AWARD(cs_ByteArray)
	-- print("SEND_INSTANCE_AWARD")
	local battleAward = ByteArray.ReadBool(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	local money = ByteArray.ReadInt(cs_ByteArray)
	local exp = ByteArray.ReadInt(cs_ByteArray)
	local round = ByteArray.ReadByte(cs_ByteArray)
	-- print(round)
	-- print(battleAward)
	-- print(count)
	-- if count <= 0 then
		-- return
	-- end
	local award = {items={},money=money,exp=exp,round=round,}
	for i=1,count,1 do
		local item = {}
		item.type = ByteArray.ReadByte(cs_ByteArray)
		item.index = ByteArray.ReadInt(cs_ByteArray)
		item.count = ByteArray.ReadInt(cs_ByteArray)
		-- print(item)
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
		-- item.notExist = true
		table.insert(award.items, item) 
	end
	-- print(round)
	if battleAward then
		if round == 0 and count > 0 then
			mBattleAwardPanel.SetData(award)
			mPanelManager.Show(mBattleAwardPanel)
		elseif mCleanInfo then
			mCleanInfo.awardInfo[round] = award
		end
	elseif count > 0 then
		mReceiveAwardPanel.Show(award.items)
	end
	AppearEvent(nil, EventType.CopyMapAward, round)
end

function SEND_ADD_FINISHED_INSTANCE(cs_ByteArray)
	-- print("SEND_ADD_FINISHED_INSTANCE")
	local id = ByteArray.ReadInt(cs_ByteArray)
	if id > mMaxCopyMapId then
		mMaxCopyMapId = id
		
		local cfg_copyMap = CFG_copyMap[mMaxCopyMapId]
		mMaxCopyMapLevel = cfg_copyMap.level
		local cfg_copyMap = CFG_copyMap[mMaxCopyMapId+1]
		if cfg_copyMap then
			mMaxCopyMapLevel = cfg_copyMap.level
		end
		
		AppearEvent(nil, EventType.RefreshCopyMap)
	end
end

function SEND_NEW_ENEMY_ROUND(cs_ByteArray)
	-- print("SEND_NEW_ENEMY_ROUND")
	
end

function Enter(id)
	-- print("Enter", id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.COPYMAP)
	ByteArray.WriteByte(cs_ByteArray,Packat_CopyMap.CLIENT_REQUEST_ENTER_INSTANCE)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function RequestClean(id, count)
	-- print("RequestClean", id, count)
	
	if mRequestCleaning then
		return
	end
	mRequestCleaning = true
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.COPYMAP)
	ByteArray.WriteByte(cs_ByteArray,Packat_CopyMap.CLIENT_REQUEST_AUTO_FINISH_INSTANCE)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteByte(cs_ByteArray,count)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSpeedUp()
	-- print("RequestSpeedUp")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.COPYMAP)
	ByteArray.WriteByte(cs_ByteArray,Packat_CopyMap.CLIENT_REQUEST_FAST_AUTO_FINISH_INSTANCE)
	mNetManager.SendData(cs_ByteArray)
end

function RequestAddCount()
	-- print("RequestAddCount")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_BUY_VIGOR)
	mNetManager.SendData(cs_ByteArray)
end

