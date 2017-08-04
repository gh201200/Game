local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local CFG_item,CFG_shipEquip,DrawItemCell = CFG_item,CFG_shipEquip,DrawItemCell
local AssetType,ItemType = AssetType,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipViewPanel = nil
local mEquipSelectPanel = nil
local mAwardViewPanel = nil
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mEquipManager = nil
local mCommonlyFunc = nil
local mSailorManager = nil
local mItemManager = nil
local mItemViewPanel = nil
local mShipEquipManager = nil
local mShipEquipViewPanel = nil

module("LuaScript.View.Panel.Item.ItemBagPanel") -- 背包面板
FullWindowPanel = true
local mScrollPositionY = 0
local mPage = 1
local mDefaultPage = 1
local mItemType = 0
local mShowItemList = nil
local mShowEquipList = nil
--页面显示内容类型标记
local mPageToType = {0,6,7,3,4,5,2}

function Init()
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mAwardViewPanel = require "LuaScript.View.Panel.BossList.AwardViewPanel"
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	
	IsInit = true
end

function Display()
	mPage = mDefaultPage
	mDefaultPage = 1
	mItemType = mPageToType[mPage]
	mScrollPositionY = 0
	mItemManager.ResetCostTip()
	RefreshItem()
end

function SetPage(page) -- 更改默认打开背包的设置，暂时不使用
	mDefaultPage = page
end

function RefreshItem() --刷新物品列表
	if mItemType ~= 6 and mItemType ~= 7  then
		mShowItemList = mItemManager.GetItemsByType(mItemType) -- 刷新对应类型列表
	else
		mShowItemList = {} --一般物品列表清空
	end
	if mItemType == 0 or mItemType == 6 then--装备
		mShowEquipList = mEquipManager.GetEquips()
	else
		mShowEquipList = {}--人物装备列表清空
	end
	if mItemType == 0 or mItemType == 7 then--船装
		mShowShipEquipList = mShipEquipManager.GetEquips()
	else
		mShowShipEquipList = {}--船装列表清空
	end
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	-- GUI.DrawTexture(923,37.5,128,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	-- GUI.Label(525.5,48,84.2,30,"物品", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	--选中的页面标签会变亮
	-- [98] = "全部",
	if mPage == 1 then
		GUI.Button(87.5,38.3,134,58, Language[98], GUIStyleButton.PagBtn_2)--全部
	elseif GUI.Button(87.5,38.3,134,58, Language[98], GUIStyleButton.PagBtn_1) then
		mPage = 1
		mScrollPositionY = 0
		mItemType = mPageToType[mPage]
		RefreshItem()
	end
	
	-- [92] = "装备",
	if mPage == 2  then
		GUI.Button(226.55,38.3,134,58, "装备", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(226.55,38.3,134,58, "装备", GUIStyleButton.PagBtn_1) then
		mPage = 2
		mScrollPositionY = 0
		mItemType = mPageToType[mPage]
		RefreshItem()
	end
	
	-- [93] = "宝箱",
	if mPage == 3  then
		GUI.Button(365.7,38.3,134,58, "船装", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(365.7,38.3,134,58, "船装", GUIStyleButton.PagBtn_1) then
		mPage = 3
		mScrollPositionY = 0
		mItemType = mPageToType[mPage]
		RefreshItem()
	end
	
	-- [94] = "道具",
	if mPage == 4  then
		GUI.Button(504.5,38.3,134,58, "道具", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(504.5,38.3,134,58, "道具", GUIStyleButton.PagBtn_1) then
		mPage = 4
		mScrollPositionY = 0
		mItemType = mPageToType[mPage]
		RefreshItem()
	end
	
	-- [95] = "卡片",
	if mPage == 5  then
		GUI.Button(644,38.3,134,58, "卡片", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(644,38.3,134,58, "卡片", GUIStyleButton.PagBtn_1) then
		mPage = 5
		mScrollPositionY = 0
		mItemType = mPageToType[mPage]
		RefreshItem()
	end
	
	-- [96] = "宝图",
	if mPage == 6  then
		GUI.Button(783.15,38.3,134,58, "宝图", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(783.15,38.3,134,58, "宝图", GUIStyleButton.PagBtn_1) then
		mPage = 6
		mScrollPositionY = 0
		mItemType = mPageToType[mPage]
		RefreshItem()
	end
	
	
	-- [93] = "宝箱",
	if mPage == 7  then
		GUI.Button(923,37.5,128,58, "宝箱", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(923,37.5,128,58, "宝箱", GUIStyleButton.PagBtn_1) then
		mPage = 7
		mScrollPositionY = 0
		mItemType = mPageToType[mPage]
		RefreshItem()
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(153,132,839,472,image,0,0,1,1,20,20,20,20)
	
	local spacing = 120 -- 上下拉动距离限制
	local itemCount = #mShowItemList
	local equipCount = #mShowEquipList
	local shipEquipCount = #mShowShipEquipList
	local count = itemCount+equipCount+shipEquipCount
	--滑动窗
	_,mScrollPositionY = GUI.BeginScrollView(119, 136.4, 900, 460.5, 0,mScrollPositionY, 0, 0, 850, spacing * math.ceil(count/7))
		for k,item in pairs(mShowItemList) do
			local x = ((k-1) % 7) * spacing + 40
			local y = math.floor((k-1) / 7) * spacing + 18
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*4 and DrawItemCell(item, ItemType.Item, x, y)then
				mItemViewPanel.SetData(item.id, true) -- true代表能否使用
				mAwardViewPanel.SetmCouldUse(true)
				-- mPanelManager.Show(mItemViewPanel)
			end
		end
		
		for k,item in pairs(mShowEquipList) do
			local x = ((k+itemCount-1) % 7) * spacing + 40
			local y = math.floor((k+itemCount-1) / 7) * spacing + 18
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*4 and DrawItemCell(item, ItemType.Equip, x, y) then
				-- mEquipViewPanel.SetData(nil, item)
				-- mPanelManager.Show(mEquipViewPanel)
			end
		end
		
		
		for k,item in pairs(mShowShipEquipList) do
			local x = ((k+itemCount+equipCount-1) % 7) * spacing + 40
			local y = math.floor((k+itemCount+equipCount-1) / 7) * spacing + 18
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*4 and DrawItemCell(item, ItemType.ShipEquip, x, y) then
				-- mShipEquipViewPanel.SetData(nil, item)
				-- mPanelManager.Show(mShipEquipViewPanel)
			end
		end
		
		for i=count+1, math.max(math.ceil(count/7), 4)*7,1 do
			local x = ((i-1) % 7) * spacing + 40
			local y = math.floor((i-1) / 7) * spacing + 18
			DrawItemCell(nil, nil, x, y) -- 空格子
		end
		
	GUI.EndScrollView()
	
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		mScrollPositionY = 0
	end
end
