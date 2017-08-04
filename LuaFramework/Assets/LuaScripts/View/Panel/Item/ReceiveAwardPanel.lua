local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local CFG_Equip,AssetType,CFG_item,CFG_shipEquip = CFG_Equip,AssetType,CFG_item,CFG_shipEquip

local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mItemViewPanel = nil
local mEquipViewPanel = nil
local mShipEquipViewPanel = nil
local mShipEquipManager = nil
local mEquipManager = nil
module("LuaScript.View.Panel.Item.ReceiveAwardPanel")-- 接收奖励
local mAwards = nil
local mScrollPositionY = 0
local mMouseEventState = nil

panelType = ConstValue.AlertPanel

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	IsInit = true
end

function Show(awards)
	mAwards = awards
	mPanelManager.Show(OnGUI)
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mScrollPositionY = 0
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg27_1")
	GUI.DrawTexture(350,150,467,341,image)
	
	if not mAwards[2] then
		local mAward = mAwards[1]
		DrawAward(mAward, 441, 265)
		
		if GUI.Button(500, 375, 166, 77, Language[25], GUIStyleButton.BlueBtn) then
			mPanelManager.Hide(OnGUI)
		end
		
		if GUI.Button(743, 132, 77, 63, nil, GUIStyleButton.CloseBtn) then
			mPanelManager.Hide(OnGUI)
		end
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
		GUI.DrawTexture(146+16,68-16,848,524,image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Text/packageView")
		-- GUI.DrawTexture(428+16,120-16,118,34,image)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_2")
		GUI.DrawTexture(240+16,150-16,674,32,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Text/got")
		GUI.DrawTexture(240+16+222,469-16-357,213,44,image)
		
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
		-- GUI.DrawTexture(544+16,114-16,209,45,image)
		
		local spacingX = 315
		local spacingY = 115
		local count = #mAwards
		_,mScrollPositionY = GUI.BeginScrollView(262, 186-16, 640, 248, 0, mScrollPositionY, -16, -5, 600, spacingY * math.ceil(count/2)-10)
			for k,award in pairs(mAwards) do
				local x = (k - 1) % 2 * spacingX
				local y = math.floor((k - 1) / 2) * spacingY

				DrawAward(award, x, y)
			end
		GUI.EndScrollView()
		
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
		GUI.DrawTexture(525+16,430-16,59,16,image)
		
		if GUI.Button(446+16, 450-16, 223, 78,"确定", GUIStyleButton.OrangeBtn) then
			mPanelManager.Hide(OnGUI)
		end
		
		if GUI.Button(911+16, 58-16, 77, 63,nil, GUIStyleButton.CloseBtn) then
			mPanelManager.Hide(OnGUI)
		end
	end
end

function DrawAward(award, x, y)
	if not award then
		return 
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(x+55,y+6,240,88,image)
	
	DrawItemCell(award, award.type, x,y,100,100,true,false)
	
	if award.type == 1 then
		local cfg_equip = CFG_Equip[award.id]
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_equip.quality)
		-- GUI.DrawTexture(x,y,118,118,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(x+7,y+7,90,90,image) then
			-- mEquipViewPanel.SetData(nil, award)
			-- mPanelManager.Show(mEquipViewPanel)
		-- end

		GUI.Label(116+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Center_25_DeepBlue_Art)
		GUI.Label(116+x, 14+y, 154, 30, cfg_equip.name, GUIStyleLabel.Center_25_Brown_Art)
	elseif award.type == 2 then
		local cfg_equip = CFG_shipEquip[award.id]
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_equip.quality)
		-- GUI.DrawTexture(x,y,118,118,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(x+7,y+7,90,90,image) then
			-- mShipEquipViewPanel.SetData(nil, award)
			-- mPanelManager.Show(mShipEquipViewPanel)
		-- end

		GUI.Label(116+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Center_25_DeepBlue_Art)
		GUI.Label(116+x, 14+y, 154, 30, cfg_equip.name, GUIStyleLabel.Center_25_Brown_Art)
	else
		local cfg_item = CFG_item[award.id]
		
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if GUI.TextureButton(x, y,100,100,image) then
			-- mItemViewPanel.SetData(cfg_item.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end

		GUI.Label(116+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Center_25_DeepBlue_Art)
		GUI.Label(116+x, 14+y, 154, 30, cfg_item.name, GUIStyleLabel.Center_25_Brown_Art)
	end
end
