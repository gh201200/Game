local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib
local SceneType,ConstValue,EventType,ActivityType,ActivityButton,ActivityName,Input,KeyCode,CFG_item = 
SceneType,ConstValue,EventType,ActivityType,ActivityButton,ActivityName,Input,KeyCode,CFG_item
local AssetType,DrawItemCell,ItemType = AssetType,DrawItemCell,ItemType
local mPackageViewPanel = nil
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

module("LuaScript.View.Panel.Activity.GiftList.GiftListPanel")
-- local mGiftList = {{itemId = 71,str="输入礼包序列号\n领取各类礼包",type=0,btnName="兑换"},
					-- {itemId = 56,str="维护补偿\n有效期:9月16号"},
					-- {itemId = 56,str="维护补偿\n有效期:9月16号"},
					-- {itemId = 56,str="维护补偿\n有效期:9月16号"},
					-- {itemId = 56,str="维护补偿\n有效期:9月16号"},
					-- {itemId = 56,str="维护补偿\n有效期:9月16号"}}

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
	
	IsInit = true
end

function Display()
	mScrollPositionX = 0
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local mGiftList = mGiftListManager.GetGiftList()
	local spacing = 225
	local count = #mGiftList
	mScrollPositionX,_ = GUI.BeginScrollView(123,117,890,340, mScrollPositionX, 0, 0, 0,count*spacing, 340)
		for index=1,count,1 do
			local award = mGiftList[index]
			local x = index * spacing - spacing
			DrawAward(x,0,award)
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg35_1")
		if count < 2 then
			GUI.DrawTexture(1 * spacing,0,225,345,image)
		end
		if count < 3 then
			GUI.DrawTexture(2 * spacing,0,225,345,image)
		end
		if count < 4 then
			GUI.DrawTexture(3 * spacing,0,225,345,image)
		end
	GUI.EndScrollView()
end

function DrawAward(x,y,gift)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg35_1")
	GUI.DrawTexture(x,y,225,345,image)
	
	local cfg_item = CFG_item[gift.itemId]
	
	GUI.Label(x+44,y+38,129,30,cfg_item.name, GUIStyleLabel.Center_30_Brown_Art)
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, x+72, y+108,80,80, true, false, false) then
		if gift.type ~= -1 then
			mPackageViewPanel.SetData(gift.itemId)
			mPanelManager.Show(mPackageViewPanel)
		else
			mSystemTip.ShowTip("输入兑换码换取奖励")
		end
	end
	
	GUI.Label(x+40,y+220,144,30, gift.str, GUIStyleLabel.MCenter_19_White, Color.Black)
	
	if GUI.Button(x+28, y+263,166,77,gift.btnName or "领取", GUIStyleButton.BlueBtn) then
		if gift.type == -1 then
			mPanelManager.Show(mPackageKeyPanel)
		elseif gift.type == -2 then
			mGiftListManager.RequesExchange(gift.itemId)
		else
			mGiftListManager.RequesGetGift(gift.id)
		end
		-- mPanelManager.Show(OnGUI)
	end
end