local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,GUIStyleLabel,tostring,type,UnityEventType,Event,tonumber = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,GUIStyleLabel,tostring,type,UnityEventType,Event,tonumber
local SceneType,CFG_item,GUIStyleButton,ConstValue,os,Vector3,_G,table,GUIUtility,Vector2,CFG_role,CFG_map = 
SceneType,CFG_item,GUIStyleButton,ConstValue,os,Vector3,_G,table,GUIUtility,Vector2,CFG_role,CFG_map
local AssetType,AppearEvent,EventType,CFG_Exp,ActionType,CsWorldToScreenPoint,CsCurrentEventEqualsType = 
AssetType,AppearEvent,EventType,CFG_Exp,ActionType,CsWorldToScreenPoint,CsCurrentEventEqualsType
local CFG_harbor,string,AssetPath,platform,IPhonePlayer,IosTestScript = 
CFG_harbor,string,AssetPath,platform,IPhonePlayer,IosTestScript
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mMapPanel = nil
local mChatPanel = nil
local mBagPanel = nil
local mPanelManager = nil
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mGUIStyleManager = nil
local mCameraManager = nil
local mCommonlyFunc = nil
local mFamilyPanel = nil
local mFriendPanel = nil
local mFamilyListPanel = nil
local mLogbookPanel = nil
local mRechargePanel = nil
local mSettingPanel = nil
-- local mShipTeamPanel = nil
local mFamilyManager = nil
local mDialogPanel = nil
local mHeroPanel = nil
local mTaskPanel = nil
local mActionManager = nil
local mEventManager = nil
local mSystemTip = nil
local mAlert = nil
local mBattleManager = nil
local mBattleFieldManager = nil
local mActivityPanel = nil
local mFleetPanel = nil
local mTreasureTip = nil
local mProtectTip = nil
local mPowerUpTip = nil
local mItemUseTip = nil
local mRollItemTip = nil
local mActivityManager = nil
local mGMChatPanel = nil
local mBattleListTip = nil
local mHurtRankTip = nil
local mBossAwardTip = nil
local mFishTip = nil
local mAutoBusinessTip = nil
local mModePanel = nil
local mModeTip = nil
local mRankPanel = nil
local mUpdateNoticePanel = nil
local mLoginAwardPanel = nil
local mGuidePanel = nil
local mPassPanel = nil
local mSkillTip = nil
local mTaskManager = nil
local mBattleMapTip = nil
local mJoystick = nil

module("LuaScript.View.Panel.Main.Main")
notAutoClose = true
mShowAll = nil
mShowExAll = nil

local mShowToolBar = true

local mMaxAngle = 90
local mMaxOffsetX = 90
local mMaxOffsetY = 110

local mAngle = 0
local pivotPoint = nil

local offsetX = mMaxOffsetX
local offsetY = mMaxOffsetY
local changeTime = os.clock()

local mAction = nil
local mTime = 0
local modulus = 0

local mButtonPosition = {}
local mButtonWidth = {[ActionType.LogBook] = 115,
					  [ActionType.Friend] = 110,
					  [ActionType.Family] = 113,
					  [ActionType.Fleet] = 123,
					  [ActionType.Task] = 107,
					  [ActionType.Item] = 102,
					  [ActionType.Equip] = 102,
					  [ActionType.Sailor] = 105,
					  [ActionType.StarFate] = 100,}

function Init()
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	mModePanel = require "LuaScript.View.Panel.Mode.ModePanel"
	mModeTip = require "LuaScript.View.Tip.ModeTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mMapPanel = require "LuaScript.View.Panel.Map.MapPanel"
	mChatPanel = require "LuaScript.View.Panel.Chat.ChatPanel"
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
	mFamilyListPanel = require "LuaScript.View.Panel.Family.FamilyListPanel"
	mLogbookPanel = require "LuaScript.View.Panel.LogbookPanel"
	mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mSettingPanel = require "LuaScript.View.Panel.SettingPanel"
	-- mShipTeamPanel = require "LuaScript.View.Panel.ShipTeam.ShipTeamPanel"
	mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
	mTaskPanel = require "LuaScript.View.Panel.Task.TaskPanel"
	mActionManager = require "LuaScript.Control.ActionManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mTreasureTip = require "LuaScript.View.Tip.TreasureTip"
	mProtectTip = require "LuaScript.View.Tip.ProtectTip"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mPowerUpTip = require "LuaScript.View.Panel.PowerUp.PowerUpTip"
	mItemUseTip = require "LuaScript.View.Tip.ItemUseTip"
	mRollItemTip = require "LuaScript.View.Panel.Item.RollItemTip"
	mGMChatPanel = require "LuaScript.View.Panel.Chat.GMChatPanel"
	mBattleListTip = require "LuaScript.View.Tip.BattleListTip"
	mHurtRankTip = require "LuaScript.View.Tip.HurtRankTip"
	mBossAwardTip = require "LuaScript.View.Tip.BossAwardTip"
	mFishTip = require "LuaScript.View.Tip.FishTip"
	mRankPanel = require "LuaScript.View.Panel.Rank.RankPanel"
	mUpdateNoticePanel = require "LuaScript.View.Panel.Chat.UpdateNoticePanel"
	mLoginAwardPanel = require "LuaScript.View.Panel.Activity.LoginAward.LoginAwardPanel"
	mGuidePanel = require "LuaScript.View.Panel.Task.GuidePanel"
	mPassPanel = require "LuaScript.View.Panel.Pass.PassPanel"
	mStarSetPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
	mSkillTip = require "LuaScript.View.Tip.SkillTip"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mAutoBusinessTip = require "LuaScript.View.Tip.AutoBusinessTip"
	mBattleMapTip = require "LuaScript.View.Tip.BattleMapTip"
	mJoystick = require "LuaScript.View.Joystick"

	pivotPoint = Vector2.New(GUI.HorizontalRestX(1136-80),GUI.VerticalRestY(640-80))
	
	mEventManager.AddEventListen(nil, EventType.OnNewAction, OnNewAction)
	mEventManager.AddEventListen(nil, EventType.ShowAllBtn, ShowAllBtn)
	mEventManager.AddEventListen(nil, EventType.IntoBattleScene, IntoBattleScene)
	mEventManager.AddEventListen(nil, EventType.IntoNormalScene, IntoNormalScene)
	IsInit = true
	
	InitButtonPosition()
	
	mPanelManager.Show(mJoystick)
end

local mOldShowAll = false
function IntoBattleScene()
	mOldShowAll = mShowAll
	mShowAll = false
	mShowExAll = false
end

function IntoNormalScene()
	mShowAll = mOldShowAll or mShowAll
	mShowExAll = false
end

function InitButtonPosition()
	local x = 960
	local offsetX = 0
	-- [30] = "日志",
	if mActionManager.GetActionOpen(ActionType.LogBook) then
		x = x - mButtonWidth[ActionType.LogBook]
		mButtonPosition[ActionType.LogBook] = x
	end
	
	-- [30] = "好友",
	if mActionManager.GetActionOpen(ActionType.Friend) then
		x = x - mButtonWidth[ActionType.Friend]
		mButtonPosition[ActionType.Friend] = x
	end
	
	-- [14] = "联盟",
	if mActionManager.GetActionOpen(ActionType.Family) then
		x = x - mButtonWidth[ActionType.Family]
		mButtonPosition[ActionType.Family] = x
	end
	
	-- [13] = "舰队",
	if mActionManager.GetActionOpen(ActionType.Fleet) then
		x = x - mButtonWidth[ActionType.Fleet]
		mButtonPosition[ActionType.Fleet] = x
	end
	
	-- [32] = "任务",
	if mActionManager.GetActionOpen(ActionType.Task) then
		x = x - mButtonWidth[ActionType.Task]
		mButtonPosition[ActionType.Task] = x
	end
	
	-- [32] = "星运",
	if mActionManager.GetActionOpen(ActionType.StarFate) then
		x = x - mButtonWidth[ActionType.StarFate]
		mButtonPosition[ActionType.StarFate] = x
	end
	
	-- [32] = "物品",
	if mActionManager.GetActionOpen(ActionType.Item) then
		x = x - mButtonWidth[ActionType.Item]
		mButtonPosition[ActionType.Item] = x
	end
	
	-- [12] = "装备",
	if mActionManager.GetActionOpen(ActionType.Equip) then
		x = x - mButtonWidth[ActionType.Equip]
		mButtonPosition[ActionType.Equip] = x
	end
	
	-- [11] = "成员",
	if mActionManager.GetActionOpen(ActionType.Sailor) then
		x = x - mButtonWidth[ActionType.Sailor]
		mButtonPosition[ActionType.Sailor] = x
	end
end

function GuiIsIniting()
	return mShowAll and mAction and visible
end

function InScreen(x,y)
	return x > -80 and y > -80 and x < Screen.width+80 and y < Screen.height+80
end

function TipOnGUI()
	-- mTreasureTip.OnGUI()
	mProtectTip.OnGUI()
	mPowerUpTip.OnGUI(offsetY)
	mItemUseTip.OnGUI(offsetY)
	
	mBattleListTip.OnGUI()
	mFishTip.OnGUI()
	mModeTip.OnGUI()
	mAutoBusinessTip.OnGUI()
end


function OnGUI()
	if not IsInit then
		return
	end
	
	local mHero = mHeroManager.GetHero()
	local InBattle = (mHero.SceneType == SceneType.Battle)
	-- if not mHero.harborId then
		-- image = mAssetManager.GetAsset(AssetPath.Gui_Empty)
		-- GUI.DrawTexture(0, 0, 1136,640, image)
	-- end
	if not InBattle then
		image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg14_1)
		GUI.DrawTexture(0, 0, 512, 256, image)
		
		--地图
		if GUI.Button(0,99,55,56,nil,GUIStyleButton.MapBtn) then
			mMapPanel.ResetCenter()
			mPanelManager.Show(mMapPanel)
			mPanelManager.Hide(OnGUI)
			mSceneManager.SetMouseEvent(false)
			
		end
		
		image = mAssetManager.GetAsset(string.format(AssetPath.Gui_Character_HeroHeader,mHero.resId))
		local point = ConstValue.HeroHeaderPoint[mHero.resId]
		if GUI.TextureButton(point[1], point[2], 102, 102, image) then
			if mHarborManager.GetNewCount() > 0 then
				mHeroPanel.mPage = 2
			end
			mPanelManager.Show(mHeroPanel)
		end
		if mHarborManager.GetNewCount() > 0 then
			local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
			GUI.DrawTexture(0,10, 32, 32, image)
			GUI.Label(0,15, 32, 32,mHarborManager.GetNewCount(),GUIStyleLabel.Center_22_White)
		end
		
		
		local cfg_Exp = CFG_Exp[mHero.level]
		local progress = math.min(mHero.exp/cfg_Exp.exp, 1)
		image = mAssetManager.GetAsset(AssetPath.Gui_Bg_expBg_1)
		GUI.DrawTexture(54, 138, progress * 233, 7, image)
		
		--充值
		if not mHero.firstRecharge > 0 then
			if GUI.Button(231,0,144,89,nil,GUIStyleButton.First) then
				mCommonlyFunc.Recharge(true)
			end
		else
			if GUI.Button(241,5,60,58,nil,GUIStyleButton.RechargeBtn) then
				mCommonlyFunc.Recharge(true)
			end
			image = mAssetManager.GetAsset(ConstValue.GuiVipPath[mHero.vipLevel])
			GUI.DrawTexture(297, 3, 128, 32, image)
		end
		
		GUI.Label(85,108,24,25,mHero.level,GUIStyleLabel.Center_20_White)
		GUI.Label(157.8,25.7,300,25,mHero.gold,GUIStyleLabel.Left_20_Black)
		GUI.Label(167.3,65.15,300,25,mHero.money,GUIStyleLabel.Left_20_Black)
		if mHero.harborId then
			local cfg_harbor = CFG_harbor[mHero.harborId]
			GUI.Label(165,105,300,25,cfg_harbor.name,GUIStyleLabel.Left_20_Black)
		else
			if mHero.updatePositionTime ~= os.oldTime then
				mHero.updatePositionTime = os.oldTime
				mHero.positionStr = string.format("%d,%d",mHero.x,mHero.y)
			end
			GUI.Label(160,105,300,25, mHero.positionStr,GUIStyleLabel.Left_20_Black)
		end
		
		--ios test script
		if IosTestScript then
		
		elseif mActivityManager.CouldFish() then
			if GUI.Button(330,80,81,73,nil,GUIStyleButton.Fish) and not mFishTip.visible then
				mActivityManager.RequestFish()
				mHeroManager.StopMove()
			end
			GUI.Label(368,120,30,25,90-mHero.fish,GUIStyleLabel.Left_20_Lime, Color.Black)
		end
		
		TipOnGUI()
		
		
	else
		local mSuperSkillTime = mBattleFieldManager.GetSuperSkillTime()
		if mSuperSkillTime then
			local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_SuperSkill)
			GUI.DrawTexture(450, 0, 256, 128, image)
			
			GUI.Label(152,60,700,25,mCommonlyFunc.GetShortFormatTime(mSuperSkillTime),GUIStyleLabel.Center_30_Green,Color.Black)
		end
		mSkillTip.OnGUI()
		mBattleMapTip.OnGUI()
	end
	mHurtRankTip.OnGUI()
	mBossAwardTip.OnGUI()
	
	
	-- ios test script
	if IosTestScript then
	-- [32] = "签到",
	elseif not InBattle and (mHero.level >= 10 or _G.IsDebug) and not mGuidePanel.visible
		and not mDialogPanel.visible then
		local mLoginAward = mHeroManager.GetLoginAward()
		if (mLoginAward and not mLoginAward.geted) and GUI.Button(900,150,82,86,nil,GUIStyleButton.SignButton) then
			mPanelManager.Show(mLoginAwardPanel)
			mPanelManager.Hide(OnGUI)
			
		end
	end
	
	if mRollItemTip.visible then
		mRollItemTip.OnGUI()
		return
	end
	
	if not mShowToolBar then
		return
	end
	GUIAll()
	GUIBattleAll()
end

function GUIAll()
	local mHero = mHeroManager.GetHero()
	local InBattle = (mHero.SceneType == SceneType.Battle)
	if InBattle then
		return
	end
	
	local appearEvent = false
	GUIUtility.RotateAroundPivot(mAngle, pivotPoint)
	if GUI.Button(1136-160,640-160,160,160,nil,GUIStyleButton.MenuBtn_1) then
		mShowAll = not mShowAll
		changeTime = os.oldClock
		appearEvent = true
		
		if not mShowAll then
			mShowExAll = false
		end
	end
	GUIUtility.RotateAroundPivot(-mAngle, pivotPoint)
	image = mAssetManager.GetAsset(AssetPath.Gui_Text_menu)
	GUI.DrawTexture(1136-112, 640-121, 67, 77, image)
	if not mShowAll then
		local newCount = 0
		if mHero.level >= 10 or _G.IsDebug then
			newCount = newCount + mChatPanel.GetNewCount() + mActivityManager.GetNewCount() +
				mUpdateNoticePanel.GetNewCount() + mTaskManager.GetNewCount()
				
			--ios test script
			if IosTestScript then
				newCount = newCount - mActivityManager.GetNewCount()
			end
		end
		if mActionManager.GetActionOpen(ActionType.Friend) then
			newCount = newCount + mFriendPanel.GetNewCount() 
		end
		if mActionManager.GetActionOpen(ActionType.Family) then
			newCount = newCount + mFamilyManager.GetNewCount()
		end
		
		newCount = math.min(newCount, 99)
		
		if newCount > 0 then
			local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
			GUI.DrawTexture(1105,468, 32, 32, image)
			GUI.Label(1105,473, 32, 32, newCount,GUIStyleLabel.Center_22_White)
		end
	end
	
	
	local overTime = (os.oldClock - changeTime)*4
	if mShowAll then
		mAngle = math.min(overTime*mMaxAngle, mMaxAngle)
		offsetX = math.max((1-overTime)*mMaxOffsetX, 0)
		offsetY = math.max((1-overTime)*mMaxOffsetY, 0)
	else
		mAngle = math.max((1-overTime)*mMaxAngle, 0)
		-- print(mAngle)
		offsetX = math.min(overTime*mMaxOffsetX, mMaxOffsetX)
		offsetY = math.min(overTime*mMaxOffsetY, mMaxOffsetY)
	end
	
	if offsetY ~= mMaxOffsetY then
		
		--ios test script
		if IosTestScript then
		
		-- [32] = "活动",
		elseif mHero.level >= 10 or _G.IsDebug then
			if GUI.Button(1043+offsetX,215,93,88,nil,GUIStyleButton.ActivityBtn) then
				mPanelManager.Show(mActivityPanel)
				mPanelManager.Hide(OnGUI)
				mSceneManager.SetMouseEvent(false)
				
			end
			if mActivityManager.GetNewCount() > 0 then
				local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
				GUI.DrawTexture(1105+offsetX,218, 32, 32, image)
				GUI.Label(1105+offsetX,223, 32, 32, mActivityManager.GetNewCount(),GUIStyleLabel.Center_22_White)
			end
		end
		
		-- [32] = "聊天",
		if _G.IsDebug then
			if GUI.Button(1045+offsetX,300,100,50,"聊天",GUIStyleButton.ShortOrangeBtn) then
				mPanelManager.Show(mChatPanel)
			end
			if GUI.Button(1045+offsetX,345,100,50,"GM指令",GUIStyleButton.ShortOrangeBtn) then
				mPanelManager.Show(mGMChatPanel)
			end
			
			if mChatPanel.GetNewCount() > 0 then
				local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
				GUI.DrawTexture(1105+offsetX,284, 32, 32, image)
				GUI.Label(1105+offsetX,289, 32, 32, mChatPanel.GetNewCount(),GUIStyleLabel.Center_22_White)
			end
		elseif mHero.level >= 10 then
			if GUI.Button(1044+offsetX,309,86,65,nil,GUIStyleButton.ChatBtn) then
				mPanelManager.Show(mChatPanel)
			end
			
			if mChatPanel.GetNewCount() > 0 then
				local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
				GUI.DrawTexture(1105+offsetX,309, 32, 32, image)
				GUI.Label(1105+offsetX,314, 32, 32, mChatPanel.GetNewCount(),GUIStyleLabel.Center_22_White)
			end
		end
		
		if _G.IsDebug or mHero.level >= 10 then
			if mShowExAll then
				local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg44_1)
				GUI.DrawTexture(650,391,445,81,image, 0, 0, 1, 1, 34, 56, 0, 0)
				if GUI.Button(1049+offsetX,387,76,83,nil,GUIStyleButton.CloseButton) then
					mShowExAll = false
				end
				
				-- 设置
				if GUI.Button(952,372,93,82,nil,GUIStyleButton.SettingBtn) then
					mPanelManager.Hide(OnGUI)
					mPanelManager.Show(mSettingPanel)
					mSceneManager.SetMouseEvent(false)
					
				end
				if mUpdateNoticePanel.GetNewCount() > 0 then
					local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
					GUI.DrawTexture(952+55,367, 32, 32, image)
					GUI.Label(952+55,372, 32, 32, mUpdateNoticePanel.GetNewCount(),GUIStyleLabel.Center_22_White)
				end
				
				-- [32] = "排行榜",
				if mHero.level >= 10 or _G.IsDebug then
					if GUI.Button(853,363,108,89,nil,GUIStyleButton.Rank) then
						mPanelManager.Show(mRankPanel)
						mPanelManager.Hide(OnGUI)
						
					end
				end
				
				-- [32] = "签到",
				local mLoginAward = mHeroManager.GetLoginAward()
				if mLoginAward and GUI.Button(767,368,82,86,nil,GUIStyleButton.SignButton) then
					mPanelManager.Show(mLoginAwardPanel)
					mPanelManager.Hide(OnGUI)
					
				end
				
				-- [32] = "血战",
				if GUI.Button(684,370,81,94,nil,GUIStyleButton.PassBtn) then
					if mHero.level < 30 then
						mSystemTip.ShowTip("30级开放血战系统")
						return
					end
					if InBattle then
						mSystemTip.ShowTip("战斗中无法开启该界面")
						return
					end
					mPanelManager.Show(mPassPanel)
					mPanelManager.Hide(OnGUI)
					
				end
				
			else
				if GUI.Button(1028+offsetX,387,101,83,nil,GUIStyleButton.OpenButton) then
					mShowExAll = true
				end
				if mUpdateNoticePanel.GetNewCount() > 0 then
					local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
					GUI.DrawTexture(1105+offsetX,329+60, 32, 32, image)
					GUI.Label(1105+offsetX,334+60, 32, 32, mUpdateNoticePanel.GetNewCount(),GUIStyleLabel.Center_22_White)
				end
			end
		end
		
		
		if mAction then
			overTime = os.oldClock - mTime
			modulus = math.sin(math.pi*0.25) - math.sin(math.pi*overTime)
			if overTime > 0.75 then
				mAction = nil
				mTime = 0
				
				appearEvent = true
			end
		end
		
		local x = 960
		local offsetX = 0
		-- [30] = "日志",
		-- if mActionManager.GetActionOpen(ActionType.LogBook) then
			-- mButtonPosition[ActionType.LogBook] = x
			-- if mAction == ActionType.LogBook then
				-- offsetX = modulus * 100
			-- end
			-- if GUI.Button(x+offsetX,526.25+offsetY,100,111,nil,GUIStyleButton.LogbookBtn) then
				-- mPanelManager.Show(mLogbookPanel)
				-- mPanelManager.Hide(OnGUI)
				-- mSceneManager.SetMouseEvent(false)
				-- 
			-- end
		-- end
		
		-- [30] = "好友",
		if mActionManager.GetActionOpen(ActionType.Friend) then
			x = x - 110
			mButtonPosition[ActionType.Friend] = x
			if mAction == ActionType.Friend then
				offsetX = modulus * 110
			end
			if GUI.Button(x+offsetX,536+offsetY,110,102,nil,GUIStyleButton.FriendBtn) then
				mFriendPanel.Show()
			end
			
			if mFriendPanel.GetNewCount() > 0 then
				local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
				GUI.DrawTexture(x+offsetX+60,536+offsetY, 32, 32, image)
				GUI.Label(x+offsetX+60,541+offsetY, 32, 32, mFriendPanel.GetNewCount(),GUIStyleLabel.Center_22_White)
			end
		end
		
		-- [14] = "联盟",
		if mActionManager.GetActionOpen(ActionType.Family) then
			x = x - 113
			mButtonPosition[ActionType.Family] = x
			if mAction == ActionType.Family then
				offsetX = modulus * 113
			end
			if GUI.Button(x+offsetX,516.25+offsetY,113,122,nil,GUIStyleButton.FamilyBtn) then
				local family = mFamilyManager.GetFamilyInfo()
				if family then
					if mFamilyManager.GetNewCount() > 0 then
						mFamilyPanel.SetPage(4)
					end
					mPanelManager.Show(mFamilyPanel)
					mPanelManager.Hide(OnGUI)
					mSceneManager.SetMouseEvent(false)
					
				else
					mPanelManager.Show(mFamilyListPanel)
					mPanelManager.Hide(OnGUI)
					mSceneManager.SetMouseEvent(false)
					
				end
			end
			
			if mFamilyManager.GetNewCount() > 0 then
				local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
				GUI.DrawTexture(x+offsetX+60,536+offsetY, 32, 32, image)
				GUI.Label(x+offsetX+60,541+offsetY, 32, 32, mFamilyManager.GetNewCount(),GUIStyleLabel.Center_22_White)
			end
		end
		
		-- [13] = "舰队",
		if mActionManager.GetActionOpen(ActionType.Fleet) then
			x = x - 123
			mButtonPosition[ActionType.Fleet] = x
			if mAction == ActionType.Fleet then
				offsetX = modulus * 123
			end
			if GUI.Button(x+offsetX,513.3+offsetY,123,125,nil,GUIStyleButton.ShipsBtn) then
				mPanelManager.Show(mFleetPanel)
				mPanelManager.Hide(OnGUI)
				mSceneManager.SetMouseEvent(false)
				
			end
		end
		
		-- [32] = "任务",
		if mActionManager.GetActionOpen(ActionType.Task) then
			x = x - 107
			mButtonPosition[ActionType.Task] = x
			if mAction == ActionType.Task then
				offsetX = modulus * 107
			end
			if GUI.Button(x+offsetX,540+offsetY,107,98,nil,GUIStyleButton.TaskBtn) then
				mPanelManager.Show(mTaskPanel)
				mPanelManager.Hide(OnGUI)
				mSceneManager.SetMouseEvent(false)
			end
			
			if mTaskManager.GetNewCount() > 0 then
				local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
				GUI.DrawTexture(x+offsetX+60,536+offsetY, 32, 32, image)
				GUI.Label(x+offsetX+60,541+offsetY, 32, 32, mTaskManager.GetNewCount(),GUIStyleLabel.Center_22_White)
			end
		end
		
		-- [32] = "星运",
		if mActionManager.GetActionOpen(ActionType.StarFate) then
			x = x - 100
			mButtonPosition[ActionType.StarFate] = x
			if mAction == ActionType.StarFate then
				offsetX = modulus * 100
			end
			if GUI.Button(x+offsetX,527.3+offsetY,100,111,nil,GUIStyleButton.SkillBtn) then
				mPanelManager.Show(mStarSetPanel)
				mPanelManager.Hide(OnGUI)
				mSceneManager.SetMouseEvent(false)
			end
		end
		
		-- [32] = "物品",
		if mActionManager.GetActionOpen(ActionType.Item) then
			x = x - 102
			mButtonPosition[ActionType.Item] = x
			if mAction == ActionType.Item then
				offsetX = modulus * 102
			end
			if GUI.Button(x+offsetX,538.3+offsetY,102,100,nil,GUIStyleButton.ItemBtn) then
				mPanelManager.Show(mItemBagPanel)
				mPanelManager.Hide(OnGUI)
				mSceneManager.SetMouseEvent(false)
			end
		end
		
		-- [12] = "装备",
		if mActionManager.GetActionOpen(ActionType.Equip) then
			x = x - 102
			mButtonPosition[ActionType.Equip] = x
			if mAction == ActionType.Equip then
				offsetX = modulus * 102
			end
			if GUI.Button(x+offsetX,525.5+offsetY,102,113,nil,GUIStyleButton.EquipBtn) then
				mPanelManager.Show(mEquipBagPanel)
				mPanelManager.Hide(OnGUI)
				mSceneManager.SetMouseEvent(false)
			end
		end
		
		-- [11] = "成员",
		if mActionManager.GetActionOpen(ActionType.Sailor) then
			x = x - 105
			mButtonPosition[ActionType.Sailor] = x
			if mAction == ActionType.Sailor then
				offsetX = modulus * 105
			end
			if GUI.Button(x+offsetX,519.5+offsetY,105,119,nil,GUIStyleButton.HeroBtn) then
				mPanelManager.Show(mSailorPanel)
				mPanelManager.Hide(OnGUI)
				mSceneManager.SetMouseEvent(false)
			end
		end
	end
	if appearEvent then
		AppearEvent(nil, EventType.OnRefreshGuide)
	end
end

function GUIBattleAll()
	local mHero = mHeroManager.GetHero()
	local InBattle = (mHero.SceneType == SceneType.Battle)
	if not InBattle then
		return
	end
	
	
	if GUI.Button(1050,563,101,67,nil,GUIStyleButton.Run) then
		local battleTime = os.oldClock - mHero.BattleTime
		if battleTime > 60 then
			mAlert.Show("是否离开战场?",mBattleManager.RunAway)
		else
			mSystemTip.ShowTip(math.ceil(60-battleTime).."秒后才可逃跑")
		end
	end
	
	if mActionManager.GetActionOpen(ActionType.Friend) then
		if GUI.Button(1040,154,93,82,nil,GUIStyleButton.SettingBtn) then
			mFriendPanel.Show()
		end
	end
	
	if mActionManager.GetActionOpen(ActionType.Friend) then
		if GUI.Button(1040,229,96,68,nil,GUIStyleButton.Friend2Btn) then
			mFriendPanel.Show()
		end
		
		if mFriendPanel.GetNewCount() > 0 then
			local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
			GUI.DrawTexture(1105,233, 32, 32, image)
			GUI.Label(1105,238, 32, 32, mFriendPanel.GetNewCount(),GUIStyleLabel.Center_22_White)
		end
	end
	
	-- [32] = "聊天",
	if _G.IsDebug then
		if GUI.Button(1045,300,100,50,"聊天",GUIStyleButton.ShortOrangeBtn) then
			mPanelManager.Show(mChatPanel)
		end
		if GUI.Button(1045,345,100,50,"GM指令",GUIStyleButton.ShortOrangeBtn) then
			mPanelManager.Show(mGMChatPanel)
		end
		
		if mChatPanel.GetNewCount() > 0 then
			local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
			GUI.DrawTexture(1105,284, 32, 32, image)
			GUI.Label(1105,289, 32, 32, mChatPanel.GetNewCount(),GUIStyleLabel.Center_22_White)
		end
	elseif mHero.level >= 10 then
		if GUI.Button(1044,309,86,65,nil,GUIStyleButton.ChatBtn) then
			mPanelManager.Show(mChatPanel)
		end
		
		if mChatPanel.GetNewCount() > 0 then
			local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
			GUI.DrawTexture(1105,309, 32, 32, image)
			GUI.Label(1105,314, 32, 32, mChatPanel.GetNewCount(),GUIStyleLabel.Center_22_White)
		end
	end
		
end

function GetButtonPosition(type)
	-- print(type, mButtonPosition[type])
	return mButtonPosition[type], 525+offsetY, mButtonWidth[type]
end

function OnNewAction(target, eventType, actionId)
	if actionId == ActionType.Equip or actionId == ActionType.Item or 
		actionId == ActionType.Family or actionId == ActionType.Friend  then
		mAction = actionId
		mTime = os.oldClock
	end
end

function ShowAllBtn()
	mShowAll = true
	mAngle =  mMaxAngle
	offsetX = 0
	offsetY = 0
end

function HideToolbar()
	mShowToolBar = false
end

function ShowToolbar()
	mShowToolBar = true
end