local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,Vector2,CFG_product = ConstValue,CFG_EquipSuit,Vector2,CFG_product
local AssetType,CFG_item = AssetType,CFG_item
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mCharManager = nil
local mGoodsManager = nil
local mPanelManager = nil
local mItemManager = nil
local mSystemTip = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mItemViewPanel = nil
local mPackageViewPanel = nil

module("LuaScript.View.Panel.Activity.RMBShop.BuyPanel") -- 道具购买界面，选择数量
panelType = ConstValue.AlertPanel

local mItemId = 0
local mMaxCount = 0
local mCount = 0

function SetData(itemId, count)
	mItemId = itemId
	
	mCount = 1
	
	local cfg_item = CFG_item[itemId]
	local hero = mHeroManager.GetHero()
	if count == -1 then
		mMaxCount = math.floor(hero.gold/cfg_item.price)
	else
		if math.floor(hero.gold/cfg_item.price) < count then
			mMaxCount = math.floor(hero.gold/cfg_item.price)
		else
			mMaxCount = count
		end
	end
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	-- mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg39_1")
	GUI.DrawTexture(238,118,671,429,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg38_1")
	GUI.DrawTexture(485,331,169,79,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg8_1")
	GUI.DrawTexture(418,233.45,422,42,image)
	GUI.DrawTexture(418,285.45,422,42,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/bugItem")
	GUI.DrawTexture(413,167,170,47,image)
	
	local cfg_item = CFG_item[mItemId]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, 373,229,100,100) then
		-- if cfg_item.action == 8 then
			-- mPackageViewPanel.SetData(mItemId)
			-- mPanelManager.Show(mPackageViewPanel)
		-- else
			-- mItemViewPanel.SetData(mItemId)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
	end
	
	-- local str = "购买\""..cfg_item.name.."\"×"..mCount
	GUI.Label(588, 180, 184, 30, "("..cfg_item.name..")", GUIStyleLabel.Left_30_Brown)
	GUI.Label(537, 350, 64, 30, mCount, GUIStyleLabel.Center_40_White_Bold, Color.Black)
	
	local cost = cfg_item.price*mCount
	local hero = mHeroManager.GetHero()
	
	if GUI.Button(291, 336, 113, 77, "-10", GUIStyleButton.SmallBlueBtn_1) then
		mCount = mCount - 10
	end
	if GUI.Button(404, 336, 81, 77, "-1", GUIStyleButton.SmallBlueBtn_1) then
		mCount = mCount - 1
	end
	if GUI.Button(653, 336, 81, 77, "+1", GUIStyleButton.SmallBlueBtn_1) then
		mCount = mCount + 1
	end
	if GUI.Button(733, 336, 113, 77, "+10", GUIStyleButton.SmallBlueBtn_1) then
		mCount = mCount + 10
	end
	
	if mCount < 1 then
		mCount = 1
	elseif mCount > mMaxCount then
		mCount = mMaxCount
		mSystemTip.ShowTip("最多只能购买"..mMaxCount.."个"..cfg_item.name)
	end
	GUI.Label(521, 235, 196, 30, "单价:"..cfg_item.price.."元宝", GUIStyleLabel.Left_35_Brown_Art)
	GUI.Label(521, 287, 196, 30, "总价:"..cost.."元宝", GUIStyleLabel.Left_35_Brown_Art)
	
	if GUI.Button(338, 416, 223, 78, "确定", GUIStyleButton.OrangeBtn) then
		mItemManager.RequestBuyItem(mItemId, mCount)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(589, 416, 223, 78, "取消", GUIStyleButton.OrangeBtn) then
		mPanelManager.Hide(OnGUI)
	end
		
	if GUI.Button(839, 105, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end
