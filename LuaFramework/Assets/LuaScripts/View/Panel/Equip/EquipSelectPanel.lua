local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local AssetType,CFG_magic = AssetType,CFG_magic
local DrawItemCell,ItemType = DrawItemCell,ItemType
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
local mSailorManager = nil

module("LuaScript.View.Panel.Equip.EquipSelectPanel")

local mScrollPositionY = 0
local mEquipList = nil
local mSailor = nil
local mEquipType = nil
-- local mPerPanelFunc = nil
local mSelectFunc = nil
function SetData(sailor, equipType, selectFunc, duty, equipList)
	mSailor = sailor
	mEquipType = equipType
	mSelectFunc = selectFunc

	mEquipList = equipList or mEquipManager.GetEquipsByType(equipType, duty)
	table.sort(mEquipList, SortFunc)
end

function SortFunc(a, b)
	local cfg_a = CFG_Equip[a.id]
	local cfg_b = CFG_Equip[b.id]
	if not a.inShipTeam and b.inShipTeam then
		return true
	elseif a.inShipTeam and not b.inShipTeam then
		return false
	end
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
	if cfg_a.type < cfg_b.type then
		return true
	elseif cfg_a.type > cfg_b.type then
		return false
	end
	if a.power > b.power then
		return true
	elseif a.power < b.power then
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
		GUI.Label(525.5,48,84.2,30,ConstValue.EquipType[mEquipType], GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
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
	local cfg_Equip = CFG_Equip[equip.id]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,144,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	-- GUI.DrawTexture(34.45, y+17,128,128,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
	-- if GUI.TextureButton(39.45, y+22, 100, 100, image) then
		-- mEquipViewPanel.SetData(nil, equip, OnGUI)
		-- mPanelManager.Show(mEquipViewPanel)
	-- end
	DrawItemCell(cfg_Equip, ItemType.Equip, 34.45, y+17,100,100)
	
	
	GUI.Label(180, y+19.6, 74.2, 30, cfg_Equip.name, GUIStyleLabel.Left_35_Redbean_Art)
	
	GUI.Label(188, y+73.6, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	-- local qualityColor = ConstValue.QualityColorStr[cfg_Equip.quality]
	local infostr = mCommonlyFunc.GetQualityStr(cfg_Equip.quality)
	-- infostr = infostr.. ConstValue.Quality[cfg_Equip.quality]
	-- infostr = infostr.. mCommonlyFunc.EndColor()
	GUI.Label(238, y+68, 74.2, 30, infostr, GUIStyleLabel.Center_30_White_Art, Color.Black)
	
	local infostr = "类型: " .. ConstValue.EquipType[cfg_Equip.type]
	GUI.Label(188, y+101.6, 74.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	if equip.magic and equip.magic ~= 0 then
		local property = mCommonlyFunc.GetEquipProperty(equip)
		local infostr = CFG_property[cfg_Equip.propertyId].type .. ": " .. property .."(强" .. equip.star .. ")"
		GUI.Label(372, y+17.6, 74.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		
		local cfg_magic = CFG_magic[equip.magic]
		GUI.Label(372, y+45.6, 74.2, 30, cfg_magic.name, GUIStyleLabel.Left_20_Black)
	else
		local property = mCommonlyFunc.GetEquipProperty(equip)
		local infostr = CFG_property[cfg_Equip.propertyId].type .. ": " .. property
		GUI.Label(372, y+17.6, 74.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		
		local infostr = Language[45] .. equip.star
		GUI.Label(372, y+45.6, 74.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	end
	
	local infostr = Language[28] .. mCommonlyFunc.GetEquipPower(equip)
	GUI.Label(372, y+73.6, 74.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	local char = mSailorManager.GetSailorById(equip.sid)
	if char then
		local infoStr = mCommonlyFunc.BeginColor(Color.BlackStr)
		infoStr = infoStr .. Language[47]
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.RedbeanStr)
		infoStr = infoStr .. char.name
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		if equip.inShipTeam then
			infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.RedStr)
			infoStr = infoStr .. "(商)"
			infoStr = infoStr .. mCommonlyFunc.EndColor()
		end
		GUI.Label(372, y+101.6, 74.2, 30, infoStr, GUIStyleLabel.Left_20_White)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Text/wear")
		GUI.DrawTexture(36, y+15,64,64,image)
	else
		local infoStr = Language[47]
		infoStr = infoStr .. Language[46]
		GUI.Label(372, y+101.6, 74.2, 30, infoStr, GUIStyleLabel.Left_20_Black)
	end
	
	if mSailor and equip.sid == mSailor.id then
		GUI.Button(654.5, y+53.05, 111, 60, "已穿戴", GUIStyleLabel.Left_35_Brown_Art)
	else
		local oldEnabled = GUI.GetEnabled()
		if equip.inShipTeam then
			GUI.SetEnabled(false)
		end
		if GUI.Button(654.5, y+48.05, 111, 60,nil, GUIStyleButton.SelectBtn) then
			mPanelManager.Hide(OnGUI)
			mSelectFunc(equip)
		end
		if equip.inShipTeam then
			GUI.SetEnabled(oldEnabled)
		end
	end
end