local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_ship = ConstValue,CFG_EquipSuit,CFG_ship
local AssetType = AssetType
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
local mPanelManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.Harbor.ShipViewPanel") -- 一艘船的信息信息显示

panelType = ConstValue.AlertPanel
local mShip = nil
local mShipId = nil

function SetData(ship, shipId)
	mShip = ship
	mShipId = shipId
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(288.05,64,626,486,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
	GUI.DrawTexture(378.6,163.55,116,116,image)
	
	local cfg_ship = CFG_ship[mShipId]
	local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..cfg_ship.resId, AssetType.Icon)
	GUI.DrawTexture(363,148,125,125,image)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(568,123,280,159,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(358.25,326.2,491.45,165,image,0,0,1,1,20,20,20,20)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(295+28,106.5,231,59,image)
	
	GUI.Label(318, 121.35, 238.95, 30, cfg_ship.name, GUIStyleLabel.Center_30_Brown_Art, Color.Black)
	
	local infostr = Language[33]
	if mShip then
		infostr = infostr .. mShip.attack
	else
		infostr = infostr .. cfg_ship.attack
	end
	GUI.Label(389.55, 339.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[34]
	if mShip then
		infostr = infostr .. mShip.defense
	else
		infostr = infostr .. cfg_ship.defense
	end
	GUI.Label(389.55, 379.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[35] .. cfg_ship.hp
	GUI.Label(389.55, 419.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[83] .. cfg_ship.gunCount
	GUI.Label(577.55, 339.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[85]
	if mShip then
		infostr = infostr .. mShip.range
	else
		infostr = infostr .. cfg_ship.range
	end
	GUI.Label(577.55, 379.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[86] .. cfg_ship.rate/1000 .. Language[72]
	GUI.Label(577.55, 419.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[84] 
	if mShip then
		infostr = infostr .. mShip.store
	else
		infostr = infostr .. cfg_ship.store
	end
	GUI.Label(737.55, 339.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[87]
	if mShip then
		infostr = infostr .. mShip.speed
	else
		infostr = infostr .. cfg_ship.speed
	end
	GUI.Label(737.55, 379.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[78]
	if mShip then
		infostr = infostr .. mShip.life
	else
		infostr = infostr .. cfg_ship.durable
	end
	GUI.Label(737.55, 419.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[28] .. mCommonlyFunc.GetShipPower(cfg_ship.id,mShip)
	GUI.Label(389.55, 461.2, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)

	GUI.Label(580, 145, 250, 30, cfg_ship.desc, GUIStyleLabel.Left_25_Black_WordWrap)
	
	if GUI.Button(849.55, 52.9, 77, 63,nil, GUIStyleButton.CloseBtn) then
		-- mPanelManager.Show(mPerPanelFunc)
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end
