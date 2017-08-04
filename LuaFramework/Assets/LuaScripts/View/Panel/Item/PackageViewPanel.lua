local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,CFG_shipEquip = ConstValue,CFG_EquipSuit,CFG_item,CFG_shipEquip
local AssetType,CFG_package,table,CFG_UniqueSailor,DrawItemCell = AssetType,CFG_package,table,CFG_UniqueSailor,DrawItemCell
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
local mEquipViewPanel = nil
local mItemViewPanel = nil
local mShipEquipViewPanel = nil
local mSailorViewPanel = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.Item.PackageViewPanel") -- 礼包内容预览
panelType = ConstValue.AlertPanel
notAutoClose = true
local mPackageId = nil
local mAwardList = nil
local mScrollPositionY = 0
local mCount = 0

function SetData(id, count)
	-- print(111111)
	mPackageId = id
	mCount = count or 1
	mAwardList = {}
	for k,cfg_package in pairs(CFG_package) do
		if cfg_package.itemId == mPackageId then
			table.insert(mAwardList, {id=cfg_package.awardId,type=cfg_package.type,count=cfg_package.count*mCount,notExist=true})
		end
	end
	mScrollPositionY = 0
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	if not mAwardList[1] then
		mPanelManager.Hide(OnGUI)
		return
	end
	
	local cfg_item = CFG_item[mPackageId]
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(146+16,68-16,848,524,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/packageView")
	GUI.DrawTexture(428+16,120-16,118,34,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_2")
	GUI.DrawTexture(240+16,150-16,674,32,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_1")
	GUI.DrawTexture(240+16,469-16,674,32,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(544+16,114-16,209,45,image)
	
	GUI.Label(548+16, 120-16, 184, 30, cfg_item.name, GUIStyleLabel.Center_30_LightBlue_Art,Color.Black)
	
	local spacingX = 315
	local spacingY = 115
	local count = #mAwardList
	_,mScrollPositionY = GUI.BeginScrollView(262, 186-32, 640, 260, 0, mScrollPositionY, 0-16, 0-16, 600, 50+spacingY * math.ceil(count/2)-10)
		for k,award in pairs(mAwardList) do
			local x = (k - 1) % 2 * spacingX
			local y = math.floor((k - 1) / 2) * spacingY

			DrawAward(award, x, y)
		end
	GUI.EndScrollView()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
	GUI.DrawTexture(525+16,430-16,59,16,image)
	
	if GUI.Button(446+16, 450-16, 223, 78,"确定", GUIStyleButton.OrangeBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
	
	if GUI.Button(911+16, 58-16, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end


function DrawAward(award, x, y)
	if not award then
		return 
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(x+55,y+6,240,88,image)

	if DrawItemCell(award,award.type,x, y,100,100)  then
		-- if award.type == 1 then
			-- mEquipViewPanel.SetData(nil, award)
			-- mPanelManager.Show(mEquipViewPanel)
		-- elseif award.type == 2 then
			-- mShipEquipViewPanel.SetData(nil, award)
			-- mPanelManager.Show(mShipEquipViewPanel)
		-- elseif award.type == 0 then
			-- mItemViewPanel.SetData(award.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- elseif award.type == 5 then
			-- local cfg_sailor = CFG_UniqueSailor[award.id]
			-- sailor = {}
			-- sailor.index = award.id
			-- sailor.star = 0
			-- sailor.exLevel = 0
			-- sailor.name = cfg_sailor.name
			-- sailor.quality = cfg_sailor.quality
			-- sailor.resId = cfg_sailor.resId
			-- sailor.notExit = true
			-- mSailorManager.UpdateProperty(sailor)
			-- mSailorViewPanel.SetData(sailor)
			-- mPanelManager.Show(mSailorViewPanel)
		-- end
	end
	
	
	
	
	
	
	if award.type == 1 then
		local cfg_equip = CFG_Equip[award.id]
		GUI.Label(116+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Center_25_DeepBlue_Art)
		GUI.Label(116+x, 14+y, 154, 30, cfg_equip.name, GUIStyleLabel.Center_25_Brown_Art)
	elseif award.type == 2 then
		local cfg_equip = CFG_shipEquip[award.id]
		GUI.Label(116+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Center_25_DeepBlue_Art)
		GUI.Label(116+x, 14+y, 154, 30, cfg_equip.name, GUIStyleLabel.Center_25_Brown_Art)
	elseif award.type == 0 then
		local cfg_item = CFG_item[award.id]
		GUI.Label(116+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Center_25_DeepBlue_Art)
		GUI.Label(116+x, 14+y, 154, 30, cfg_item.name, GUIStyleLabel.Center_25_Brown_Art)
	elseif award.type == 5 then
		local cfg_sailor = CFG_UniqueSailor[award.id]
		GUI.Label(116+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Center_25_DeepBlue_Art)
		GUI.Label(116+x, 14+y, 154, 30, cfg_sailor.name, GUIStyleLabel.Center_25_Brown_Art)
	end
end
