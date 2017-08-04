local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local CFG_item = CFG_item
local AssetType = AssetType
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipViewPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mCommonlyFunc = nil
local mSailorManager = nil
local mItemManager = nil
local mItemViewPanel = nil

module("LuaScript.View.Panel.Item.ItemSelectPanel")

local mScrollPositionY = 0

local mItemList = nil
local mSelectFunc = nil
function SetData(itemList, selectFunc)
	mItemList = itemList or mItemManager.GetItems()
	mSelectFunc = selectFunc
end


-- local mItemList = {{id=1,count=999},{id=2,count=55},{id=3,count=1}}

function Init()
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	
	mShowEquipList = mEquipManager.GetEquips()
	mPage = 1
	IsInit = true
end

function Display()
	mScrollPositionY = 0
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"物品", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	local spacing = 156
	-- local mItemList = mItemManager.GetItems()
	local count = #mItemList
	_,mScrollPositionY = GUI.BeginScrollView(154, 136.4, 900, 460.5, 0,mScrollPositionY, 0, 0, 850, spacing * count)
		for k,item in pairs(mItemList) do
			local y = (k-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 then
				DrawItem(item, y)
			end
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		if count < 1 then
			GUI.DrawTexture(0,spacing*0,800,144,image)
		end
		if count < 2 then
			GUI.DrawTexture(0,spacing*1,800,144,image)
		end
		if count < 3 then
			GUI.DrawTexture(0,spacing*2,800,144,image)
		end
	GUI.EndScrollView()
	
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mSelectFunc()
		mPanelManager.Hide(OnGUI)
		mScrollPositionY = 0
	end
end

function DrawItem(item, y)
	local cfg_item = CFG_item[item.id]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,825,144,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, 40, y+18, 100, 100) then
		-- mItemViewPanel.SetData(item.id)
		-- mPanelManager.Show(mItemViewPanel)
	end
	
	GUI.Label(195, y+12, 74.2, 30, cfg_item.name, GUIStyleLabel.Left_35_Redbean_Art)
	GUI.Label(190, y+60, 431.35, 100, cfg_item.desc, GUIStyleLabel.Left_25_Black_WordWrap)
	
	local infostr = "数量: " .. item.count
	GUI.Label(648, y+26.6, 104.2, 30, infostr, GUIStyleLabel.Center_25_Black)
	
	if GUI.Button(645, y+67.05, 111, 60,nil, GUIStyleButton.SelectBtn) then
		-- print("shiyong")
		-- mItemManager.UseItem(item)
		mPanelManager.Hide(OnGUI)
		mSelectFunc(item)
	end
end