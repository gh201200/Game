local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,EventType = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,EventType
local DrawItemCell,ItemType = DrawItemCell,ItemType
local CFG_Equip,CFG_shipEquip,CFG_item,AssetType = CFG_Equip,CFG_shipEquip,CFG_item,AssetType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
-- local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mActionManager = require "LuaScript.Control.ActionManager"
local mSetManager = require "LuaScript.Control.System.SetManager"
local mProtectPanel = require "LuaScript.View.Panel.View.Guide.ProtectPanel"
local mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
local mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
local mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
local mItemManager = require "LuaScript.Control.Data.ItemManager"
local mEventManager = require "LuaScript.Control.EventManager"
--boss奖励ROLL点
module("LuaScript.View.Panel.Main.RollBossAward")

local mBossId = nil
local mAwardList = nil

function Init()
	
end

function SetData(bossId, awardList)
	mStarTime = os.oldTime
	mBossId = bossId
	mAwardList = awardList
	visible = true
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, Refreshed)
end

function Refreshed()
	visible = false
end

function OnGUI()
	if not visible then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg48_1")
	GUI.DrawTexture(765,402,372,232,image)
	
	local lastTime = mStarTime - os.oldTime + 60
	GUI.Label(780, 415, 146, 29, "BOSS奖励", GUIStyleLabel.Left_30_White_Art)
	GUI.Label(1051, 418, 43, 29, lastTime.."秒", GUIStyleLabel.Center_25_Red)
	
	
	local mAward = mAwardList[1]
	DrawItemCell(mAward, mAward.type, 780,466,100,100)
	if mAward.type == 1 then
		local cfg_equip = CFG_Equip[mAward.id]
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_equip.quality)
		-- GUI.DrawTexture(775,461,128,128,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(780,466,100,100,image) then
			-- mEquipViewPanel.SetData(nil, mAward)
			-- mPanelManager.Show(mEquipViewPanel)
		-- end

		GUI.Label(900, 478, 129, 30, cfg_equip.name, GUIStyleLabel.Left_25_Brown_Art)
		GUI.Label(910, 514, 104, 29, "数量×"..mAward.count, GUIStyleLabel.Left_25_Gray)
	elseif mAward.type == 2 then
		local cfg_equip = CFG_shipEquip[mAward.id]
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_equip.quality)
		-- GUI.DrawTexture(775,461,128,128,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(780,466,100,100,image) then
			-- mShipEquipViewPanel.SetData(nil, mAward)
			-- mPanelManager.Show(mShipEquipViewPanel)
		-- end

		GUI.Label(900, 478, 129, 30, cfg_equip.name, GUIStyleLabel.Left_25_Brown_Art)
		GUI.Label(910, 514, 104, 29, "数量×"..mAward.count, GUIStyleLabel.Left_25_Gray)
	else
		local cfg_item = CFG_item[mAward.id]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if DrawItemCell(cfg_item, ItemType.Item, 780, 468,100,100) then
			-- mItemViewPanel.SetData(cfg_item.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
		
		GUI.Label(900, 478, 129, 30, cfg_item.name, GUIStyleLabel.Left_25_Brown_Art)
		GUI.Label(910, 514, 104, 29, "数量×"..mAward.count, GUIStyleLabel.Left_25_Gray)
	end
	
	
	if GUI.Button(775, 578, 166, 52, nil, GUIStyleButton.RollBtn) then
		table.remove(mAwardList,1)
		mItemManager.RequestRollItem(mBossId, mAward.index, 0)
	end
	if GUI.Button(955, 578, 166, 52, nil, GUIStyleButton.GiveUpBtn_1) then
		table.remove(mAwardList,1)
		mItemManager.RequestRollItem(mBossId, mAward.index, 1)
	end
	
	if not mAwardList[1] then
		visible = false
	end
	
	if lastTime < 0 then
		visible = false
	end
end