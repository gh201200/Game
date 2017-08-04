local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item = ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item
local AssetType,os,EventType,DrawItemCell= AssetType,os,EventType,DrawItemCell
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mVipManager = require "LuaScript.Control.Data.VipManager"
local mCharManager = nil
local mPanelManager = nil
local mCopyMapManager = nil
local mItemViewPanel = nil
local mEquipViewPanel = nil
local mItemManager = nil
local mEquipManager = nil
local mAlert = nil
local mSelectAlert = nil
local mEventManager = nil
local mSetManager = nil
local mSystemTip = nil

module("LuaScript.View.Panel.CopyMap.CopyMapCleanPanel") -- 副本扫荡面板
panelType = ConstValue.AlertPanel
local mCopyMapId = 1
local mRound = 1
local mCount = 0
local mMaxCount = 10
local mShowCleanData = {}
-- local mCostTip = nil

function SetData(id)
	mCopyMapId = id
	
	-- if mVipManager.CopyMapCountBuy() then
		mMaxCount = 10
	-- else
		-- local hero = mHeroManager.GetHero()
		-- mMaxCount = math.max(math.min(10, hero.copyMapCount), 1)
	-- end
	
	mCount = mMaxCount
end

-- function Display()
	-- mCostTip = mSetManager.GetCostTip()
-- end

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCopyMapManager = require "LuaScript.Control.Data.CopyMapManager"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	
	mEventManager.AddEventListen(nil, EventType.CopyMapAward, CopyMapAward)
	mEventManager.AddEventListen(nil, EventType.CopyMapCleanOver, CopyMapCleanOver)
	
	IsInit = true
end

function CopyMapAward(target, eventType, param)
	local cleaning = mCopyMapManager.GetCleaning()
	if cleaning then
		mRound = param
	end
end
function CopyMapCleanOver()
	-- if not mVipManager.CopyMapCountBuy() then
		-- local hero = mHeroManager.GetHero()
		-- mMaxCount = math.min(10, hero.copyMapCount)
		
		-- mCount = math.min(mCount, mMaxCount)
	-- end
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
	
	GUI.Label(268, 238, 154.2, 30, "当前活力："..hero.copyMapCount, GUIStyleLabel.Left_25_Brown)
	if GUI.Button(432, 227, 50, 50,nil, GUIStyleButton.AddBtn) then
		if not mVipManager.CopyMapCountBuy() then
			mAlert.Show("活力购买次数已用完，提升VIP等级可继续购买，是否前往充值？", mCommonlyFunc.Recharge)
			return
		end
		
		local cost = mCopyMapManager.BuyCountCost(1)
		function okFun()
			if not mCommonlyFunc.HaveGold(cost) then
				return
			end
			mCopyMapManager.RequestAddCount()
		end
		mAlert.Show("是否花费"..cost.."元宝购买1点活力", okFun)
	end
	
	GUI.Label(268, 285, 154.2, 30, "扫荡次数："..math.floor(mCount), GUIStyleLabel.Left_25_Brown)
	GUI.Label(268, 330, 154.2, 30, "调整：", GUIStyleLabel.Left_25_Brown)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(550,174,336,248,image)
	GUI.Label(560, 135, 54.2, 30, "获得奖励", GUIStyleLabel.Left_30_Black)
	
	local cleanInfo = mCopyMapManager.GetCleanInfo()
	local cleaning = mCopyMapManager.GetCleaning()
	if GUI.Button(565, 189, 40, 59,nil, GUIStyleButton.LeftBtn) then
		if cleanInfo and cleanInfo.awardInfo[mRound-1] then
			mRound = mRound - 1
		end
	end
	if GUI.Button(830, 189, 40, 59,nil, GUIStyleButton.RightBtn) then
		if cleanInfo and cleanInfo.awardInfo[mRound+1] then
			mRound = mRound + 1
		end
	end
	
	
	if cleaning then
		GUI.HorizontalSlider(338.5, 333.3, 165, 27, mCount, 1, mMaxCount, GUIStyleButton.HorizontalScrollBg,GUIStyleButton.HorizontalThumb)
	
		local cd = cleanInfo.cd + cleanInfo.updateTime - os.oldTime
		local cdStr = mCommonlyFunc.GetFormatTime(cd)
		GUI.Label(268, 375, 240.45, 30, "剩余时间:"..cdStr, GUIStyleLabel.Left_25_Brown)
		
		
		if GUI.Button(368.6,440.4,111,60,nil,GUIStyleButton.SpeedUpBtn) then
			local money = mCommonlyFunc.CdToMoney(cd)
			-- if mCostTip then
				function OkFunc()
					if not mCommonlyFunc.HaveGold(money) then
						return
					end
					mCopyMapManager.RequestSpeedUp()
					-- mCostTip = not showTip
				end
				mAlert.Show("是否花费"..money.."元宝,快速完成？", OkFunc)
			-- else
				-- if not mCommonlyFunc.HaveGold(money) then
					-- return
				-- end
				-- mCopyMapManager.RequestSpeedUp()
			-- end
		end
	else
		mCount = GUI.HorizontalSlider(338.5, 333.3, 165, 27, mCount, 1, mMaxCount, GUIStyleButton.HorizontalScrollBg,GUIStyleButton.HorizontalThumb)
		
		local intCount = math.floor(mCount)
		local cdStr = mCommonlyFunc.GetFormatTime(intCount*300)
		GUI.Label(268, 375, 240.45, 30, "剩余时间:"..cdStr, GUIStyleLabel.Left_25_Brown)
		
		if GUI.Button(368.6,440.4,111,60,nil,GUIStyleButton.CleanBtn) then
			if not mVipManager.CopyMapCountBuy(intCount-hero.copyMapCount) then
				-- mSystemTip.ShowTip("当前活力不足，无法挑战")
				mAlert.Show("活力购买次数不足，提升VIP等级可继续购买，是否前往充值？", mCommonlyFunc.Recharge)
				return
			end
			if mCount <= 0 then
				mSystemTip.ShowTip("请调整挑战次数")
				return
			end
			-- if not mVipManager.CopyMapCountBuy() then
				-- mAlert.Show("活力购买次数已用完，提升VIP等级可继续购买，是否前往充值？", mCommonlyFunc.Recharge)
				-- return
			-- end
			
			local lackCount = intCount - hero.copyMapCount
			local cost = mCopyMapManager.BuyCountCost(lackCount)
			if intCount > hero.copyMapCount then
				function OkFunc()
					if not mCommonlyFunc.HaveGold(cost) then
						return
					end
					mCopyMapManager.RequestClean(mCopyMapId, intCount)
					-- mCostTip = not showTip
				end
				mAlert.Show("当前活力不足，是否花费"..cost.."元宝购买"..lackCount.."点活力", OkFunc)
			else
				if not mCommonlyFunc.HaveGold(cost) then
					return
				end
				mCopyMapManager.RequestClean(mCopyMapId, intCount)
			end
		end
	end
	
	
	if cleanInfo then
		local award = cleanInfo.awardInfo[mRound]
		if award then
			GUI.Label(568, 264.8, 54.2, 30, "银两:"..award.money, GUIStyleLabel.Left_25_Black)
			GUI.Label(734, 264.8, 54.2, 30, "经验:"..award.exp, GUIStyleLabel.Left_25_Black)
			DrawAward(award.items[1],576,304)
			DrawAward(award.items[2],681,304)
			DrawAward(award.items[3],785,304)
		else
			mRound = cleanInfo.maxCount - cleanInfo.count + 1
			GUI.Label(657, 264.8, 124.2, 30, "正在扫荡中", GUIStyleLabel.Center_25_Black)
		end
	end
	GUI.Label(651, 198.8, 144.2, 30, "第"..mRound.."回合", GUIStyleLabel.Center_35_Black)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/horizontalScrollBg")
	GUI.DrawTexture(571,250,285,3,image)
	
	if GUI.Button(704.2,436.5,111,60,nil,GUIStyleButton.CancelBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(871.5, 78.5, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end

function DrawAward(award, x, y)
	if not award then
		return 
	end
	if DrawItemCell(award,award.type,x,y,70,70) then

	end
end
