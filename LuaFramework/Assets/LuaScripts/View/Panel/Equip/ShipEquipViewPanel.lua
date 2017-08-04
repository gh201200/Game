local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit = ConstValue,CFG_EquipSuit
local AssetType,CFG_shipEquip = AssetType,CFG_shipEquip
local DrawItemCell,ItemType = DrawItemCell,ItemType
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
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mShipEquipSelectPanel = nil
local mShipEquipManager = nil
local mFleetPanel = nil
local mShipEquipUpPanel = nil

module("LuaScript.View.Panel.Equip.ShipEquipViewPanel")
panelType = ConstValue.AlertPanel
local mShip = nil
local mEquip = nil

function SetData(ship, equip)
	mShip = ship
	mEquip = equip
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mShipEquipUpPanel = require "LuaScript.View.Panel.Equip.ShipEquipUpPanel"
	mShipEquipSelectPanel = require "LuaScript.View.Panel.Equip.ShipEquipSelectPanel"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(298,114,560,427,image)
	
	local cfg_Equip = CFG_shipEquip[mEquip.id]
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	-- GUI.DrawTexture(366,202,128,128,image)
	-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_Equip.icon, AssetType.Icon)
	-- GUI.DrawTexture(371,207,100, 100, image)
	DrawItemCell(cfg_Equip, ItemType.ShipEquip, 366,202,100,100, true, false, false)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(516,166,276,153,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(334,157,179,43,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg7_1")
	GUI.DrawTexture(344,356,150,30,image)
	GUI.DrawTexture(344,389,150,30,image)
	GUI.DrawTexture(344,422,150,30,image)
	GUI.DrawTexture(344,455,150,30,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(516,360,276,57,image)
	GUI.Label(330, 152, 184, 30, cfg_Equip.name, GUIStyleLabel.Center_40_Brown_Art, Color.Black)
	
	
	GUI.Label(364, 325, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	-- local qualityColor = ConstValue.QualityColorStr[cfg_Equip.quality]
	local infostr = mCommonlyFunc.GetQualityStr(cfg_Equip.quality)
	-- infostr = infostr.. ConstValue.Quality[cfg_Equip.quality]
	-- infostr = infostr.. mCommonlyFunc.EndColor()
	GUI.Label(419, 315, 66.2, 30, infostr, GUIStyleLabel.Left_30_White_Art, Color.Black)
	
	local infostr = "类型: " .. cfg_Equip.typeName
	GUI.Label(363, 359, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	-- local property = mCommonlyFunc.GetEquipProperty(mEquip)
	local infostr = CFG_property[cfg_Equip.propertyId1].type .. ": " .. mCommonlyFunc.GetShipEquipProperty(mEquip)
	GUI.Label(363, 392, 114, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	local infostr = "强化: " .. (mEquip.star or 0)
	GUI.Label(363, 425, 114, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	local infostr = Language[28] .. mCommonlyFunc.GetShipEquipPower(mEquip)
	GUI.Label(363, 458, 134, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	local infostr = "描述:" .. cfg_Equip.desc
	GUI.Label(526, 182, 254, 30, infostr, GUIStyleLabel.Left_25_Black_WordWrap)
	
	GUI.Label(521, 332, 254, 30, "附加技能", GUIStyleLabel.Left_20_Black)
	GUI.Label(521, 365, 260, 46, "效果:"..cfg_Equip.skillDesc, GUIStyleLabel.MLeft_20_Black_WordWrap)
	

	if mShip and GUI.Button(566+90, 422, 166, 77, Language[42], GUIStyleButton.BlueBtn) then
		local shipIndex = mShip.index
		local select = mFleetPanel.GetSelect()
		function SelectFunc(equip)
			if equip then
				mShipEquipManager.RequestWearEquip(equip.index, shipIndex)
			end
			mFleetPanel.SetSelect(select)
			mPanelManager.Show(mFleetPanel)
		end
		
		mShipEquipSelectPanel.SetData(mShip, cfg_Equip.type, SelectFunc)
		mPanelManager.Show(mShipEquipSelectPanel)
		mPanelManager.Hide(OnGUI)
		mPanelManager.Hide(mFleetPanel)
	end
	
	local oldEnabled = GUI.GetEnabled()
	if not mEquip.star then
		GUI.SetEnabled(false)
	end
	
	if not mShip then
		if not mEquip.protect then
			if GUI.Button(566+90, 422, 166, 77, "锁定", GUIStyleButton.BlueBtn) then
				mShipEquipManager.RequestProtect(mEquip.index, 1)
			end
		else
			if GUI.Button(566+90, 422, 166, 77, "解锁", GUIStyleButton.BlueBtn) then
				mShipEquipManager.RequestProtect(mEquip.index, 0)
			end
		end
	end
	
	if GUI.Button(566-70, 422, 166, 77, "改造", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
		
		mShipEquipUpPanel.SetData(mEquip)
		mPanelManager.Show(mShipEquipUpPanel)
	end
	
	if not mEquip.star then
		GUI.SetEnabled(oldEnabled)
	end
	
	if GUI.Button(781, 96, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end
