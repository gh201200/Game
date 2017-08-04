local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty,AssetType,CFG_ship,SceneType = 
ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty,AssetType,CFG_ship,SceneType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
-- local mShipTeam.sailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mShipSelectPanel = nil
local mSailorSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
-- local mShipTeamPanel = nil
local mCharManager = nil
local mPanelManager = nil
local mSystemTip = nil
local mMainPanel = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mShipTeamManager = require "LuaScript.Control.Data.ShipTeamManager"

module("LuaScript.View.Panel.ShipTeam.ShipTeamViewPanel")
panelType = ConstValue.AlertPanel
local mShipTeam = nil

function SetData(shipTeam)
	mShipTeam = shipTeam
	-- mShipId = shipId
end

function Hide()
	mSceneManager.SetMouseEvent(true)
end

function Display()
	mSceneManager.SetMouseEvent(false)
end

function Init()
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	-- mShipTeamPanel = require "LuaScript.View.Panel.ShipTeam.ShipTeamPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mShipSelectPanel = require "LuaScript.View.Panel.Harbor.ShipSelectPanel"
	mSailorSelectPanel = require "LuaScript.View.Panel.Sailor.SailorSelectPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(208,94,763,477,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(270,193,640.45,96,image,0,0,1,1,20,20,20,20)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(467.45,127,246,59,image)
	GUI.Label(549.8, 144, 70.2, 30, mShipTeam.sailor.name, GUIStyleLabel.MCenter_35_Redbean_Art)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..mShipTeam.sailor.quality)
	GUI.DrawTexture(320, 200, 80, 80, image)
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..mShipTeam.sailor.resId, AssetType.Pic)
	GUI.DrawTexture(325, 205,70,70,image)
	
	local color = ConstValue.QualityColorStr[mShipTeam.sailor.quality]
	local infoStr = mCommonlyFunc.BeginColor(color)
	infoStr = infoStr .. ConstValue.Quality[mShipTeam.sailor.quality]
	infoStr = infoStr .. mCommonlyFunc.EndColor()
	GUI.Label(446, 208, 239, 30, "品质：", GUIStyleLabel.Left_25_Black)
	GUI.Label(520, 199, 239, 30, infoStr, GUIStyleLabel.Left_30_White_Art, Color.Black)
	-- GUI.Label(446, 252, 239, 30, "技能：好技能技能", GUIStyleLabel.Left_25_Black)
	
	GUI.Label(700, 208, 239, 30, Language[36].. mShipTeam.sailor.business, GUIStyleLabel.Left_25_Black)
	GUI.Label(446, 252, 239, 30, Language[28].. mShipTeam.sailor.power, GUIStyleLabel.Left_25_Black)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(270,358,640.45,96,image,0,0,1,1,20,20,20,20)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(467.45,294,246,59,image)

	local cfg_ship = CFG_ship[mShipTeam.shipId]
	GUI.Label(443, 310, 268.2, 30, cfg_ship.name, GUIStyleLabel.MCenter_35_Redbean_Art)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
	GUI.DrawTexture(320,365,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..cfg_ship.resId, AssetType.Icon)
	GUI.DrawTexture(309, 355, 86, 86, image)
	
	GUI.Label(700, 371, 239, 30, Language[84]..cfg_ship.store, GUIStyleLabel.Left_25_Black)
	GUI.Label(446, 371, 239, 30, Language[87]..cfg_ship.speed, GUIStyleLabel.Left_25_Black)
	GUI.Label(446, 410, 239, 30, Language[28]..mCommonlyFunc.GetShipPower(cfg_ship.id), GUIStyleLabel.Left_25_Black)

	if GUI.Button(893.35, 89, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end

end