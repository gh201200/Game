local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item = ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item
local AssetType,SceneType,ItemType,DrawItemCell = AssetType,SceneType,ItemType,DrawItemCell
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mVipManager = require "LuaScript.Control.Data.VipManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mCopyMapManager = nil
local mCopyMapCleanPanel = nil
local mCopyMapPanel = nil
local mItemViewPanel = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mSystemTip = nil
local mShipManager = nil
local mEquipViewPanel = nil
local mMainPanel = nil

module("LuaScript.View.Panel.CopyMap.CopyMapViewPanel")  -- 副本信息面板
panelType = ConstValue.AlertPanel
local mCopyMapId = 1
local mCostTip = nil
local mAwardList = nil
local mScrollPositionX = 0
function SetData(id)
	mCopyMapId = id
end

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCopyMapManager = require "LuaScript.Control.Data.CopyMapManager"
	mCopyMapCleanPanel = require "LuaScript.View.Panel.CopyMap.CopyMapCleanPanel"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	IsInit = true
end

function Display()
	mCostTip = mSetManager.GetCostTip()
	mAwardList = mCopyMapManager.InitAward(mCopyMapId)
	mScrollPositionX = 0
end

function OnGUI()
	if not IsInit then
		return
	end
	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(196,83.4,749,468.25,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(270.4,130.85,246,59,image)
	
	local cfg_copyMap = CFG_copyMap[mCopyMapId]
	GUI.Label(320.4, 131.85, 139.2, 30, cfg_copyMap.name, GUIStyleLabel.Center_45_Brown_Art)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(252,200,275,220,image)
	
	GUI.Label(268, 222, 240.45, 30, cfg_copyMap.desc, GUIStyleLabel.Left_25_Black_WordWrap)
	GUI.Label(268, 338, 191.7, 30, "战斗力:"..cfg_copyMap.power, GUIStyleLabel.Left_25_Black)
	
	GUI.Label(268, 377, 154.2, 30, "当前活力："..hero.copyMapCount, GUIStyleLabel.Left_25_Black)
	if GUI.Button(423, 366, 50, 50,nil, GUIStyleButton.AddBtn) then
		if not mVipManager.CopyMapCountBuy() then
			mAlert.Show("活力购买次数已用完，提升VIP等级可继续购买，是否前往充值？", mCommonlyFunc.Recharge)
			return
		end
	
		local cost = mCopyMapManager.BuyCountCost(1)
		if mCostTip then
			function okFun(showTip)
				if not mCommonlyFunc.HaveGold(cost) then
					return
				end
				mCopyMapManager.RequestAddCount()
				mCostTip = not showTip
			end
			mSelectAlert.Show("是否花费"..cost.."元宝购买1点活力", okFun)
		else
			if not mCommonlyFunc.HaveGold(cost) then
				return
			end
			mCopyMapManager.RequestAddCount()
		end
	end
	
	GUI.Label(588, 150, 54.2, 30, "奖励", GUIStyleLabel.Left_25_Brown)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(552,183,336,71,image)
	GUI.Label(580, 188, 54.2, 30, "银两:"..cfg_copyMap.money, GUIStyleLabel.Left_25_Black)
	GUI.Label(580, 220, 54.2, 30, "经验:"..cfg_copyMap.exp, GUIStyleLabel.Left_25_Black)
	
	GUI.Label(587, 263, 54.2, 30, "随机奖励", GUIStyleLabel.Left_25_Brown)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(552,300,336,120,image)
	
	-- if cfg_copyMap.award1 ~= 0 then
		-- local cfg_item = CFG_item[cfg_copyMap.award1]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if GUI.TextureButton(575,306,80,80,image,0,0,1,1,6,6,6,6) then
			-- mItemViewPanel.SetData(cfg_item.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
		-- GUI.Label(573.5, 387, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
	-- end
	-- if cfg_copyMap.award2 ~= 0 then
		-- local cfg_item = CFG_item[cfg_copyMap.award2]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if GUI.TextureButton(682,306,80,80,image,0,0,1,1,6,6,6,6) then
			-- mItemViewPanel.SetData(cfg_item.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
		-- GUI.Label(680, 387, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
	-- end
	-- if cfg_copyMap.award3 ~= 0 then
		-- local cfg_item = CFG_item[cfg_copyMap.award3]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if GUI.TextureButton(788,305,80,80,image,0,0,1,1,6,6,6,6) then
			-- mItemViewPanel.SetData(cfg_item.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
		-- GUI.Label(786, 387, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
	-- end
	
	-- DrawAward(mAwardList[1],575-10,306+7)
	-- DrawAward(mAwardList[2],682-10,306+7)
	-- DrawAward(mAwardList[3],788-10,305+7)
	
	local spacing = 120
	local count = #mAwardList
	mScrollPositionX,_ = GUI.BeginScrollView(556,300 - 10,320,150, mScrollPositionX, 0, -15, -10,count*spacing, 66)
		for k = 1 , count do
		  DrawAward(mAwardList[k],(spacing * k)-spacing,10)
		end
	GUI.EndScrollView()
	
	local maxCopyId = mCopyMapManager.GetMaxCopyMapId()
	if maxCopyId >= mCopyMapId then
		if GUI.Button(508,436,111,60,nil,GUIStyleButton.CleanBtn) then
			if mCopyMapManager.GetCleaning() then
				local cleanInfo = mCopyMapManager.GetCleanInfo()
				mCopyMapId = cleanInfo.id
			end
			mCopyMapCleanPanel.SetData(mCopyMapId)
			mPanelManager.Show(mCopyMapCleanPanel)
			mPanelManager.Hide(OnGUI)
			return
		end
	end
	
	if GUI.Button(320,436,111,60,nil,GUIStyleButton.FightBtn) then
		if mCopyMapManager.GetCleaning() then
			mSystemTip.ShowTip("扫荡中无法继续挑战")
			return
		end
		if hero.SceneType ~= SceneType.Harbor then
			mAlert.Show("在港口内才能挑战副本,是否返回回港口？",
				function()
					mHeroManager.GotoHarbor()
					mPanelManager.Show(mMainPanel)
					mPanelManager.Hide(OnGUI)
					mPanelManager.Hide(mCopyMapPanel)
					mSceneManager.SetMouseEvent(true)
				end)
		end
		
		local cost = mCopyMapManager.BuyCountCost(1)
		if hero.copyMapCount <= 0 and mCostTip then
			-- if not mVipManager.CopyMapCountBuy() then
				-- mSystemTip.ShowTip("当前活力不足，无法挑战")
				-- return
			-- end
			
			if not mVipManager.CopyMapCountBuy() then
				mAlert.Show("活力购买次数已用完，提升VIP等级可继续购买，是否前往充值？", mCommonlyFunc.Recharge)
				return
			end
			
			function OkFunc(showTip)
				if not mCommonlyFunc.HaveGold(cost) then
					return
				end
				RequestEnter(mCopyMapId)
				mCostTip = not showTip
			end
			mSelectAlert.Show("当前活力不足，是否花费"..cost.."元宝购买1点活力", OkFunc)
		else
			if hero.copyMapCount <= 0 and not mCommonlyFunc.HaveGold(cost) then
				return
			end
			RequestEnter(mCopyMapId)
		end
	end
	
	if GUI.Button(698,436,111,60,nil,GUIStyleButton.CancelBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(863, 76, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function DrawAward(award, x, y)
	if not award then
		return 
	end
	if DrawItemCell(award, award.type, x, y) then

	end
	if award.firstAward then
		local image = mAssetManager.GetAsset("Texture/GUI/Bg/firstAward")
		GUI.DrawTexture(x+35,y-5,64,64,image)
	end
	-- if type == 1 then
		-- local cfg_equip = CFG_Equip[id]
		-- local image = mAssetManager.GetAsset("Texture/GUI/Bg/equipSlot1_"..cfg_equip.quality)
		-- GUI.DrawTexture(x,y,80,80,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(x+5,y+5,70,70,image) then
			-- mEquipViewPanel.SetData(nil, {id=id,star=0,notExist=true})
			-- mPanelManager.Show(mEquipViewPanel)
		-- end
		-- local info = cfg_equip.name
		-- GUI.Label(x, y+82, 80, 30, info, GUIStyleLabel.Center_20_Black)
	-- else
		-- local cfg_item = CFG_item[id]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if GUI.TextureButton(x, y,80,80,image,0,0,1,1,6,6,6,6) then
			-- mItemViewPanel.SetData(id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
		-- local info = cfg_item.name
		-- GUI.Label(x, y+82, 80, 30, info, GUIStyleLabel.Center_20_Black)
	-- end
end


function RequestEnter(mCopyMapId)
	if mShipManager.CheckDutyShip(SetShipFunc) then
		mCopyMapManager.Enter(mCopyMapId)
	end
end

function SetShipFunc()
	mPanelManager.Hide(mCopyMapPanel)
	mPanelManager.Hide(OnGUI)
end
