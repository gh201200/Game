local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,Vector2,CFG_product = ConstValue,CFG_EquipSuit,Vector2,CFG_product
local AssetType,CFG_item,EventType = AssetType,CFG_item,EventType
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
local mEventManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mFamilyManager = nil

module("LuaScript.View.Panel.Family.FamilyExchangePanel")--联盟交换物品
panelType = ConstValue.AlertPanel

local mGoodsId = 0
local mMaxCount = 0
local mCount = 0

function SetData(goodsId, maxCount)
	maxCount = math.max(maxCount, 1)
	mGoodsId = goodsId
	mMaxCount = maxCount
	mCount = maxCount
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.FamilyDel, FamilyDel)
	IsInit = true
end

function FamilyDel()
	mPanelManager.Hide(OnGUI)
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local intCount = 0
	if mGoodsId == 14 then
		intCount = math.floor(mCount/10000)*10000
	else
		intCount = math.floor(mCount)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(328.65,183.45,479.95,300.05,image)
	
	local cfg_item = CFG_item[mGoodsId]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	-- GUI.DrawTexture(378.75,260,100,100,image,0,0,1,1,6,6,6,6)
	DrawItemCell(cfg_item, ItemType.Item, 378.75,260,100,100,false)
	GUI.Label(377.15, 210.35, 109.2, 30, cfg_item.name, GUIStyleLabel.Center_30_Brown_Art, Color.Black)
	GUI.Label(420, 331, 54.2, 30,  mCommonlyFunc.GetShortNumber(intCount), GUIStyleLabel.Right_25_White, Color.Black)
	
	local cost = cfg_item.contribute*intCount
	local hero = mHeroManager.GetHero()
	if mGoodsId == 14 then
		GUI.Label(522.9, 252, 64.2, 30, "单价: 2贡献=1万银两", GUIStyleLabel.Left_20_Black)
	else
		GUI.Label(522.9, 252, 64.2, 30, "单价: "..cfg_item.contribute.."贡献", GUIStyleLabel.Left_20_Black)
	end
	GUI.Label(522.9, 285, 64.2, 30, "花费: "..cost.."贡献", GUIStyleLabel.Left_20_Black)
	GUI.Label(522.9, 320, 64.2, 30, "数量: ", GUIStyleLabel.Left_20_Black)
	
	mCount = GUI.HorizontalSlider(582.9, 320.5, 175, 27, mCount, 1, mMaxCount, GUIStyleButton.HorizontalScrollBg,GUIStyleButton.HorizontalThumb)
	
	if GUI.Button(402.95, 385, 111, 53, "确定", GUIStyleButton.ShortOrangeArtBtn) then
		if not mCommonlyFunc.HaveContribute(cost) then
			return
		end
		if intCount then
			mFamilyManager.RequestExchangeGoods(mGoodsId, intCount)
		end
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
