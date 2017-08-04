local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_lab = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_lab
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

module("LuaScript.View.Panel.Harbor.LabViewPanel") -- 研究所项目详细信息
panelType = ConstValue.AlertPanel
local mLabId = nil
local mLevel = nil

function SetData(labId, level)
	mLabId = labId
	mLevel = level
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
	
	local cfg_lab = CFG_lab[mLabId.."_"..mLevel]
	local cfg_lab_next = CFG_lab[mLabId.."_"..(mLevel+1)]
	
	-- local cfg_buildDesc = CFG_buildDesc[mLabId]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(283.35,155.4,626,332,image)
	
	local image = mAssetManager.GetAsset("Texture/Icon/lab/"..cfg_lab.icon, AssetType.Icon)
	GUI.DrawTexture(386.6,281,110,110,image)
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg5_1")
	-- GUI.DrawTexture(378.6,276.55,117,123,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(568,245.1,280,159,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(321,203.55,231,59,image)
	
	GUI.Label(318, 208.35, 238.95, 30, cfg_lab.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
	
	
	if cfg_lab then
		GUI.Label(598, 258, 84.2, 30, "本级效果", GUIStyleLabel.Left_25_Black)
		GUI.Label(588, 288.1, 84.2, 30, cfg_lab.property, GUIStyleLabel.Left_25_Black)
	end
	if cfg_lab_next then
		GUI.Label(598, 329.5, 84.2, 30, "下级效果", GUIStyleLabel.Left_25_Gray)
		GUI.Label(588, 362.5, 84.2, 30, cfg_lab_next.property, GUIStyleLabel.Left_25_Gray)
	end
	if GUI.Button(843.55, 136.1, 77, 63,nil, GUIStyleButton.CloseBtn) then
		-- mPanelManager.Show(mPerPanelFunc)
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end
