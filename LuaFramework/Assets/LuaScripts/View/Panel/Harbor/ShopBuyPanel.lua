local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,Vector2,CFG_product = ConstValue,CFG_EquipSuit,Vector2,CFG_product
local AssetType,CFG_productType = AssetType,CFG_productType
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

module("LuaScript.View.Panel.Harbor.ShopBuyPanel") -- 交易所界面
panelType = ConstValue.AlertPanel

local mProductId = 0
local mMaxCount = 0
local mCount = 0

function SetData(productId, maxCount)
	-- print(mProductId, mMaxCount)
	mProductId = productId
	mMaxCount = maxCount
	mCount = maxCount
	-- print(mMaxCount, mCount)
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
	
	local product = CFG_product[mProductId]
	-- print(mProductId, product)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/productSlot")
	GUI.DrawTexture(373.7,255,110,110,image)
	local image = mAssetManager.GetAsset("Texture/Icon/Product/"..product.icon, AssetType.Icon)
	GUI.DrawTexture(378.75,260,100,100,image)
	-- GUI.Label(380.4, 297, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	
	GUI.Label(377.15, 210.35, 109.2, 30, product.name, GUIStyleLabel.Center_35_Brown_Art, Color.Black)
	GUI.Label(420, 331, 54.2, 30, math.floor(mCount), GUIStyleLabel.Right_25_White, Color.Black)
	
	local cost = product.price*math.floor(mCount)
	local hero = mHeroManager.GetHero()
	GUI.Label(522.9, 220+35, 64.2, 30, "类别："..CFG_productType[product.type].type, GUIStyleLabel.Left_20_Black)
	GUI.Label(522.9, 252+30, 64.2, 30, "银两："..hero.money, GUIStyleLabel.Left_20_Black)
	GUI.Label(522.9, 285+24, 64.2, 30, "总价："..cost, GUIStyleLabel.Left_20_Black)
	GUI.Label(522.9, 320+18, 64.2, 30, "数量：", GUIStyleLabel.Left_20_Black)
	
	mCount = GUI.HorizontalSlider(582.9, 320.5+15, 175, 27, mCount, 0, mMaxCount, GUIStyleButton.HorizontalScrollBg,GUIStyleButton.HorizontalThumb)

	if GUI.Button(402.95, 385, 111, 53, "确定", GUIStyleButton.ShortOrangeArtBtn) then
		if not mCommonlyFunc.HaveMoney(cost) then
			return
		end
		mGoodsManager.RequestBuyGoods(mProductId, math.floor(mCount))
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(614.5, 385, 111, 53, "取消", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("cancel")
	end
		
	if GUI.Button(736, 168.5, 77, 63,nil, GUIStyleButton.CloseBtn) then
		-- mPanelManager.Show(mPerPanelFunc)
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end
