local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,PackatHead,Packat_Account,ByteArray,table,ConstValue = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,PackatHead,Packat_Account,ByteArray,table,ConstValue
local GUIStyleLabel,Packat_Sailor,CFG_buildDesc,GUIStyleButton,AppearEvent,EventType,os = 
GUIStyleLabel,Packat_Sailor,CFG_buildDesc,GUIStyleButton,AppearEvent,EventType,os
local AssetType,CFG_randomTask,CFG_item,ConstValue,CFG_Equip,CFG_harborItemCount,CFG_harbor = 
AssetType,CFG_randomTask,CFG_item,ConstValue,CFG_Equip,CFG_harborItemCount,CFG_harbor
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mItemViewPanel = nil

module("LuaScript.View.Panel.Harbor.IncomePanel") -- 主城收益，未被调用
panelType = ConstValue.AlertPanel
local mHarborId = nil
local mHarborLevel = nil
local mShopLevel = nil

function Init()
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	IsInit = true
end

function OnShow(harborId, harborLevel, shopLevel)
	mHarborId = harborId
	mHarborLevel = harborLevel
	mShopLevel = shopLevel
	
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	-- if not IsInit then
		-- return
	-- end
	-- local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(150,56,848,524,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg33_1")
	GUI.DrawTexture(228,161,674,282,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/income")
	GUI.DrawTexture(258,106,192,46,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_2")
	GUI.DrawTexture(240+16,150-11,674,32,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_1")
	GUI.DrawTexture(240+16,469-14,674,32,image)
	
	
	if GUI.Button(916, 46, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(328, 438, 223, 78, "确定", GUIStyleButton.OrangeBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(606, 438, 223, 78, "取消", GUIStyleButton.OrangeBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	local cfg_harbor = CFG_harbor[mHarborId]
	local cfg_award = CFG_harborItemCount[cfg_harbor.type .. "_" .. mHarborLevel]
	-- print(cfg_harbor.type .. mHarborLevel, cfg_award)
	local money = (mShopLevel*mShopLevel*500 + 10000) * 24
	
	DrawAward(14, money, 358, 180)
	DrawAward(14, money*8, 358, 313)
	if cfg_award then
		DrawAward(cfg_award.itemId, cfg_award.count, 626, 180)
		DrawAward(cfg_award.itemId, cfg_award.count*8, 626, 313)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	-- GUI.DrawTexture(23.75,37.5,53,58,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	-- GUI.DrawTexture(519.2-134,36.8,526.8+134,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
end

function DrawAward(id, count, x, y)
	-- if not award then
		-- return 
	-- end
	local image = mAssetManager.GetAsset("Texture/GUI/Bg/bg4_1")
	GUI.DrawTexture(x+15,y+6,240,88,image)
	
	local cfg_item = CFG_item[id]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, x, y,100,100) then
		-- mItemViewPanel.SetData(cfg_item.id)
		-- mPanelManager.Show(mItemViewPanel)
	end

	GUI.Label(100+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(count), GUIStyleLabel.Center_25_DeepBlue_Art)
	GUI.Label(100+x, 14+y, 154, 30, cfg_item.name, GUIStyleLabel.Center_30_Brown_Art)
end