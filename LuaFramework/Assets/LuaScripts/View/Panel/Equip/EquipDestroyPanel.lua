local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,EventType = ConstValue,CFG_EquipSuit,CFG_item,EventType
local AssetType,CFG_EquipDestroy,CFG_magic = AssetType,CFG_EquipDestroy,CFG_magic
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mHeroManager = nil
local mCharManager = nil
local mEventManager = nil
local mPanelManager = nil
local mAlert = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mItemViewPanel = nil

module("LuaScript.View.Panel.Equip.EquipDestroyPanel")
panelType = ConstValue.AlertPanel
local mEquip = nil
-- local mGem = nil
-- local mMaxCount = 99
-- local mMinCount = 99

function SetData(equip)
	local cfg_Equip = CFG_Equip[equip.id]
	mEquip = equip
	
	-- local destroyGetFunc = ConstValue.EquipDestroyGet[cfg_Equip.quality]
	-- mGem = ConstValue.EquipDestroyGem[cfg_Equip.quality]
	-- mMinCount = destroyGetFunc(equip)
	-- mMaxCount = mMinCount * 2
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mEventManager = require "LuaScript.Control.EventManager"
	
	
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(238,81,671,478,image)
	
	local cfg_Equip = CFG_Equip[mEquip.id]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	GUI.DrawTexture(342,191,128,128, image)
	local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
	GUI.DrawTexture(347,196,100, 100, image)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(530,142,295,160,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(276,128,246,59,image)
	local cfg_Equip = CFG_Equip[mEquip.id]
	GUI.Label(326, 131, 139, 30, cfg_Equip.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
	
	GUI.Label(560, 157, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	local infostr = mCommonlyFunc.GetQualityStr(cfg_Equip.quality)
	GUI.Label(620.4, 147, 60.2, 30, infostr, GUIStyleLabel.Center_30_White_Art, Color.Black)
	
	
	if mEquip.magic and mEquip.magic ~= 0 then
		local property = mCommonlyFunc.GetEquipProperty(mEquip)
		local infostr = CFG_property[cfg_Equip.propertyId].type .. ": " .. property .."(强" .. mEquip.star .. ")"
		GUI.Label(560, 194, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local cfg_magic = CFG_magic[mEquip.magic]
		GUI.Label(560, 229, 104.2, 30, cfg_magic.name, GUIStyleLabel.Left_20_Black)
	else
		local property = mCommonlyFunc.GetEquipProperty(mEquip)
		local infostr = CFG_property[cfg_Equip.propertyId].type .. ": " .. property
		GUI.Label(560, 194, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local infostr = Language[45] .. mEquip.star
		GUI.Label(560, 229, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	end
	
	
	local infostr = Language[28] .. mCommonlyFunc.GetEquipPower(mEquip)
	GUI.Label(560, 265.55, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	GUI.Label(341.4, 305, 104.2, 30, "分解收益:", GUIStyleLabel.Left_30_Brown_Art)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(340,335,491,111,image,0,0,1,1,20,20,20,20)
	
	-- local key = cfg_Equip.quality.."_"..mEquip.star
	local cfg_EquipDestroy = CFG_EquipDestroy[mEquip.star]
	
	local cfg_item = CFG_item[cfg_EquipDestroy.itemId]
	local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, 370,343,80,80) then
		-- mItemViewPanel.SetData(cfg_item.id)
		-- mPanelManager.Show(mItemViewPanel)
	end
	GUI.Label(366.5, 424, 84, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
	
	local infostr = "最少: " .. cfg_EquipDestroy.min .. "颗"
	GUI.Label(560, 364, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = "最多: " .. cfg_EquipDestroy.max .. "颗"
	GUI.Label(560, 402, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	

	if GUI.Button(650, 444, 111, 60, nil, GUIStyleButton.CancelBtn) then
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(390, 444, 111, 60,nil, GUIStyleButton.DestroyBtn) then
		function okFunc()
			mEquipManager.RequestDestroyEquip(mEquip.index)
			mPanelManager.Hide(OnGUI)
		end
	
		if mEquip.sid ~= 0 then
			local sailor = mSailorManager.GetSailorById(mEquip.sid)
			mAlert.Show("\""..sailor.name.."\"正在穿戴该装备,确定分解该装备?", okFunc)
			return
		end
		okFunc()
	end
	
	if GUI.Button(849.55, 52.9, 77, 63,nil, GUIStyleButton.CloseBtn) then
		-- mPanelManager.Show(mPerPanelFunc)
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end