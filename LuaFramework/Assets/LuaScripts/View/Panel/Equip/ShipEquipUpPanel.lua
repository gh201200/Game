local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType,table = 
ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType,table
local AssetType,AppearEvent,CFG_shipEquip,CFG_shipEquipGrade = 
AssetType,AppearEvent,CFG_shipEquip,CFG_shipEquipGrade
local DrawItemCell,ItemType = DrawItemCell,ItemType
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
local mSystemTip = nil
local mItemManager = nil
local mPanelManager = nil
local mEventManager = nil
local mSetManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
local mVipManager = nil
local mLabManager = nil
local mShipEquipSelectPanel = nil
local mShipEquipManager = nil
local mMainPanel = nil
local mItemBagPanel = nil
local mFleetPanel = nil
module("LuaScript.View.Panel.Equip.ShipEquipUpPanel")
panelType = ConstValue.AlertPanel

local mEquip = nil
local mCostList = nil

local mUpStar = 0
local mUpExp = 0
local mUpMaxExp = 0

local mCouldUpStar = 0


function SetData(equip)
	mEquip = equip
	mCostList = {}
end

function Init()
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mVipManager = require "LuaScript.Control.Data.VipManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mShipEquipSelectPanel = require "LuaScript.View.Panel.Equip.ShipEquipSelectPanel"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	IsInit = true
	
	mEventManager = require "LuaScript.Control.EventManager"
	mEventManager.AddEventListen(nil, EventType.RefreshShipEquipUp, RefreshShipEquipUp)
end

function Display()
	RefreshUp()
end

function RefreshShipEquipUp()
	mCostList = {}
	RefreshUp()
end

function OnGUI()
	if not IsInit or not visible then
		return
	end
	
	local cfg_Equip = CFG_shipEquip[mEquip.id]
	if mEquip.star >= math.min(ConstValue.EquipMaxStar + cfg_Equip.quality,10) then
		mPanelManager.Hide(OnGUI)
		mSystemTip.ShowTip("已强化至最高等级")
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(179,54,848,524,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	-- GUI.DrawTexture(356,146,128,128, image)
	-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_Equip.icon, AssetType.Icon)
	-- GUI.DrawTexture(364,154,100, 100, image)
	DrawItemCell(cfg_Equip, ItemType.ShipEquip, 356,146,128,128)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(553,104,370,157,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(313,97,210,50,image)
	
	GUI.Label(316, 106, 190, 30, cfg_Equip.name, GUIStyleLabel.Center_40_Brown_Art)

	GUI.Label(616, 108, 54, 30, "当前", GUIStyleLabel.Left_25_DeepBlue_Art)
	GUI.Label(839, 108, 54, 30, "最高", GUIStyleLabel.Left_25_DeepBlue_Art)
	if mCouldUpStar == mEquip.star then
		GUI.Label(768, 108, 54, 30, "下级", GUIStyleLabel.Left_25_DeepBlue_Art)
	else
		GUI.Label(768, 108, 54, 30, "效果", GUIStyleLabel.Left_25_DeepBlue_Art)
	end
	
	local infostr = Language[45] .. mEquip.star
	GUI.Label(578, 143, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local property = mCommonlyFunc.GetShipEquipProperty(mEquip)
	local infostr = CFG_property[cfg_Equip.propertyId1].type .. ": " .. property
	GUI.Label(578, 180, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = "战力: " .. mCommonlyFunc.GetShipEquipPower(mEquip)
	GUI.Label(578, 218, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg12_1")
	GUI.DrawTexture(722,146,38,16,image)
	GUI.DrawTexture(722,184,38,16,image)
	GUI.DrawTexture(722,222,38,16,image)
	
	local infostr = mUpStar
	GUI.Label(775, 143, 44, 30, infostr, GUIStyleLabel.Center_20_Black)
	local property = mCommonlyFunc.GetShipEquipProperty(mEquip, mUpStar)
	GUI.Label(775, 180, 44, 30, property, GUIStyleLabel.Center_20_Black)
	local infostr = mCommonlyFunc.GetShipEquipPower(mEquip, mUpStar)
	GUI.Label(775, 220, 44, 30, infostr, GUIStyleLabel.Center_20_Black)
	
	local maxLevel = math.min(ConstValue.EquipMaxStar + cfg_Equip.quality,10)
	GUI.Label(845, 143, 44, 30, maxLevel, GUIStyleLabel.Center_20_Cyan, Color.Black)
	local property = mCommonlyFunc.GetShipEquipProperty(mEquip, maxLevel)
	GUI.Label(845, 180, 44, 30, property, GUIStyleLabel.Center_20_Cyan, Color.Black)
	local infostr = mCommonlyFunc.GetShipEquipPower(mEquip, maxLevel)
	GUI.Label(845, 220, 44, 30, infostr, GUIStyleLabel.Center_20_Cyan, Color.Black)
	
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg41_1")
	GUI.DrawTexture(285,269,465,80,image)
	if mCouldUpStar >= maxLevel then
		local key = cfg_Equip.quality .. "_10"
		local cfg_shipEquipGrade = CFG_shipEquipGrade[key]
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg_4")
		GUI.DrawTexture(303,293,341,24,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg41_2")
		GUI.DrawTexture(285,268,465,80,image)
		GUI.Label(495, 295, 32, 30, cfg_shipEquipGrade.exp.."/"..cfg_shipEquipGrade.exp, GUIStyleLabel.Center_25_White)
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg_4")
		GUI.DrawTexture(303,293,341*(mUpExp/mUpMaxExp),24,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg41_2")
		GUI.DrawTexture(285,268,465,80,image)
		GUI.Label(495, 295, 32, 30, mUpExp.."/"..mUpMaxExp, GUIStyleLabel.Center_25_White)
	end
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg40_1")
	GUI.DrawTexture(261,352,677,148,image)
	
	if #mCostList == 0 then
		if GUI.Button(760, 273, 166, 77, "选材", GUIStyleButton.BlueBtn) then
			local equips = GetRestEquips()
			if #equips == 0 then
				mSystemTip.ShowTip("没有未锁定的空闲装备")
				return
			end
			
			
			local cosetListLength = #mCostList
			for i=cosetListLength+1,5 do
				table.insert(mCostList, equips[i-cosetListLength])
			end
			
			RefreshUp()
		end
	else
		if GUI.Button(760, 273, 166, 77, "改造", GUIStyleButton.BlueBtn) then
			-- if not mCostList[1] then
				-- mSystemTip.ShowTip("请先选择改造素材")
				-- return
			-- end
			
			mShipEquipManager.RequestUp(mEquip.index, mCostList)
		end
	end
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Text/change")
	-- GUI.DrawTexture(803,283,80,43,image)
	
	-- GUI.Label(540-165, 355-17+60, 104, 30, "改造素材", GUIStyleLabel.Center_30_LightYellow_Art, Color.Black)
	
	for i=5,1,-1 do
		local x = i * 120 + 308 - 120
		local equip = mCostList[i]
		DrawCost(x,399,i,equip)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/blue")
	GUI.DrawTexture(783,392,100,2,image)
	if GUI.Button(755, 365, 156, 29, "船装背包", GUIStyleButton.Link_25) then
		mItemBagPanel.SetPage(3)
		mPanelManager.Show(mItemBagPanel)
		mPanelManager.Hide(mFleetPanel)
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(945, 41, 77, 63,nil,GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function RefreshUp()
	mCouldUpStar = mEquip.star
	mUpStar = mEquip.star
	mUpExp = mEquip.exp
	mUpMaxExp = 100
	for k,equip in pairs(mCostList) do
		-- print(equip)
		local cfg_shipEquip = CFG_shipEquip[equip.id]
		local key = cfg_shipEquip.quality .. "_" .. equip.star
		local cfg_shipEquipUp = CFG_shipEquipGrade[key]
		mUpExp = mUpExp + cfg_shipEquip.point + equip.exp + cfg_shipEquipUp.totalExp
	end
	
	local cfg_Equip = CFG_shipEquip[mEquip.id]
	for i = mEquip.star+1,math.min(ConstValue.EquipMaxStar + cfg_Equip.quality,10) do
		local key = cfg_Equip.quality .. "_" .. i
		local cfg_shipEquipUp = CFG_shipEquipGrade[key]
		mUpMaxExp = cfg_shipEquipUp.exp
		if cfg_shipEquipUp.exp > mUpExp then
			break
		end
		
		mUpExp = mUpExp - cfg_shipEquipUp.exp
		mCouldUpStar = cfg_shipEquipUp.grade
	end

	mUpStar = math.max(mCouldUpStar, mEquip.star+1)
end

function DrawCost(x,y,index,equip)
	if equip then
		-- print(22222)
		local cfg_shipEquip = CFG_shipEquip[equip.id]
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfg_shipEquip.quality)
		-- GUI.DrawTexture(x, y,80,80,image)
		
		-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_shipEquip.icon, AssetType.Icon)
		if DrawItemCell(cfg_shipEquip, ItemType.ShipEquip, x, y, 80, 80, true, false, false) then
			table.remove(mCostList, index)
		end
		
		RefreshUp()
	else
		-- print(11111)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
		if GUI.TextureButton(x,y,80,80,image) then
			if #GetRestEquips() == 0 then
				mSystemTip.ShowTip("没有未锁定的空闲装备")
				return
			end
			local select = mFleetPanel.GetSelect()
			function SelectFunc(equip)
				if equip then
					table.insert(mCostList, equip)
				end
				mFleetPanel.SetSelect(select)
				mPanelManager.Show(mFleetPanel)
				mPanelManager.Show(OnGUI)
				
				RefreshUp()
			end
			
			mPanelManager.Hide(OnGUI)
			mPanelManager.Hide(mFleetPanel)
			
			mShipEquipSelectPanel.SetData(nil, nil, SelectFunc, GetRestEquips())
			mPanelManager.Show(mShipEquipSelectPanel)
		end
		GUI.Label(x, y+9, 80, 30, "点击\n选择", GUIStyleLabel.Center_30_White_Art, Color.Black)
	end
end

function GetRestEquips()
	local indexList = {[mEquip.index]=true}
	for k,v in pairs(mCostList) do
		indexList[v.index] = true
	end
	
	local mRestEquips = mShipEquipManager.GetRestEquips(indexList)
	table.sort(mRestEquips, SortFunc2)
	
	return mRestEquips
end

function SortFunc2(a, b)
	local cfg_a = CFG_shipEquip[a.id]
	local cfg_b = CFG_shipEquip[b.id]
	
	if cfg_a.type == 4 and cfg_b.type ~= 4 then
		return false
	elseif cfg_a.type ~= 4 and cfg_b.type == 4 then
		return true
	end
	if cfg_a.quality < cfg_b.quality then
		return true
	elseif cfg_a.quality > cfg_b.quality then
		return false
	end
	if a.id > b.id then
		return true
	elseif a.id < b.id then
		return false
	end
	return false
end
