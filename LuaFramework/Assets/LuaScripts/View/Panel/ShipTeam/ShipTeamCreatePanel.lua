local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty,AssetType,CFG_ship,SceneType = 
ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty,AssetType,CFG_ship,SceneType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
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
local mHeroPanel = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mShipTeamManager = require "LuaScript.Control.Data.ShipTeamManager"

module("LuaScript.View.Panel.ShipTeam.ShipTeamCreatePanel")
panelType = ConstValue.AlertPanel
local mSelectSailor = nil
local mSelectShip = nil

function GetSelectSailor()
	return mSelectSailor
end

function GetSelectShip()
	return mSelectShip
end

function RefreshData()
	mSelectSailor = nil
	mSelectShip = nil
end

function Display()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mSceneManager.SetMouseEvent(true)
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
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
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
	GUI.Label(522, 155, 239, 30, "收益与<color=#00ffff>贸易</color>值有关", GUIStyleLabel.Left_25_White_Art, Color.Black)
	GUI.Label(522, 323, 239, 30, "收益与<color=#00ffff>仓库、航速</color>有关", GUIStyleLabel.Left_25_White_Art, Color.Black)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(267.45,127,246,59,image)
	if mSelectSailor then
		GUI.Label(349.8, 144, 70.2, 30, mSelectSailor.name, GUIStyleLabel.MCenter_35_Redbean_Art)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..mSelectSailor.quality)
		GUI.DrawTexture(320, 200, 80, 80, image)
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..mSelectSailor.resId, AssetType.Pic)
		GUI.DrawTexture(325, 205,70,70,image)
		
		local color = ConstValue.QualityColorStr[mSelectSailor.quality]
		local infoStr = mCommonlyFunc.BeginColor(color)
		infoStr = infoStr .. ConstValue.Quality[mSelectSailor.quality]
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		GUI.Label(446, 208, 239, 30, "品质：", GUIStyleLabel.Left_25_Black)
		GUI.Label(520, 201, 239, 30, infoStr, GUIStyleLabel.Left_30_White_Art, Color.Black)
		-- GUI.Label(446, 252, 239, 30, "技能：好技能技能", GUIStyleLabel.Left_25_Black)
		
		GUI.Label(700, 208, 239, 30, Language[36]..mSelectSailor.business, GUIStyleLabel.Left_25_Black)
		GUI.Label(446, 252, 239, 30, Language[28]..mSelectSailor.power, GUIStyleLabel.Left_25_Black)
	else
		GUI.Label(349.8, 144, 70.2, 30, "未配置", GUIStyleLabel.MCenter_35_Redbean_Art)
		GUI.Label(270,193,640.45,96, "点击配置船长", GUIStyleLabel.MCenter_40_White, Color.Black)
		if GUI.Button(270,193,640.45,96, nil, GUIStyleButton.Transparent_40_Art) then
			function func(sailor)
				mPanelManager.Show(mMainPanel)
				mSelectSailor = sailor
				mPanelManager.Show(OnGUI)
			end
			mPanelManager.Hide(mMainPanel)
			mPanelManager.Hide(OnGUI)
			
			local mSailors = mSailorManager.GetBusinessSailors()
			mSailorSelectPanel.SetData(func,mSailors)
			mPanelManager.Show(mSailorSelectPanel)
			-- mSceneManager.SetMouseEvent(false)
		end
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(270,358,640.45,96,image,0,0,1,1,20,20,20,20)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(267.45,294,246,59,image)
	if mSelectShip then
		local cfg_ship = CFG_ship[mSelectShip.bid]
		GUI.Label(243, 310, 268.2, 30, cfg_ship.name, GUIStyleLabel.MCenter_35_Redbean_Art)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
		GUI.DrawTexture(320,365,80,80,image)
		local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..cfg_ship.resId, AssetType.Icon)
		GUI.DrawTexture(309, 355, 86, 86, image)
		
		GUI.Label(700, 371, 239, 30, Language[84]..cfg_ship.store, GUIStyleLabel.Left_25_Black)
		GUI.Label(446, 371, 239, 30, Language[87]..cfg_ship.speed, GUIStyleLabel.Left_25_Black)
		GUI.Label(446, 410, 239, 30, Language[28]..mCommonlyFunc.GetShipPower(cfg_ship.id), GUIStyleLabel.Left_25_Black)
	else
		GUI.Label(243, 310, 268.2, 30, "未配置", GUIStyleLabel.MCenter_35_Redbean_Art)
		GUI.Label(270,358,640.45,96, "点击配置船只", GUIStyleLabel.MCenter_40_White, Color.Black)
		if GUI.Button(270,358,640.45,96, nil, GUIStyleButton.Transparent_40_Art) then
			function func(ship)
				mPanelManager.Show(mMainPanel)
				mPanelManager.Show(OnGUI)
				mSelectShip = ship
			end
			mPanelManager.Hide(mMainPanel)
			mPanelManager.Hide(OnGUI)
			
			
			mShipSelectPanel.SetData(func)
			mPanelManager.Show(mShipSelectPanel)
			
			-- mSceneManager.SetMouseEvent(false)
		end
	end
	
	if GUI.Button(835, 192, 50, 95, nil, GUIStyleButton.SetBtn) then
		function func(sailor)
			-- mPanelManager.Show(mShipTeamPanel)
			mSelectSailor = sailor
			mPanelManager.Show(OnGUI)
		end
		mSailorSelectPanel.SetData(func)
		mPanelManager.Show(mSailorSelectPanel)
		-- mPanelManager.Hide(mShipTeamPanel)
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(835, 360, 50, 95, nil, GUIStyleButton.SetBtn) then
		function func(ship)
			-- mPanelManager.Show(mShipTeamPanel)
			mSelectShip = ship
			mPanelManager.Show(OnGUI)
		end
		mShipSelectPanel.SetData(func)
		mPanelManager.Show(mShipSelectPanel)
		-- mPanelManager.Hide(mShipTeamPanel)
		mPanelManager.Hide(OnGUI)
	end
	
	
	if GUI.Button(392.75, 459, 130.55, 60, "创建", GUIStyleButton.ShortOrangeArtBtn) then
		if not mSelectSailor then
			mSystemTip.ShowTip("请先配置船长")
			return
		end
		if not mSelectShip then
			mSystemTip.ShowTip("请先配置船只")
			return
		end
		-- print(mSelectSailor.id, mSelectShip.index)
		mShipTeamManager.RequestBuildShipTeam(mSelectShip.index, mSelectSailor.id)
		mPanelManager.Hide(OnGUI)
		mHeroPanel.mPage = 3
		mPanelManager.Show(mHeroPanel)
	end
	
	if GUI.Button(651.35, 459, 130.55, 60, "取消", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(893.35, 89, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
	
end
