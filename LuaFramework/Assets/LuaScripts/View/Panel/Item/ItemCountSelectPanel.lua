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
local mHeroManager = nil
local mCharManager = nil
local mGoodsManager = nil
local mPanelManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.Item.ItemCountSelectPanel")
panelType = ConstValue.AlertPanel

local mItem = 0
local mMaxCount = 0
local mCount = 0
local mSelectFunc = nil
local mShareCount = nil

function SetData(item, selectFunc, shareCount)
	mSelectFunc = selectFunc
	mItem = item
	mMaxCount = item.count
	mCount = mMaxCount
	mShareCount = shareCount
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
	
	local cfg_item = CFG_item[mItem.id]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	-- GUI.DrawTexture(373.7,255,110,110,image,0,0,1,1,6,6,6,6)
	DrawItemCell(cfg_item, ItemType.Item, 373.7,255,110,110, false)
	
	GUI.Label(377+190, 235, 109.2, 30, cfg_item.name, GUIStyleLabel.Center_35_Brown_Art, Color.Black)
	if mShareCount then
		GUI.Label(435, 331, 54.2, 30, math.floor(mCount/mShareCount)*mShareCount, GUIStyleLabel.Right_25_White, Color.Black)
	else
		GUI.Label(435, 331, 54.2, 30, math.floor(mCount), GUIStyleLabel.Right_25_White, Color.Black)
	end
	
	
	local hero = mHeroManager.GetHero()
	GUI.Label(522.9, 285, 64.2, 30, "总量："..mMaxCount, GUIStyleLabel.Left_20_Black)
	GUI.Label(522.9, 320, 64.2, 30, "数量：", GUIStyleLabel.Left_20_Black)
	
	mCount = GUI.HorizontalSlider(582.9, 320.5, 175, 27, mCount, 1, mMaxCount, GUIStyleButton.HorizontalScrollBg,GUIStyleButton.HorizontalThumb)
	
	if GUI.Button(402.95, 385, 111, 53, "确定", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
		if mShareCount then
			mSelectFunc(mItem, math.floor(mCount/mShareCount)*mShareCount)
		else
			mSelectFunc(mItem, math.floor(mCount))
		end
	end
	if GUI.Button(614.5, 385, 111, 53, "取消", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
		mSelectFunc()
	end
		
	if GUI.Button(736, 168.5, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		mSelectFunc()
	end
end
