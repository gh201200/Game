local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,DrawItemCell,CFG_item,ItemType = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,DrawItemCell,CFG_item,ItemType
local mPanelManager = nil
local mCommonlyFunc = nil
local mGUIStyleManager = nil
local mAssetManager = nil
local mMainPanel = nil
local mLoadPanel = nil
local mHeroManager = nil
local mAlert = nil
local mActionManager = nil
local mPowerUpPanel = nil
local mPowerUpTip = nil
local mItemManager = nil
local mItemViewPanel = nil
local mOpenBoxPanel = nil
local mGuidePanel = nil

module("LuaScript.View.Panel.Main.ItemUse")
local mList = {}
local mItemId = 0

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mActionManager = require "LuaScript.Control.ActionManager"
	mPowerUpPanel = require "LuaScript.View.Panel.PowerUp.PowerUpPanel"
	mPowerUpTip = require "LuaScript.View.Panel.PowerUp.PowerUpTip"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mOpenBoxPanel = require "LuaScript.View.Panel.Item.OpenBoxPanel"
	mGuidePanel = require "LuaScript.View.Panel.Task.GuidePanel"
end

function ShowTip(itemId)
	if visible then
		table.insert(mList, itemId)
	else
		visible = true
		mItemId = itemId
	end
end

function OnGUI()
	if not visible then
		return
	end
	-- if mGuidePanel.visible then
		-- mList = {}
		-- mItemId = 0
		-- visible = false
		-- return
	-- end
	if mPowerUpTip.visible then
		return
	end
	if mItemViewPanel.visible then
		return
	end
	if mOpenBoxPanel.visible then
		return
	end
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_Bg31_1)
	GUI.DrawTexture(582,358,360,150,image)
	GUI.Label(755,387,0,50,"快速使用？",GUIStyleLabel.Left_30_Redbean_Art)
	
	-- local cfg_item = CFG_item[mItemId]
	local item = mItemManager.GetItemById(mItemId)
	if item == nil or item.count == 0 then
		ShowNextItem()
		return
	end
	
	if DrawItemCell(item, ItemType.Item, 633, 376) then
		mItemViewPanel.SetData(item.id)
		-- mPanelManager.Show(mItemViewPanel)
		-- ShowNextItem()
	end
	
	if GUI.Button(759, 430, 111, 53, "确定", GUIStyleButton.ShortOrangeBtn) then
		mItemManager.UseItem(item)
		ShowNextItem()
	end
	
	if GUI.Button(943-65, 302+40, 77, 63, nil, GUIStyleButton.CloseBtn) then
		ShowNextItem()
	end
end

function ShowNextItem()
	if mList[1] then
		mItemId = table.remove(mList, 1)
	else
		visible = false
	end
end
