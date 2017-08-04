local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item = ConstValue,CFG_EquipSuit,CFG_item
local AssetType,CFG_UniqueSailor,CFG_star = AssetType,CFG_UniqueSailor,CFG_star
local AssetType,ItemType,DrawItemCell = AssetType,ItemType,DrawItemCell
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
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.StarFate.StarViewPanel")
panelType = ConstValue.AlertPanel
local mStar = nil

function SetData(star)
	mStar = star
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
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local cfg_item = CFG_star[mStar.bid]	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_4")
	GUI.DrawTexture(346,195,449,256,image,0,0,1,1,20,20,20,20)
	
	-- local image = mAssetManager.GetAsset("Texture/Icon/Star/"..cfg_item.resId, AssetType.Icon)
	-- GUI.DrawTexture(588,231,128,128,image)
	DrawItemCell(cfg_item, ItemType.Star, 588, 231, 100, 100)
	
	
	GUI.Label(380, 215, 139, 30, cfg_item.name, GUIStyleLabel.Left_25_LightBlue)
	GUI.Label(435, 220, 139, 30, mStar.level.."级", GUIStyleLabel.Left_20_White)
	
	GUI.Label(380, 260, 59.2, 30, Language[129], GUIStyleLabel.Left_20_White)
	local infostr = mCommonlyFunc.GetQualityStr(cfg_item.quality)
	GUI.Label(430, 250, 66.2, 30, infostr, GUIStyleLabel.Center_30_White_Art)
	
	
	
	local value = mCommonlyFunc.GetStarProperty(mStar)
	local property = CFG_property[cfg_item.propertyId]
	local infostr = property.type .. ": " .. value .. property.sign
	GUI.Label(380,295,270,186, infostr, GUIStyleLabel.Left_20_White)
	
	local power = mCommonlyFunc.GetStarPower(mStar)
	GUI.Label(380,330,270,186, "战斗力: "..power, GUIStyleLabel.Left_20_White)
	
	GUI.Label(380, 372, 401, 30, cfg_item.desc, GUIStyleLabel.Left_25_White_Art_WordWrap)
	
	if GUI.Button(0, 0, 1136, 640,nil, GUIStyleButton.Transparent) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end
