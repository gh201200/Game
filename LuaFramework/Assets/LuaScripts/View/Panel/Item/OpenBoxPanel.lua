local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,Vector2,CFG_product,platform,IPhonePlayer = ConstValue,CFG_EquipSuit,Vector2,CFG_product,platform,IPhonePlayer
local AssetType,CFG_item,IosTestScript = AssetType,CFG_item,IosTestScript
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mGoodsManager = nil
local mPanelManager = nil
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mItemManager = require "LuaScript.Control.Data.ItemManager"
local mAlert = require "LuaScript.View.Alert.Alert"

module("LuaScript.View.Panel.Item.OpenBoxPanel") -- 一次使用多个物品的面板
panelType = ConstValue.AlertPanel

local mBoxId = 0
local mKeyId = 0
local mMaxCount = 0
local mCount = 0
local mItemIndex = 0
local mBoxCount = 0
local mKeyCount = 0

function SetData(itemIndex, boxId, keyId)
	mItemIndex = itemIndex
	mBoxId = boxId
	mKeyId = keyId
	mBoxCount = mItemManager.GetItemCountById(boxId)
	mKeyCount = mItemManager.GetItemCountById(keyId)
	mMaxCount = math.min(100, math.max(mBoxCount, mKeyCount))
	
	--ios test script
	if IosTestScript then
		mMaxCount = math.min(100, math.min(mBoxCount, mKeyCount))
	end
	
	mCount = mMaxCount
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(328.65,183.45,479.95,300.05,image)
	
	local cfg_item = CFG_item[mBoxId]
	-- print(mProductId, product)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/productSlot")
	-- GUI.DrawTexture(373.7+20,255,110,110,image)
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	-- GUI.DrawTexture(378.75,260,100,100,image)
	DrawItemCell(cfg_item, ItemType.Item, 378.75+20,260,100,100)
	-- GUI.Label(380.4, 297, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	
	GUI.Label(377.15+20, 210.35, 109.2, 30, cfg_item.name, GUIStyleLabel.Center_35_Brown_Art, Color.Black)
	GUI.Label(435, 331, 54.2, 30, math.floor(mCount), GUIStyleLabel.Right_25_White, Color.Black)
	
	local cfg_box = CFG_item[mBoxId]
	local hero = mHeroManager.GetHero()
	GUI.Label(522.9, 285, 64.2, 30, cfg_box.name.."："..mBoxCount, GUIStyleLabel.Left_20_Black)
	
	local cfg_key = CFG_item[mKeyId]
	if cfg_key then
		GUI.Label(522.9, 252, 64.2, 30, cfg_key.name.."："..mKeyCount, GUIStyleLabel.Left_20_Black)
	end
	
	GUI.Label(522.9, 320, 64.2, 30, "数量：", GUIStyleLabel.Left_20_Black)
	
	mCount = GUI.HorizontalSlider(582.9, 320.5, 175, 27, mCount, 1, mMaxCount, GUIStyleButton.HorizontalScrollBg,GUIStyleButton.HorizontalThumb)

	if GUI.Button(402.95, 385, 111, 53, "确定", GUIStyleButton.ShortOrangeArtBtn) then
		local missPrice = 0
		function OkFunc()
			if not mCommonlyFunc.HaveGold(missPrice) then
				return
			end
			mItemManager.RequestOpenBox(mItemIndex, mCount)
			mPanelManager.Hide(OnGUI)
		end
		
		-- local boxCount = mItemManager.GetItemCountById(mBoxId)
		mCount = math.floor(mCount)
		if mBoxCount <  mCount then
			local missCount = mCount - mBoxCount
			missPrice = cfg_box.price * missCount
			mAlert.Show(cfg_box.name.."不足，是否花费"..missPrice.."元宝购买"..missCount.."个?", OkFunc)
			return
		end
		-- local keyCount = mItemManager.GetItemCountById(mKeyId)
		if cfg_key and mKeyCount <  mCount then
			local missCount = mCount - mKeyCount
			missPrice = cfg_key.price * missCount
			mAlert.Show(cfg_key.name.."不足，是否花费"..missPrice.."元宝购买"..missCount.."个?", OkFunc)
			return
		end
		
		OkFunc()
	end
	if GUI.Button(614.5, 385, 111, 53, "取消", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
	end
		
	if GUI.Button(736, 168.5, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end
