local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local AssetType,CFG_shipEquip = AssetType,CFG_shipEquip
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
local mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
local mCommonlyFunc = nil
local mSailorManager = nil
local mShipEquipViewPanel = nil
local DrawItemCell,ItemType = DrawItemCell,ItemType

module("LuaScript.View.Panel.Equip.ShipEquipSelectPanel")

local mScrollPositionY = 0
local mEquipList = nil
local mShip = nil
local mEquipType = nil
-- local mPerPanelFunc = nil
local mSelectFunc = nil
function SetData(ship, equipType, selectFunc, equipList)
	mShip = ship
	mEquipType = equipType
	mSelectFunc = selectFunc
	if not equipList then
		mEquipList = mShipEquipManager.GetEquipsByType(equipType)
		table.sort(mEquipList, SortFunc)
	else
		mEquipList = equipList
	end
end

function SortFunc(a, b)
	local cfg_a = CFG_shipEquip[a.id]
	local cfg_b = CFG_shipEquip[b.id]

	if a.sid < b.sid then
		return true
	elseif a.sid > b.sid then
		return false
	end
	if cfg_a.quality > cfg_b.quality then
		return true
	elseif cfg_a.quality < cfg_b.quality then
		return false
	end
	if a.id > b.id then
		return true
	elseif a.id < b.id then
		return false
	end
	return false
end

function Init()
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mPage = 1
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
	
	if mEquipType then
		GUI.Label(525.5,48,84.2,30,ConstValue.ShipEquipType[mEquipType], GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	else
		GUI.Label(525.5,48,84.2,30,"请选择", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	end
	
	local spacing = 156
	local count = #mEquipList
	_,mScrollPositionY = GUI.BeginScrollView(154, 136.4, 900, 460.5, 0, mScrollPositionY, 0, 0, 850, spacing * count)
		for k,equip in pairs(mEquipList) do
			local y = (k-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 then
				DrawEquip(equip, y)
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
		mSelectFunc(nil)
		-- mPanelManager.Show(mPerPanelFunc)
		mPanelManager.Hide(OnGUI)
		mScrollPositionY = 0
	end
end

function DrawEquip(equip, y)
	local cfg_Equip = CFG_shipEquip[equip.id]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,144,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	-- GUI.DrawTexture(34.45, y+17,128,128,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_Equip.icon, AssetType.Icon)
	-- if GUI.TextureButton(39.45, y+22, 100, 100, image) then
		-- mShipEquipViewPanel.SetData(nil, equip)
		-- mPanelManager.Show(mShipEquipViewPanel)
	-- end
	DrawItemCell(cfg_Equip, ItemType.ShipEquip, 34.45, y+17,100,100)
	
	
	GUI.Label(180, y+19.6, 74.2, 30, cfg_Equip.name, GUIStyleLabel.Left_35_Redbean_Art)
	
	GUI.Label(188, y+73, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	-- local qualityColor = ConstValue.QualityColorStr[cfg_Equip.quality]
	local infostr = mCommonlyFunc.GetQualityStr(cfg_Equip.quality)
	-- infostr = infostr.. ConstValue.Quality[cfg_Equip.quality]
	-- infostr = infostr.. mCommonlyFunc.EndColor()
	GUI.Label(238, y+68, 74.2, 30, infostr, GUIStyleLabel.Center_30_White_Art, Color.Black)
	
	local infostr = "类型: " .. cfg_Equip.typeName
	GUI.Label(188, y+101, 74.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	GUI.Label(372, y+17, 280, 51, "附加技能:"..cfg_Equip.skillDesc, GUIStyleLabel.MLeft_20_Black_WordWrap)
	
	local infostr = CFG_property[cfg_Equip.propertyId1].type .. ": " .. mCommonlyFunc.GetShipEquipProperty(equip)
	GUI.Label(372, y+73, 114, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[28] .. mCommonlyFunc.GetShipEquipPower(equip)
	GUI.Label(372, y+101, 134, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	
	if equip.sid ~= 0 then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/wear")
		GUI.DrawTexture(36, y+15,64,64,image)
	end
	
	if mShip and equip.sid == mShip.index then
		GUI.Button(654.5, y+58.05, 111, 60, "已装备", GUIStyleLabel.Left_35_Brown_Art)
	else
		if GUI.Button(654.5, y+48.05, 111, 60,nil, GUIStyleButton.SelectBtn) then
			mPanelManager.Hide(OnGUI)
			mSelectFunc(equip)
		end
	end
end