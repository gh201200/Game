local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_item,require,table,PackatHead,Packat_Item,ByteArray = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_item,require,table,PackatHead,Packat_Item,ByteArray
local CFG_itemSuit,math,EventType,CFG_box,Color,SceneType,string,Language,CFG_Equip,IPhonePlayer,platform = 
CFG_itemSuit,math,EventType,CFG_box,Color,SceneType,string,Language,CFG_Equip,IPhonePlayer,platform
local CFG_shipEquip,IosTestScript = CFG_shipEquip,IosTestScript
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
local mSelectAlert = nil
local mSetManager = nil
local mAddItemTip = nil
local mTurntablePanel = nil
local mDialogPanel = nil
local mAlert = nil
local mSailorViewPanel = nil
local mSailorSelectPanel = nil
local mSailorManager = nil
local mReceiveAwardPanel = nil
local mPackageViewPanel = nil
local mOpenBoxPanel = nil
local mHeroManager = nil
local mChangeNameAlert = nil
local mRollBossAward = nil
local mChatManager = nil
local mEquipSelectPanel = nil
local mEquipManager = nil
local mEquipMagicPanel = nil
local mItemUseTip = nil
module("LuaScript.Control.Data.ItemManager") -- 物品管理

local mItems = {}
local mItemsCountById = {}
local mItemsByType = {{},{},{},{},{},{}}
local mCostTip = nil

local mLimitItemList = {}

function GetItems()
	return mItems
end

function GetLimitItemCount(id)
	if mLimitItemList[id] then
		return mLimitItemList[id]
	end
	return 0
end

function GetItemsByType(type)
	if type == 0 then
		return mItems
	else
		return mItemsByType[type]
	end
end

function GetCouldDonateItems()
	local items = {}
	for k,v in pairs(mItems) do
		local cfg_item = CFG_item[v.id]
		if cfg_item.couldContribute == 1 then
			table.insert(items, v)
		end
	end
	return items
end

function GetItemByIndex(index)
	for k,v in pairs(mItems) do
		if v.index == index then
			return v
		end
	end
end

function GetItemById(id)
	for k,v in pairs(mItems) do
		if v.id == id then
			return v
		end
	end
end


function GetItemCountById(id)
	if mItemsCountById[id] then
		return mItemsCountById[id]
	end
	return 0
end

function GetItemIndex(id)
	if mItemsCountById[id] then
		return mItemsCountById[id].index
	end
	return 0
end

function ResetCostTip()
	mCostTip = mSetManager.GetCostTip()
end

function InitCFG()
	local hero = mHeroManager.GetHero()
	local cfg_item1 = CFG_item[117]
	if not cfg_item1.desc1 then
		cfg_item1.desc1 = cfg_item1.desc
	end
	local hero = mHeroManager.GetHero()
	local cfg_item2 = CFG_item[118]
	if not cfg_item2.desc1 then
		cfg_item2.desc1 = cfg_item2.desc
	end
	local hero = mHeroManager.GetHero()
	local cfg_item3 = CFG_item[119]
	if not cfg_item3.desc1 then
		cfg_item3.desc1 = cfg_item3.desc
	end
	
	local exp = 150 + hero.level * 50
	cfg_item1.desc = string.format(cfg_item1.desc1, exp)
	cfg_item2.desc = string.format(cfg_item2.desc1, exp * 2)
	cfg_item3.desc = string.format(cfg_item3.desc1, exp * 10)
	
	local cfg_item1 = CFG_item[120]
	if not cfg_item1.desc1 then
		cfg_item1.desc1 = cfg_item1.desc
	end
	local hero = mHeroManager.GetHero()
	local cfg_item2 = CFG_item[121]
	if not cfg_item2.desc1 then
		cfg_item2.desc1 = cfg_item2.desc
	end
	local hero = mHeroManager.GetHero()
	local cfg_item3 = CFG_item[122]
	if not cfg_item3.desc1 then
		cfg_item3.desc1 = cfg_item3.desc
	end
	
	local money = 1000 + hero.level * 100
	cfg_item1.desc = string.format(cfg_item1.desc1, money)
	cfg_item2.desc = string.format(cfg_item2.desc1, money * 2)
	cfg_item3.desc = string.format(cfg_item3.desc1, money * 10)
end

function Init()
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
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
	mSetManager = require "LuaScript.Control.System.SetManager"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	mTurntablePanel = require "LuaScript.View.Panel.Turntable.TurntablePanel"
	mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSailorSelectPanel = require "LuaScript.View.Panel.Sailor.SailorSelectPanel"
	mReceiveAwardPanel = require "LuaScript.View.Panel.Item.ReceiveAwardPanel"
	mMapPanel = require "LuaScript.View.Panel.Map.MapPanel"
	mOpenBoxPanel = require "LuaScript.View.Panel.Item.OpenBoxPanel" -- 一次使用多个物品的面板
	mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mChangeNameAlert = require "LuaScript.View.Alert.ChangeNameAlert"
	mRollBossAward = require "LuaScript.View.Panel.Main.RollBossAward"
	mChatManager = require "LuaScript.Control.Data.ChatManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipMagicPanel = require "LuaScript.View.Panel.Equip.EquipMagicPanel"
	mItemUseTip = require "LuaScript.View.Panel.Main.ItemUse"
	
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ALL_ITEM, SEND_ALL_ITEM)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ADD_ITEM, SEND_ADD_ITEM)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_DEL_ITEM, SEND_DEL_ITEM)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ITEM_COUNT_CHG, SEND_ITEM_COUNT_CHG)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_TURNTABLE_RLT, SEND_TURNTABLE_RLT)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_GIFTS_USED, SEND_GIFTS_USED)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ALL_LIMIT_BUY_ITEM, SEND_ALL_LIMIT_BUY_ITEM)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ADD_LIMIT_BUY_ITEM, SEND_ADD_LIMIT_BUY_ITEM)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_LIMIT_BUY_ITEM_COUNT, SEND_LIMIT_BUY_ITEM_COUNT)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_SPLIT_RLT, SEND_SPLIT_RLT)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_BOSS_ROLL_AWARD, SEND_BOSS_ROLL_AWARD)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ROLL_RLT, SEND_ROLL_RLT)
	-- mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_CHEST_RLT, SEND_CHEST_RLT)
	
	mEventManager.AddEventListen(nil, EventType.UseTurntable, UseTurntable)
	mEventManager.AddEventListen(nil, EventType.OnLoadComplete, UseTurntable)
end

function UseTurntable() -- 使用转盘
	-- print("UseTurntable")
	if mTurntablePanel.visible then
		return
	end
	-- print(1, mDialogPanel.visible)
	if mDialogPanel.visible then
		return
	end
	local hero = mHeroManager.GetHero()
	if not hero or hero.SceneType == SceneType.Battle then
		return
	end
	-- print(2)
	local item = GetItemById(27)
	if item then
		RequestUseItem(item.index)
		mPanelManager.Show(mTurntablePanel)
	end
end

function SEND_ALL_ITEM(cs_ByteArray) -- 全部物品
	-- print("SEND_ALL_ITEM")
	mItems = {}
	mItemsByType = {{},{},{},{},{},{}}
	mItemsCountById = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local item = {}
		item.index = ByteArray.ReadInt(cs_ByteArray)
		item.id = ByteArray.ReadInt(cs_ByteArray)
		item.count = ByteArray.ReadInt(cs_ByteArray)
		table.insert(mItems, item)
		
		mItemsCountById[item.id] = mItemsCountById[item.id] or 0
		mItemsCountById[item.id] = mItemsCountById[item.id] + item.count
		
		local cfg_item = CFG_item[item.id]
		if cfg_item.type ~= 0 then
			table.insert(mItemsByType[cfg_item.type], item)
		end
	end
	table.sort(mItems, SortFunc)
	
	InitCFG()
end

function SortFunc(a, b) -- 物品分类
	local cfg_a = CFG_item[a.id]
	local cfg_b = CFG_item[b.id]
	if cfg_a.action == 11 and cfg_b.action ~= 11 then -- 任务道具
		return true
	elseif cfg_a.action ~= 11 and cfg_b.action == 11 then
		return false
	end
	
	if a.id == 19 and b.id ~= 19 then
		return true
	elseif a.id ~= 19 and b.id == 19 then
		return false
	end
	
	if a.id == 20 and b.id ~= 20 then
		return true
	elseif a.id ~= 20 and b.id == 20 then
		return false
	end
	
	if a.id == 21 and b.id ~= 21 then
		return true
	elseif a.id ~= 21 and b.id == 21 then
		return false
	end
	
	if a.id == 47 and b.id ~= 47 then
		return true
	elseif a.id ~= 47 and b.id == 47 then
		return false
	end
	
	if a.id == 94 and b.id ~= 94 then
		return true
	elseif a.id ~= 94 and b.id == 94 then
		return false
	end
	
	if a.id == 55 and b.id ~= 55 then
		return true
	elseif a.id ~= 55 and b.id == 55 then
		return false
	end
	if a.id == 54 and b.id ~= 54 then
		return true
	elseif a.id ~= 54 and b.id == 54 then
		return false
	end
	if a.id == 53 and b.id ~= 53 then
		return true
	elseif a.id ~= 53 and b.id == 53 then
		return false
	end
	if a.id == 52 and b.id ~= 52 then
		return true
	elseif a.id ~= 52 and b.id == 52 then
		return false
	end
	
	if a.id < b.id then
		return true
	end
	return false
end

function SEND_ADD_ITEM(cs_ByteArray) -- 请求添加物品
	-- print("SEND_ADD_ITEM")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	
	local item = {}
	item.index = index
	item.id = id
	item.count = count
	table.insert(mItems, item)
	
	local cfg_item = CFG_item[id]
	if (mItemsCountById[item.id] == nil or mItemsCountById[item.id] == 0) and cfg_item.use == 1 then
		mItemUseTip.ShowTip(id)
	end
	
	mItemsCountById[item.id] = item.count
	table.sort(mItems, SortFunc)
	
	
	if cfg_item.type ~= 0 then
		table.insert(mItemsByType[cfg_item.type], item)
	end
	
	if cfg_item.action ~= 8 then
		mAddItemTip.ShowTip(0, id, count)
	end
	
	if cfg_item.action == 9 then
		RequestUseItem(item.index)
	end
	UseTurntable()
end


function SEND_DEL_ITEM(cs_ByteArray)-- 请求删除物品
	-- print("SEND_DEL_ITEM")
	local index = ByteArray.ReadInt(cs_ByteArray)
	-- local count = ByteArray.ReadInt(cs_ByteArray)
	
	-- local key = nil
	-- local item = nil
	for k,item in pairs(mItems) do
		if item.index == index then
			table.remove(mItems, k)
			mItemsCountById[item.id] = 0
			
			local cfg_item = CFG_item[item.id]
			if cfg_item.type ~= 0 then
				for kk,vv in pairs(mItemsByType[cfg_item.type]) do
					if vv == item then
						table.remove(mItemsByType[cfg_item.type], kk)
						break
					end
				end
			end
			
			break
		end
	end
end

function SEND_ITEM_COUNT_CHG(cs_ByteArray)
	-- print("SEND_ITEM_COUNT_CHG")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	
	-- local key = nil
	local item = nil
	local change = 0
	for k,v in pairs(mItems) do
		if v.index == index then
			item = v
			change = count - v.count
			v.count = count
			mItemsCountById[v.id] = v.count
			break
		end
	end
	
	if change > 0 then
		mAddItemTip.ShowTip(0, item.id, change)
	end
	
end


function SEND_TURNTABLE_RLT(cs_ByteArray) -- 转盘
	-- print("SEND_TURNTABLE_RLT")
	local index = ByteArray.ReadInt(cs_ByteArray)
	mTurntablePanel.SetData(index)
end

function SEND_GIFTS_USED(cs_ByteArray) -- 礼包
	local id = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	mPackageViewPanel.SetData(id, count)
	mPanelManager.Show(mPackageViewPanel)
end

function SEND_ALL_LIMIT_BUY_ITEM(cs_ByteArray)
	-- print("SEND_ALL_LIMIT_BUY_ITEM")
	local count = ByteArray.ReadInt(cs_ByteArray)
	
	for k=1,count do
		local id = ByteArray.ReadInt(cs_ByteArray)
		local num = ByteArray.ReadByte(cs_ByteArray)
		mLimitItemList[id] = num
	end
end

function SEND_ADD_LIMIT_BUY_ITEM(cs_ByteArray)
	-- print("SEND_ADD_LIMIT_BUY_ITEM")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local num = ByteArray.ReadByte(cs_ByteArray)
	mLimitItemList[id] = num
end

function SEND_LIMIT_BUY_ITEM_COUNT(cs_ByteArray)
	-- print("SEND_LIMIT_BUY_ITEM_COUNT")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local num = ByteArray.ReadByte(cs_ByteArray)
	mLimitItemList[id] = num
end

function SEND_SPLIT_RLT(cs_ByteArray)
	-- print("SEND_SPLIT_RLT")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local num = ByteArray.ReadByte(cs_ByteArray)
	if num == 0 then
		mSystemTip.ShowTip(Language[210], Color.LimeStr)
	else
		local cfg_item = CFG_item[id]
		mHeroTip.ShowTip("获得:"..cfg_item.name.."×"..num)
	end
end


function SEND_BOSS_ROLL_AWARD(cs_ByteArray) -- boss 随机装备
	-- print("SEND_BOSS_ROLL_AWARD")
	local bossID = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	-- print(bossID,count)
	local awardList = {}
	for i=1,count,1 do
		local awardId = ByteArray.ReadInt(cs_ByteArray)
		local itemId = ByteArray.ReadInt(cs_ByteArray)
		local itemType = ByteArray.ReadByte(cs_ByteArray)
		local itemCount = ByteArray.ReadInt(cs_ByteArray)
		table.insert(awardList, {id=itemId, type=itemType, count=itemCount, index=awardId, star=0,
				notExist=true})
	end
	-- print(awardList)
	mRollBossAward.SetData(bossID, awardList)
	-- mPanelManager.Show(mRollBossAward)
end



function SEND_ROLL_RLT(cs_ByteArray) -- rool点
	-- print("SEND_ROLL_RLT")
	local bossID = ByteArray.ReadInt(cs_ByteArray)
	local itemType = ByteArray.ReadByte(cs_ByteArray)
	local itemID = ByteArray.ReadInt(cs_ByteArray)
	local name = ByteArray.ReadUTF(cs_ByteArray, 40)
	local roll = ByteArray.ReadByte(cs_ByteArray)
	local exRoll = ByteArray.ReadByte(cs_ByteArray)
	
	-- print(itemType,itemID)
	local itemName = ""
	if itemType == 0 then
		local cfg_item = CFG_item[itemID]
		itemName = cfg_item.name
	elseif itemType == 1 then
		local cfg_equip = CFG_Equip[itemID]
		itemName = cfg_equip.name
	else
		local cfg_equip = CFG_shipEquip[itemID]
		itemName = cfg_equip.name
	end
	
	if roll > 0 then
		roll = roll - exRoll
		local str = string.format("【奖励-%s】[%s]掷出%d+%d(附加)", itemName, name, roll, exRoll)
		mSystemTip.ShowTip(str, Color.LimeStr)
		mChatManager.AddServerMsg(str)
	else
		local str = string.format("【奖励-%s】[%s]放弃该奖励", itemName, name)
		mSystemTip.ShowTip(str, Color.LimeStr)
		mChatManager.AddServerMsg(str)
	end
end



function UseItem(item) -- 使用物品
	local hero = mHeroManager.GetHero()
	if item.id == 50 or item.id == 51 then -- 大小免战牌
		if hero.level < 28 then
			mSystemTip.ShowTip("新手期无法使用该道具", Color.RedStr)
			return
		end
		
		if hero.mode == 2 then 
			mSystemTip.ShowTip("和平模式无需使用该道具", Color.RedStr)
			return
		end
	end
	
	local cfg_item = CFG_item[item.id]
	if cfg_item.action == 1 then -- 强化石类
		-- mPanelManager.Hide(mItemBagPanel)
		mPanelManager.Show(mItemBagPanel)
		-- mEquipUpPanel.SetSelectGem(item.id)]
		mItemBagPanel.SetPage(2)
		mSystemTip.ShowTip("请选择需要强化的装备", Color.LimeStr)
	elseif cfg_item.action == 2 then -- 
		-- mPanelManager.Show(mMainPanel)
		mPanelManager.Show(mChatPanel)
		mChatPanel.SetChannel(1)
	elseif cfg_item.action == 3 or cfg_item.action == 11 then -- 碎片，藏宝图，潜能石等，使用后向服务器请求效果 
		RequestUseItem(item.index)
	elseif cfg_item.action == 4 then -- 宝箱
		local needId = cfg_item.id + 3
		if item.count > 1 then
			--ios test script
			if IosTestScript then
				if GetItemCountById(needId) <= 0 then
					mSystemTip.ShowTip("没有宝箱钥匙,无法开启宝箱")
					return
				end
			end
			mOpenBoxPanel.SetData(item.index, item.id, needId)
			mPanelManager.Show(mOpenBoxPanel)
		else
			local cfg_needItem = CFG_item[needId]
			if GetItemCountById(needId) <= 0 then
				--ios test script
				if IosTestScript then
					mSystemTip.ShowTip("没有宝箱钥匙,无法开启宝箱")
					return
				end
				if mCostTip then
					function OkFunc(showTip)
						if not mCommonlyFunc.HaveGold(cfg_needItem.price) then
							return
						end
						RequestUseItem(item.index)
						mCostTip = not showTip
					end
					mSelectAlert.Show(cfg_needItem.name.."不足，是否花费"..cfg_needItem.price.."元宝购买?", OkFunc)
				else
					if not mCommonlyFunc.HaveGold(cfg_needItem.price) then
						return
					end
					RequestUseItem(item.index)
				end
				return
			end
			RequestUseItem(item.index)
		end
	elseif cfg_item.action == 5 then -- 宝箱钥匙
		local needId = cfg_item.id - 3
		if item.count > 1 then
			--ios test script
			if IosTestScript then
				if GetItemCountById(needId) <= 0 then
					mSystemTip.ShowTip("没有宝箱,无法使用宝箱钥匙")
					return
				end
			end
			mOpenBoxPanel.SetData(item.index, needId, item.id)
			mPanelManager.Show(mOpenBoxPanel)
		else
			local cfg_needItem = CFG_item[needId]
			if GetItemCountById(needId) <= 0 then
				--ios test script
				if IosTestScript then
					mSystemTip.ShowTip("没有宝箱,无法使用宝箱钥匙")
					return
				end
				if mCostTip then
					function OkFunc(showTip)
						if not mCommonlyFunc.HaveGold(cfg_needItem.price) then
							return
						end
						RequestUseItem(item.index)
						mCostTip = not showTip
					end
					mSelectAlert.Show(cfg_needItem.name.."不足，是否花费"..cfg_needItem.price.."元宝购买?", OkFunc)
				else
					if not mCommonlyFunc.HaveGold(cfg_needItem.price) then
						return
					end
					RequestUseItem(item.index)
				end
				return
			end
			RequestUseItem(item.index)
		end
	elseif cfg_item.action == 6 then -- 转盘随机抽一个物品
		RequestUseItem(item.index)
	elseif cfg_item.action == 7 then -- 魂魄材料  --8 是各类礼包
		function selectFunc(sailor)
			mPanelManager.Show(mItemBagPanel)
			if sailor then
				mSailorViewPanel.SetData(sailor, 2)
				mPanelManager.Show(mSailorViewPanel)
			end
		end
		local mSailor = mSailorManager.GetSailors()
		mSailorSelectPanel.SetData(selectFunc, mSailor)
		
		mPanelManager.Show(mSailorSelectPanel)
		mPanelManager.Hide(mItemBagPanel)
		
		mSystemTip.ShowTip("请选择需要突破的船员", Color.LimeStr)
	elseif cfg_item.action == 9 then --9是史诗船员卡牌,和部分大海盗的碎片
		RequestUseItem(item.index)
	elseif cfg_item.action == 10 then --玩家传送时消耗的传送令牌
		mMapPanel.ResetCenter()
		mPanelManager.Show(mMapPanel)
		mPanelManager.Hide(mItemBagPanel)
		
		mSystemTip.ShowTip("请选择目标地点", Color.LimeStr)
	elseif cfg_item.action == 12 then  -- 至高契约，强制改变和平，PK模式
		if hero.level < 28 then
			mSystemTip.ShowTip("新手期无法使用该道具", Color.RedStr)
			return
		end
		function OkFunc()
			if hero.mode == 1 then
				mHeroManager.RequestSelectMode(2)
			else
				mHeroManager.RequestSelectMode(1)
			end
		end
		mAlert.Show("是否使用至高契约,更换当前模式?", OkFunc)
	elseif cfg_item.action == 13 then -- 使用聚宝盆获取金币
		if item.count > 1 then
			mOpenBoxPanel.SetData(item.index, item.id, 0)
			mPanelManager.Show(mOpenBoxPanel)
		else
			RequestUseItem(item.index)
		end
	elseif cfg_item.action == 14 then -- 附魔石使用
		if hero.level < 30 then
			mSystemTip.ShowTip("30级开放附魔功能")
			return
		end
		
		function selectFunc(equip)
			mPanelManager.Show(mItemBagPanel)
			if equip then
				mEquipMagicPanel.SetData(equip)
				mPanelManager.Show(mEquipMagicPanel)
			end
		end
		local equips = mEquipManager.GetEquips()
		mEquipSelectPanel.SetData(nil,nil,selectFunc,nil,equips)
		mPanelManager.Hide(mItemBagPanel)
		mPanelManager.Show(mEquipSelectPanel)
		mSystemTip.ShowTip("请选择需要附魔的装备", Color.LimeStr)
	elseif cfg_item.action == 15 then -- 改名卡
		mPanelManager.Show(mChangeNameAlert)
	end
end

function RequestUseItem(index) -- 请求使用一对应ID的物品
	-- print("RequestUseItem")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_USE_ITEM)
	ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function RequestOpenBox(index, count)
	-- print("RequestOpenBox", index, count)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_MULTI_USE_CHEST)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteInt(cs_ByteArray,count)
	mNetManager.SendData(cs_ByteArray)
end

function OpenTreasure()
	-- print("OpenTreasure")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_OPEN_TREASURE)
	mNetManager.SendData(cs_ByteArray)
end

function RequestUsePackageKey(key)
	-- print("RequestUsePackageKey")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_SERIAL)
	ByteArray.WriteUTF(cs_ByteArray, key, 11)
	mNetManager.SendData(cs_ByteArray)
end

function RequestBuyItem(id, count)
	-- print("RequestBuyItem",id,count)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_BUY_ITEM)
	ByteArray.WriteInt(cs_ByteArray, id)
	ByteArray.WriteInt(cs_ByteArray, count)
	mNetManager.SendData(cs_ByteArray)
end

function RequestStopTurntable()
	-- print("RequestBuyItem",id,count)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_TURN_TABLE_STOP)
	mNetManager.SendData(cs_ByteArray)
end

function RequestRollItem(bossId, index, roll)
	-- print("RequestBuyItem",id,count)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_ROLL)
	ByteArray.WriteInt(cs_ByteArray,bossId)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteByte(cs_ByteArray,roll)
	mNetManager.SendData(cs_ByteArray)
end

function RequestGoldGetTreasure()
	-- print("RequestBuyItem",id,count)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_GOLDGET_TREASURE)
	ByteArray.WriteInt(cs_ByteArray,1)
	mNetManager.SendData(cs_ByteArray)
end