local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local AssetType,CFG_ship = AssetType,CFG_ship
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipViewPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mCommonlyFunc = nil
local mShipManager = require "LuaScript.Control.Data.ShipManager"
local mViewShipPanel = nil

module("LuaScript.View.Panel.Harbor.ShipSelectPanel") -- 造船厂配置界面

local mScrollPositionY = 0
local mShipList = nil
local mSelectFunc = nil

function SetData(selectFunc, list)
	mSelectFunc = selectFunc
	
	mShipList = list or mShipManager.GetRestShip()
end

function Display()
	mScrollPositionY = 0
	mSceneManager.SetMouseEvent(false)
end

function Init()
	
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mViewShipPanel = require "LuaScript.View.Panel.Harbor.ShipViewPanel"

	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"选择船只", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local spacing = 156
	local count = #mShipList
	_,mScrollPositionY = GUI.BeginScrollView(154, 136.4, 900, 460.5, 0,mScrollPositionY, 0, 0, 850, spacing * count)
		for k,ship in pairs(mShipList) do
			local y = (k-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 then
				DrawShip(ship, y)
			end
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		if count < 1 then
			GUI.DrawTexture(0,spacing*0,830,144,image)
		end
		if count < 2 then
			GUI.DrawTexture(0,spacing*1,830,144,image)
		end
		if count < 3 then
			GUI.DrawTexture(0,spacing*2,830,144,image)
		end
	GUI.EndScrollView()
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		-- mPanelManager.Show(mPerPanelFunc)
		mSelectFunc(nil)
		mPanelManager.Hide(OnGUI)
	end
end

function DrawShip(ship, y)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,144,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_0")
	if GUI.TextureButton(34.45, y+22,128,128,image) then
		mViewShipPanel.SetData(ship, ship.bid)
		mPanelManager.Show(mViewShipPanel)
	end
	
	-- local image = mAssetManager.GetAsset("Texture/Character/Header/"..sailor.resId, AssetType.Icon)
	-- GUI.DrawTexture(39.45, y+22, 100, 100, image)
	
	local cfg_ship = CFG_ship[ship.bid]
	local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..cfg_ship.resId, AssetType.Icon)
	GUI.DrawTexture(15.45, y+4,125,125,image)
	
	
	GUI.Label(170, y+10, 74.2, 30, cfg_ship.name, GUIStyleLabel.Left_35_Redbean_Art)
	
	local infoStr = Language[33]..ship.attack
	GUI.Label(170, y+48, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
	local infoStr = Language[34]..ship.defense
	GUI.Label(170, y+76, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
	local infoStr = "血量: "..ship.hp
	GUI.Label(170, y+103, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
	
	local infostr = "耐久: " .. ship.life
	GUI.Label(426, y+19, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[84] .. ship.store
	GUI.Label(426, y+48, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[87] .. cfg_ship.speed
	GUI.Label(426, y+76, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infoStr = Language[28].. mCommonlyFunc.GetShipPower(cfg_ship.id)
	GUI.Label(426, y+103, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
	
	if GUI.Button(618, y+37, 111, 60,nil, GUIStyleButton.UseBtn) then
		mSelectFunc(ship)
		mPanelManager.Hide(OnGUI)
	end

end