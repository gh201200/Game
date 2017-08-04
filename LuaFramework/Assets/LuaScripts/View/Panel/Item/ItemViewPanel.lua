local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item = ConstValue,CFG_EquipSuit,CFG_item
local AssetType,CFG_UniqueSailor,ItemType,DrawItemCell = AssetType,CFG_UniqueSailor,ItemType,DrawItemCell
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mSailorViewPanel = nil
local mItemManager = require "LuaScript.Control.Data.ItemManager"
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mItemBagPanel = nil
-- local mShowItemLists = {}
module("LuaScript.View.Panel.Item.ItemViewPanel") -- 显示一般物品的详细信息
panelType = ConstValue.AlertPanel
local mItemId = nil
local mCouldUse = true

function SetData(id, couldUse)
	mItemId = id
	mCouldUse = couldUse
	local cfg_item = CFG_item[mItemId]
	if cfg_item.action == 0 then
		mCouldUse = false
	end
	local sailor = mSailorManager.GetSailorByIndex(cfg_item.sailorId)
	if cfg_item.type == 6 and mItemManager.GetItemCountById(id) < cfg_item.count and (cfg_item.sailorId == 0 or not sailor) then -- 碎片不够 使用按钮变灰
		mCouldUse = false
	end
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end

	local cfg_item = CFG_item[mItemId]
	if cfg_item.action == 9 then
		local cfg_sailor = CFG_UniqueSailor[cfg_item.sailorId]
		local sailor = {}
		sailor.index = cfg_item.sailorId
		sailor.star = 0
		sailor.exLevel = 0
		sailor.name = cfg_sailor.name
		sailor.quality = cfg_sailor.quality
		sailor.resId = cfg_sailor.resId
		sailor.notExit = true
		mSailorManager.UpdateProperty(sailor)
		mSailorViewPanel.SetData(sailor)
		mPanelManager.Show(mSailorViewPanel)
		mPanelManager.Hide(OnGUI)
		return
	end

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(258,184,640,320,image)
	
	DrawItemCell(cfg_item,ItemType.Item,372,304,100,100,nil,false,false) 
	local content = mItemManager.GetItemCountById(mItemId)
	
	local sailor = mSailorManager.GetSailorByIndex(cfg_item.sailorId)
	local hero = mHeroManager.GetHero()
	if mItemId == 1000 then -- 主角的碎片
		sailor = mSailorManager. GetSailorByDuty(1)
	end
	if not sailor  then
		if cfg_item.type == 6 then -- 碎片合成需要显示
			if content < cfg_item.count then
				GUI.Label(300, 416, 250, 30, "合成消耗：<color=red>" .. content .."</color>/"..cfg_item.count, GUIStyleLabel.Center_25_White, Color.Black)
			else
				GUI.Label(300, 416, 250, 30, "合成消耗：" .. content .."/"..cfg_item.count, GUIStyleLabel.Center_25_White, Color.Black)
			end
		end
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(554,246-10,274,186-70,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(302,234,246,59,image)
	GUI.Label(352, 245, 139, 30, cfg_item.name, GUIStyleLabel.Center_30_Brown_Art, Color.Black) -- 物品名字
	GUI.Label(560,246,266,186-40, cfg_item.desc, GUIStyleLabel.Left_20_Black_WordWrap) -- 物品信息
	
	if GUI.Button(827, 162, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
	
	local item = mItemManager.GetItemById(mItemId)
	local enabled = GUI.GetEnabled()
	if item == nil or item.count <= 0 or not mCouldUse then
		GUI.SetEnabled(false)
	end
		
	if GUI.Button(638, 370, 110, 60,"使用", GUIStyleButton.ShortOrangeArtBtn) then
		-- local sailor = mSailorManager.GetSailorByIndex(cfg_item.sailorId)
		if cfg_item.type == 6 and sailor then
			mSailorViewPanel.SetData(sailor, 3)
			mPanelManager.Show(mSailorViewPanel)
			mPanelManager.Hide(OnGUI)
		else
			mItemManager.UseItem(item)
			mPanelManager.Hide(OnGUI)
		end
	end
	
	GUI.SetEnabled(enabled)

end

function getUseBtnPos()
	local cfg_item = CFG_item[mItemId]
	if cfg_item.action == 9 then
		return 643, 375
	else
		return 564.5, 370
	end
end

