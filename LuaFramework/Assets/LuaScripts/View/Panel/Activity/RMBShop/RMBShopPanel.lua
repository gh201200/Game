local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib
local SceneType,ConstValue,EventType,ActivityType,ActivityButton,ActivityName,Input,KeyCode,CFG_item = 
SceneType,ConstValue,EventType,ActivityType,ActivityButton,ActivityName,Input,KeyCode,CFG_item
local AssetType,CFG_rmbshop = AssetType,CFG_rmbshop
local mPackageViewPanel = nil
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mFamilyManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFamilyMemberPanel = nil
local mFamilyRecordPanel = nil
local mFamilyApplyerPanel = nil
local mHarborPanel = nil
local mFamilyNoticePanel = nil
local mEventManager = nil
local mHarborBattlePanel = nil
local mActivityManager = nil
local mEnemyTreasurePanel = nil
local mEmenyAttackPanel = nil
local mCollectTreasureMapPanel = nil
local mPackageKeyPanel = nil
local mGiftListManager = nil
local mItemViewPanel = nil
local mBuyPanel = nil
local mItemManager = nil
local mRechargePanel = nil
local discount = 0

module("LuaScript.View.Panel.Activity.RMBShop.RMBShopPanel") -- 奇珍异宝商店

local mScrollPositionX = 0

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"
	mPackageKeyPanel = require "LuaScript.View.Panel.Item.PackageKeyPanel"
	mGiftListManager = require "LuaScript.Control.Data.GiftListManager"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mBuyPanel = require "LuaScript.View.Panel.Activity.RMBShop.BuyPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	
	IsInit = true
end

function Display()
	mScrollPositionX = 0
end

function OnGUI()
	if not IsInit then
		return
	end
	discount = mHeroManager.GetDefaultDiscount()
	-- local mGiftList = mGiftListManager.GetGiftList()
	local spacing = 225
	local count = #CFG_rmbshop
	mScrollPositionX,_ = GUI.BeginScrollView(123,117,890,340, mScrollPositionX, 0, 0, 0,(k or count)*spacing, 340)
		k = 0
		for index=1,count,1 do
			local item = CFG_rmbshop[index]
			if CouldBuy(item) then
				k = k + 1
				
				local x = k * spacing - spacing
				DrawItem(x,0,item)
			end
		end
	GUI.EndScrollView()
	
	if GUI.Button(120-27,300,64,64,nil, GUIStyleButton.LeftBtn) then
		mScrollPositionX = mScrollPositionX - spacing * 4
	end
	if GUI.Button(965+20,300,64,64,nil, GUIStyleButton.RightBtn) then
		mScrollPositionX = mScrollPositionX + spacing * 4
	end
end

function CouldBuy(item)
	local serverTime = mActivityManager.GetServerTime()
	if not serverTime then
		return
	end
	local hero = mHeroManager.GetHero()
	if (item.endTime == 0 or item.endTime > serverTime) and item.vip <= hero.vipLevel + 2 and 
		(item.count == -1 or mItemManager.GetLimitItemCount(item.itemId) < item.count)
		and (item.startTime == 0 or item.startTime < serverTime) then
		return true
	end
end

function CouldBuyCount(item) 
	if item.count == -1 then
		return -1
	else
		return item.count - mItemManager.GetLimitItemCount(item.itemId)
	end
end

function DrawItem(x,y,item)
	local hero = mHeroManager.GetHero()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg37_1")
	GUI.DrawTexture(x,y,225,345,image)
	
	local cfg_item = CFG_item[item.itemId]
	-- 名称
	GUI.Label(x+44,y+18,129,30,cfg_item.name, GUIStyleLabel.Center_30_Brown_Art)
	
	local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, x+72, y+74,80,80) then
		-- if cfg_item.action == 8 then
			-- mPackageViewPanel.SetData(item.itemId)
			-- mPanelManager.Show(mPackageViewPanel)
		-- else
			-- mItemViewPanel.SetData(item.itemId)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
	end
	
	local buyCount = CouldBuyCount(item) -- 可以购买数量
	if buyCount > 1 then
		GUI.Label(x+19,y+122,129,30, buyCount, GUIStyleLabel.Right_30_White, Color.Black)
	end
	
	local str = ""
	if item.endTime ~= 0 then
		str = mCommonlyFunc.GetRMBTime(item.endTime)
	else
		if discount ~= 1 then
			str = "<color=red>" .. discount * 10 .. "折甩卖 </color>\n"
		end
	end

	
	if item.vip ~= 0 then -- 需求VIP
		str = mCommonlyFunc.GetRMBVip(item.vip, hero.vipLevel)
	end
	
	str = str.."价格:"..cfg_item.price.."元宝"
	GUI.Label(x+41,y+204,144,30, str, GUIStyleLabel.MCenter_21_White, Color.Black)
	
	-- local oldEnabled = GUI.GetEnabled()
	if item.vip > hero.vipLevel then
		if GUI.Button(x+28, y+263,166,77,"充值", GUIStyleButton.BlueBtn) then
			mPanelManager.Show(mRechargePanel)
		end
	else
		if GUI.Button(x+28, y+263,166,77,"购买", GUIStyleButton.BlueBtn) then
			if mCommonlyFunc.HaveGold(cfg_item.price) then
				mBuyPanel.SetData(item.itemId, buyCount)
				mPanelManager.Show(mBuyPanel)
			end
		end
	end
	
	-- if item.vip > hero.vipLevel then
		-- GUI.SetEnabled(oldEnabled)
	-- end
end