local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit = ConstValue,CFG_EquipSuit
local AssetType,CFG_magic = AssetType,CFG_magic
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
local mSystemTip = nil
local mEquipMagicPanel = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.Equip.EquipViewPanel") -- 装备详情页面
panelType = ConstValue.AlertPanel
local mSailor = nil
local mEquip = nil
local mPerPanelFunc = nil

function SetData(sailor, equip, panelFunc)
	mSailor = sailor
	mEquip = equip
	mPerPanelFunc = panelFunc
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEquipMagicPanel = require "LuaScript.View.Panel.Equip.EquipMagicPanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(238,81,671,478,image)
	
	local cfg_Equip = CFG_Equip[mEquip.id]
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	-- GUI.DrawTexture(342,191,128,128,image)
	-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
	-- GUI.DrawTexture(347,196,100, 100, image)

	DrawItemCell(cfg_Equip, ItemType.Equip, 342,191,100,100, false)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(566,142,255,150,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(276,128,246,59,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg8_1")
	GUI.DrawTexture(314,345,203,30,image)
	GUI.DrawTexture(314,381,203,30,image)
	GUI.DrawTexture(314,418,203,30,image)
	GUI.DrawTexture(314,455,203,30,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg7_1")
	GUI.DrawTexture(596,330,212,30,image)
	GUI.DrawTexture(596,367,212,30,image)
	GUI.DrawTexture(596,404,212,30,image)
	
	local cfg_Equip = CFG_Equip[mEquip.id]
	GUI.Label(326, 131, 139, 30, cfg_Equip.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
	
	
	GUI.Label(353, 320, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	local infostr = mCommonlyFunc.GetQualityStr(cfg_Equip.quality)
	GUI.Label(401, 307, 66.2, 30, infostr, GUIStyleLabel.Center_30_White_Art, Color.Black)
	
	if not mEquip.magic or mEquip.magic == 0 then
		local infostr = "类型: " .. ConstValue.EquipType[cfg_Equip.type]
		GUI.Label(355, 350, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		local property = mCommonlyFunc.GetEquipProperty(mEquip)
		local infostr = CFG_property[cfg_Equip.propertyId].type .. ": " .. property
		GUI.Label(355, 386, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	else
		local property = mCommonlyFunc.GetEquipProperty(mEquip)
		local infostr = CFG_property[cfg_Equip.propertyId].type .. ": " .. property
		GUI.Label(355, 350, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
		
		local cfg_magic = CFG_magic[mEquip.magic]
		GUI.Label(355, 386, 104.2, 30, cfg_magic.name, GUIStyleLabel.Left_20_Black)
	end
	
	local infostr = Language[45] .. (mEquip.star or 0)
	GUI.Label(355, 423, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = Language[28] .. mCommonlyFunc.GetEquipPower(mEquip)
	GUI.Label(355, 460, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	local infostr = cfg_Equip.desc
	GUI.Label(572, 149, 244, 30, infostr, GUIStyleLabel.Left_25_Black_Art_WordWrap)

	local suitKey = cfg_Equip.suitId .. "_1"
	local cfg_EquipSuit = CFG_EquipSuit[suitKey]
	if cfg_EquipSuit then
		local sailor = mSailorManager.GetSailorById(mEquip.sid)
		local suitCount = mEquipManager.GetSuitCountByEquip(sailor, mEquip)
		local infostr = cfg_EquipSuit.setName.."(" .. suitCount .. "/" .. cfg_EquipSuit.totalCount .. ")"
		GUI.Label(584, 297, 199.2, 30, infostr, GUIStyleLabel.Center_25_Black)
		
		local property = CFG_property[cfg_EquipSuit.propertyId]
		local infostr = "(" .. cfg_EquipSuit.equipCount .. "件)   "
		infostr = infostr .. property.type
		infostr = infostr .. cfg_EquipSuit.propertyValue
		infostr = infostr .. property.sign
		if mEquipManager.GetSuitActiveByEquip(sailor, mEquip, 1) then
			GUI.Label(628, 335, 144.2, 30, infostr, GUIStyleLabel.Left_20_Lime, Color.Black)
		else
			GUI.Label(628, 335, 144.2, 30, infostr, GUIStyleLabel.Left_20_Gray)
		end
		

		local suitKey = cfg_Equip.suitId .. "_2"
		local cfg_EquipSuit = CFG_EquipSuit[suitKey]
		local property = CFG_property[cfg_EquipSuit.propertyId]
		local infostr = "(" .. cfg_EquipSuit.equipCount .. "件)   "
		infostr = infostr .. property.type
		infostr = infostr .. cfg_EquipSuit.propertyValue
		infostr = infostr .. property.sign
		if mEquipManager.GetSuitActiveByEquip(sailor, mEquip, 2) then
			GUI.Label(628, 372, 144.2, 30, infostr, GUIStyleLabel.Left_20_Lime, Color.Black)
		else
			GUI.Label(628, 372, 144.2, 30, infostr, GUIStyleLabel.Left_20_Gray)
		end
		

		local suitKey = cfg_Equip.suitId .. "_3"
		local cfg_EquipSuit = CFG_EquipSuit[suitKey]
		local property = CFG_property[cfg_EquipSuit.propertyId]
		local infostr = "(" .. cfg_EquipSuit.equipCount .. "件)   "
		infostr = infostr .. property.type
		infostr = infostr .. cfg_EquipSuit.propertyValue
		infostr = infostr .. property.sign

		if mEquipManager.GetSuitActiveByEquip(sailor, mEquip, 3) then
			GUI.Label(628, 408, 144.2, 30, infostr, GUIStyleLabel.Left_20_Lime, Color.Black)
		else
			GUI.Label(628, 408, 144.2, 30, infostr, GUIStyleLabel.Left_20_Gray)
		end
	end
	local oldEnabled = GUI.GetEnabled()
	if not mEquip.star or mEquip.inShipTeam then
		GUI.SetEnabled(false)
	end
	if GUI.Button(572, 447, 111, 53, Language[41], GUIStyleButton.ShortOrangeArtBtn) then
		local hero = mHeroManager.GetHero()
		-- if hero.level >= 30 and mEquip.star >= ConstValue.EquipMaxStar + cfg_Equip.quality then
			-- mEquipMagicPanel.SetData(mEquip)
			-- mPanelManager.Show(mEquipMagicPanel)
			-- mPanelManager.Hide(OnGUI)
		-- else
			mEquipUpPanel.SetData(mEquip)
			mPanelManager.Show(mEquipUpPanel)
			mPanelManager.Hide(OnGUI)
		-- end
		-- print("qianghua")
	end
	if mSailor and GUI.Button(703, 447, 111, 53, Language[42], GUIStyleButton.ShortOrangeArtBtn) then
		-- if mEquip.sid == mSailor.id then
			local sailor = mSailor
			local x,id = mSailorPanel.GetSelect()
			function SelectFunc(equip)
				if equip then
					mEquipManager.RequestWearEquip(equip.index, sailor.id)
				end
				mSailorPanel.SetSelect(x, id)
				mPanelManager.Show(mSailorPanel)
			end
			
			-- setevf
			local cfg_Equip = CFG_Equip[mEquip.id]
			mEquipSelectPanel.SetData(mSailor, cfg_Equip.type, SelectFunc)
			mPanelManager.Show(mEquipSelectPanel)
			mPanelManager.Hide(OnGUI)
			mPanelManager.Hide(mPerPanelFunc)
		-- else
			-- mEquipManager.RequestWearEquip(mEquip.index, mSailor.id)
			-- mPanelManager.Show(mSailorPanel)
			-- mPanelManager.Hide(OnGUI)
			-- mPanelManager.Hide(mPerPanelFunc)
		-- end
	end
	
	if not mSailor and GUI.Button(703, 447, 111, 53, Language[43], GUIStyleButton.ShortOrangeArtBtn) then
		mEquipDestroyPanel.SetData(mEquip)
		mPanelManager.Show(mEquipDestroyPanel)
		mPanelManager.Hide(OnGUI)
	end
	if not mEquip.star or mEquip.inShipTeam then
		GUI.SetEnabled(oldEnabled)
	end
	
	if GUI.Button(834, 62, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end
