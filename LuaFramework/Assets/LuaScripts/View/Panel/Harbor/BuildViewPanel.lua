local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
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

module("LuaScript.View.Panel.Harbor.BuildViewPanel")
panelType = ConstValue.AlertPanel
local mBuildId = nil
local mLevel = nil

function SetData(buildId, level)
	mBuildId = buildId
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
	local cfg_buildDesc = CFG_buildDesc[mBuildId]
	
	if mBuildId == 1 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
		GUI.DrawTexture(288.05,64,626,486,image)
		
		local image = mAssetManager.GetAsset("Texture/Icon/Build/"..cfg_buildDesc.icon, AssetType.Icon)
		GUI.DrawTexture(386.6,171.55,110,110,image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg5_1")
		-- GUI.DrawTexture(378.6,167.55,117,123,image)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(568,123,277,159,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(345,321.45,502,153.6,image,0,0,1,1,20,20,20,20)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
		GUI.DrawTexture(325,106.5,230,59,image)
		
		GUI.Label(350, 286, 238.95, 30, "概况", GUIStyleLabel.Left_25_Black)
		GUI.Label(318, 111.35, 238.95, 30, cfg_buildDesc.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
		GUI.Label(578, 100, 265, 30, cfg_buildDesc.desc, GUIStyleLabel.Left_25_Black_WordWrap)
		
		local harborProperty = CFG_harborProperty[mLevel]
		local infostr = Language[33] .. harborProperty.attack
		GUI.Label(376, 332, 114.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local infostr = Language[34] .. harborProperty.defense
		GUI.Label(376, 365, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local infostr = Language[35] .. harborProperty.hp
		GUI.Label(376, 398, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local infostr = Language[28] .. mCommonlyFunc.GetHarborPower(mLevel)
		GUI.Label(376, 431.05, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		
		local infostr = Language[85] .. harborProperty.range
		GUI.Label(618, 332, 114.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local infostr = Language[86] ..  harborProperty.rate/1000 .. Language[72]
		GUI.Label(618, 365, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local infostr = Language[83] .. harborProperty.gunCount
		GUI.Label(618, 398, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		
		if GUI.Button(849.55, 52.9, 77, 63,nil, GUIStyleButton.CloseBtn) then
			-- mPanelManager.Show(mPerPanelFunc)
			mPanelManager.Hide(OnGUI)
			-- print("guanbi")
		end
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
		GUI.DrawTexture(283.35,155.4,626,332,image)
		
		local image = mAssetManager.GetAsset("Texture/Icon/Build/"..cfg_buildDesc.icon, AssetType.Icon)
		GUI.DrawTexture(386.6,245.95,110,110,image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg5_1")
		-- GUI.DrawTexture(378.6,241.75,117,123,image)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(568,197.2,275,159,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(345,395.65,500,50,image,0,0,1,1,20,20,20,20)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
		GUI.DrawTexture(325,180.7,231,59,image)
		
		GUI.Label(350, 358, 238.95, 30, "概况", GUIStyleLabel.Left_25_Black)
		GUI.Label(318, 184.55, 238.95, 30, cfg_buildDesc.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
		GUI.Label(578, 208-17, 250, 30, cfg_buildDesc.desc, GUIStyleLabel.Left_25_Black_WordWrap)
		
		if GUI.Button(843.55, 136.1, 77, 63,nil, GUIStyleButton.CloseBtn) then
			-- mPanelManager.Show(mPerPanelFunc)
			mPanelManager.Hide(OnGUI)
			-- print("guanbi")
		end
		
		if mBuildId == 2 then
			local infostr = Language[27] .. mLevel
			GUI.Label(376, 412, 114.2, 30, infostr, GUIStyleLabel.Left_20_Black)
			-- local infostr = "小时收入：999万"
			-- GUI.Label(618, 412, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		elseif mBuildId == 4 then
			local infostr = Language[27] .. mLevel
			GUI.Label(376, 412, 114.2, 30, infostr, GUIStyleLabel.Left_20_Black)
			local infostr = "每日收入：" .. (mLevel*mLevel*50 + 1000) * 24
			GUI.Label(618, 412, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		elseif mBuildId == 3 then
			local infostr = Language[27] .. mLevel
			GUI.Label(376, 412, 114.2, 30, infostr, GUIStyleLabel.Left_20_Black)
			local infostr = "科技等级上限: " .. mLevel
			GUI.Label(618, 412, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		elseif mBuildId == 5 then
			-- local infostr = Language[27] .. mLevel
			-- GUI.Label(376, 412, 114.2, 30, infostr, GUIStyleLabel.Left_20_Black)
			-- local infostr = "小时收入：999万"
			-- GUI.Label(618, 412, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		end
	end
end
