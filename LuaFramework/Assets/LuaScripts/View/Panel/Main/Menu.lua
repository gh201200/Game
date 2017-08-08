local mMainPanel = nil
local mItemBagPanel = nil
local mTaskPanel = nil
local mChatPanel = nil
local mAlert = nil
local mFamilyPanel = nil
local mFamilyListPanel = nil
local mFriendPanel = nil
local mHeroPanel = nil
local mSystemTip = nil
local mFleetPanel = nil
local mActivityManager = nil
local mEventManager = nil
local mActionManager = nil
local mPanelManager = nil
local mTaskManager = nil
local mMapPanel = nil
local mRankPanel = nil
local mActivityPanel = nil
local mLoginAwardPanel = nil
local mPassPanel = nil
local mSettingPanel = nil
local mGMChatPanel = nil
local mCopyMapPanel = nil
local mFishTip = nil
local mHarborManager = nil
local mFirstRechange = nil
local mDailyPanel = nil
local mBossDuel = nil
local menuSwitch = true

module("LuaScript.View.Panel.Main.Menu",package.seeall)
--按钮切换动画
local changeTime = 0
local totalTime = 0.2
local mChangingMode = false

--按钮布局数据列表
local mAButtonLayout = nil
local mBButtonLayout = nil

--显示方式 0显示AButton  1显示BButton
local mShowMode = 0

local pivotPoint = nil
function Init()
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	mTaskPanel = require "LuaScript.View.Panel.Task.TaskPanel"
	mChatPanel = require "LuaScript.View.Panel.Chat.ChatPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
	mFamilyListPanel = require "LuaScript.View.Panel.Family.FamilyListPanel"
	mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mMapPanel = require "LuaScript.View.Panel.Map.MapPanel"
	mRankPanel = require "LuaScript.View.Panel.Rank.RankPanel"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mLoginAwardPanel = require "LuaScript.View.Panel.Activity.LoginAward.LoginAwardPanel"
	mPassPanel = require "LuaScript.View.Panel.Pass.PassPanel"
	mSettingPanel = require "LuaScript.View.Panel.SettingPanel"
	mGMChatPanel = require "LuaScript.View.Panel.Chat.GMChatPanel"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mFishTip = require "LuaScript.View.Tip.FishTip"
	mFirstRechange = require "LuaScript.View.Panel.FirstRechange.FirstRechange"
	mBossDuel = require "LuaScript.View.Panel.BossList.BossListPanel"
	
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mActionManager = require "LuaScript.Control.ActionManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mDailyPanel = require "LuaScript.View.Panel.Daily.DailyPanel"
	
	pivotPoint = Vector2.New(GUI.HorizontalRestX(1070+45/2),GUI.VerticalRestY(531+70/2))
	
	mEventManager.AddEventListen(nil, EventType.RefreshMainBtn, InitPost)
	mEventManager.AddEventListen(nil, EventType.OnNewAction, InitPost)
	mEventManager.AddEventListen(nil, EventType.ShowAllBtn, ShowAllBtn)
	
	InitPost()
end


function InitPost()
	-- print("InitPost")
	local x = 1060
	local y = 500
	local btnWidth = 128
	local btnHeight = 128
	local spening = 105
	
	mAButtonLayout = {}
	
	if mActionManager.GetActionOpen(ActionType.Map) then
		x = x - spening
		mAButtonLayout[ActionType.Map] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Hero) then
		x = x - spening
		mAButtonLayout[ActionType.Hero] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Daily) then
		x = x - spening
		mAButtonLayout[ActionType.Daily] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Friend) then
		x = x - spening
		mAButtonLayout[ActionType.Friend] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Family) then
		x = x - spening
		mAButtonLayout[ActionType.Family] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Fleet) then
		x = x - spening
		mAButtonLayout[ActionType.Fleet] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Item) then
		x = x - spening
		mAButtonLayout[ActionType.Item] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Sailor) then
		x = x - spening
		mAButtonLayout[ActionType.Sailor] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	

	
	local x = 1060
	mBButtonLayout = {}
	
	if mActionManager.GetActionOpen(ActionType.Set) then
		x = x - spening
		mBButtonLayout[ActionType.Set] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Rank) then
		x = x - spening
		mBButtonLayout[ActionType.Rank] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.CopyMap) then
		x = x - spening
		mBButtonLayout[ActionType.CopyMap] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.DieFight) then
		x = x - spening
		mBButtonLayout[ActionType.DieFight] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Sign) then
		x = x - spening
		mBButtonLayout[ActionType.Sign] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	
	if mActionManager.GetActionOpen(ActionType.Activity) then
		x = x - spening
		mBButtonLayout[ActionType.Activity] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
	if mActionManager.GetActionOpen(ActionType.BossDuel) then
		x = x - spening
		mBButtonLayout[ActionType.BossDuel] = {defaultX=x,x=x,y=y,width=btnWidth,height=btnHeight}
	end
end

function GetButtonPosition(actiontType)
	if not mAButtonLayout then
		return
	end
	local layout = mAButtonLayout[actiontType] or mBButtonLayout[actiontType]
	if layout then
		return layout.x, layout.y, 128, 128
	end
end

function GetShowMode()
	return mShowMode
end

function ChangePos()
	local overtime = math.min(os.oldClock - changeTime, totalTime)
	local smallList = nil
	local bigList = nil
	if mShowMode == 0 then
		smallList = mAButtonLayout
		bigList = mBButtonLayout
	else
		smallList = mBButtonLayout
		bigList = mAButtonLayout
	end
	
	for k,v in pairs(smallList) do
		v.width = math.max(128-128*overtime*10, 0)
		v.height = math.max(128-128*overtime*10, 0)
		v.x = math.min((1060 - v.defaultX) * overtime / totalTime * 2 + v.defaultX,  1060)
		v.y = 500 + 128 - v.height
	end
	
	for k,v in pairs(bigList) do
		v.width = math.max(128*overtime*10-128, 0)
		v.height = math.max(128*overtime*10-128, 0)
		v.x = math.min(1060 + (1060 - v.defaultX)  -  (1060 - v.defaultX) * overtime / totalTime * 2, 1060)
		v.y = 500 + 128 - v.height
	end
	
	if totalTime <= overtime then
		mShowMode = (mShowMode+1)%2
		mChangingMode = false
		AppearEvent(nil, EventType.OnRefreshGuide)
	end
end

function ShowAllBtn(_,_,id)
	if id ~= mShowMode then
		mChangingMode = true
		changeTime = os.oldClock
	end
end

function OnGUI()
	local mHero = mHeroManager.GetHero()
	-- "聊天",
	if mActionManager.GetActionOpen(ActionType.Chat) then
		if GUI.Button(1018,413,128,128,nil,GUIStyleButton.ChatBtn) then
			mPanelManager.Show(mChatPanel)
		end
		DrawRedPoint(1038, 410, mChatPanel.GetNewCount())
	end

	
	-- 首冲元宝按钮
	-- if mHero.firstRecharge == 0 and mHeroManager.GetFirstRecharge() then
		-- GUI.FrameAnimation(-63,95+20,256,256,"firstRechange") -- 帧动画
		-- GUI.FrameAnimation(-63,95+30,256,256,"top_tip",9,0.1)
		-- if GUI.Button(17,177+20,88,88,nil,GUIStyleButton.Transparent_Art_30) then
			-- mPanelManager.Show(mFirstRechange)
		-- end
		-- local image = mAssetManager.GetAsset("Texture/Gui/Button/firstCharge")
		-- GUI.DrawTexture(-4,159+20,128,128,image)
	-- end
	
	if VersionCode > 1 then
	local image = mAssetManager.GetAsset("Texture/Gui/Button/Menu_switch_1")
	if menuSwitch then 
		image = mAssetManager.GetAsset("Texture/Gui/Button/Menu_switch_1") 
	elseif not menuSwitch then 
		image = mAssetManager.GetAsset("Texture/Gui/Button/Menu_switch_2")
	end
	GUI.DrawTexture(1072+10,576+10,64,64,image)
	if GUI.Button(1136-50,610,50,30,nil,GUIStyleButton.Transparent) then
	   menuSwitch = not menuSwitch
	end
	end
    -- 菜单的显示和隐藏
	if not menuSwitch then
	   return
	end
	
	
	--ios test script
	if IosTestScript then
	
	elseif mActivityManager.CouldFish() then
		if GUI.Button(330,80,81,73,nil,GUIStyleButton.Fish) and not mFishTip.visible then
			mActivityManager.RequestFish()
			mHeroManager.StopMove()
		end
		if not mActivityManager.FishActivity() then
			GUI.Label(368,120,30,25,90-mHero.fish,GUIStyleLabel.Left_20_Lime, Color.Black)
		end
	end
	
	-- local mAngle = 0
	local overtime = math.min(os.oldClock - changeTime, totalTime)
	
	local mAngle = 0
	if mChangingMode then
		mAngle = overtime/totalTime * 180
	end
	
	local styleButton = GUIStyleButton.RightBtn_3
	if mShowMode == 1 then
		styleButton = GUIStyleButton.LeftBtn_3
	end
	GUIUtility.RotateAroundPivot(-mAngle, pivotPoint)
	if GUI.Button(1070,531,45,70,nil,styleButton) then
		-- mShowMode = (mShowMode + 1) % 2
		mChangingMode = true
		changeTime = os.oldClock
	end
	GUIUtility.RotateAroundPivot(mAngle, pivotPoint)
	
	local topRight = 25 -- 控制红点提示位置，正往右，负往左
	--点击切换按钮后 动态修改按钮坐标
	if mChangingMode then
		ChangePos()
	end
	
	if mShowMode == 0 or mChangingMode then
		--"地图",
		local layout = mAButtonLayout[ActionType.Map]
		if layout and mActionManager.GetActionOpen(ActionType.Map) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.MapBtn) then
				mMapPanel.ResetCenter()
				mPanelManager.Show(mMapPanel)
				mPanelManager.Hide(mMainPanel)
				mSceneManager.SetMouseEvent(false)
				
			end
			--DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount()) --红点
		end
		
		--"玩家信息" 详情,
		local layout = mAButtonLayout[ActionType.Hero]
		if layout and  mActionManager.GetActionOpen(ActionType.Hero) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.InfoBtn) then
				if mHarborManager.GetNewCount() > 0 then
					mHeroPanel.mPage = 2
				end
				mPanelManager.Show(mHeroPanel)
				-- mPanelManager.Hide(mMainPanel)
				-- mSceneManager.SetMouseEvent(false)
			end
			DrawRedPoint(layout.x+22, layout.y-10, mHarborManager.GetNewCount())--红点
		end
		
		--"日常",
		if mActionManager.GetActionOpen(ActionType.Daily) then
			local layout = mAButtonLayout[ActionType.Daily]
			if layout and GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.DailyBtn) then
				mPanelManager.Show(mDailyPanel)
			end
			-- DrawRedPoint(layout.x+22, layout.y-10, mHarborManager.GetNewCount())
		end
		
		--"好友",
		local layout = mAButtonLayout[ActionType.Friend]
		if layout and  mActionManager.GetActionOpen(ActionType.Friend) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.FriendBtn) then
				mFriendPanel.Show()
			end
			DrawRedPoint(layout.x+topRight, layout.y, mFriendPanel.GetNewCount())--红点
		end
		
		--"联盟",
		local layout = mAButtonLayout[ActionType.Family]
		if layout and mActionManager.GetActionOpen(ActionType.Family) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.FamilyBtn) then
				local family = mFamilyManager.GetFamilyInfo()
				if family then
					if mFamilyManager.GetNewCount() > 0 then
						mFamilyPanel.SetPage(4)
					end
					mPanelManager.Show(mFamilyPanel)
					mPanelManager.Hide(mMainPanel)
					mSceneManager.SetMouseEvent(false)
					
				else
					mPanelManager.Show(mFamilyListPanel)
					mPanelManager.Hide(mMainPanel)
					mSceneManager.SetMouseEvent(false)
					
				end
			end
			DrawRedPoint(layout.x + topRight, layout.y, mFamilyManager.GetNewCount())--红点
		end

		
		--"舰队",
		if mActionManager.GetActionOpen(ActionType.Fleet) then
			local layout = mAButtonLayout[ActionType.Fleet]
			if layout and GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.ShipsBtn) then
				mPanelManager.Show(mFleetPanel)
				mPanelManager.Hide(mMainPanel)
				mSceneManager.SetMouseEvent(false)
				
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())--红点
		end
		
		--"物品",
		if mActionManager.GetActionOpen(ActionType.Item) then
			local layout = mAButtonLayout[ActionType.Item]
			if layout and GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.ItemBtn) then
				mPanelManager.Show(mItemBagPanel)
				mPanelManager.Hide(mMainPanel)
				mSceneManager.SetMouseEvent(false)
				
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())--红点
		end
		
		--"船员",
		if mActionManager.GetActionOpen(ActionType.Sailor) then
			local layout = mAButtonLayout[ActionType.Sailor]
			if layout and GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.HeroBtn) then
				mPanelManager.Show(mSailorPanel)
				mPanelManager.Hide(mMainPanel)
				mSceneManager.SetMouseEvent(false)
				
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())--红点
		end
	end
	
	
	if mShowMode == 1 or mChangingMode then
		--"设置",
		local layout = mBButtonLayout[ActionType.Set]
		if layout and mActionManager.GetActionOpen(ActionType.Set) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.SettingBtn) then
				mPanelManager.Hide(mMainPanel)
				mPanelManager.Show(mSettingPanel)
				mSceneManager.SetMouseEvent(false)
				
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())
		end
		
		--"排行榜",
		if mActionManager.GetActionOpen(ActionType.Rank) then
			local layout = mBButtonLayout[ActionType.Rank]
			if layout and GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.Rank) then
				mPanelManager.Show(mRankPanel)
				mPanelManager.Hide(mMainPanel)
				
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())
		end
		
		--"副本",
		if mActionManager.GetActionOpen(ActionType.CopyMap) then
			local layout = mBButtonLayout[ActionType.CopyMap]
			if layout and GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.CopyMapBtn) then
				mPanelManager.Hide(mMainPanel)
				mPanelManager.Show(mCopyMapPanel)
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())
		end
	
		--"血战",
		if mActionManager.GetActionOpen(ActionType.DieFight) then
			local layout = mBButtonLayout[ActionType.DieFight]
			if layout and GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.PassBtn) then
				-- if mHero.level < 30 then
					-- mSystemTip.ShowTip("30级开放血战系统")
					-- return
				-- end
				-- if InBattle then
					-- mSystemTip.ShowTip("战斗中无法开启该界面")
					-- return
				-- end
				mPanelManager.Show(mPassPanel)
				mPanelManager.Hide(mMainPanel)
				
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())
		end
	
		--"签到",
		local layout = mBButtonLayout[ActionType.Sign]
		if layout and mActionManager.GetActionOpen(ActionType.Sign) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.SignButton) then
				mPanelManager.Show(mLoginAwardPanel)
				mPanelManager.Hide(mMainPanel)
			end
			-- DrawRedPoint(layout.x, layout.y, mFriendPanel.GetNewCount())
		end
	
		--"活动",
		local layout = mBButtonLayout[ActionType.Activity]
		if layout and mActionManager.GetActionOpen(ActionType.Activity) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.ActivityBtn) then
				mPanelManager.Show(mActivityPanel)
				mPanelManager.Hide(mMainPanel)
				mSceneManager.SetMouseEvent(false)
			end
			DrawRedPoint(layout.x+topRight, layout.y, mActivityManager.GetNewCount())
		end
		
		--"BOSS列表",
		local layout = mBButtonLayout[ActionType.BossDuel]
		if layout and mActionManager.GetActionOpen(ActionType.BossDuel) then
			if GUI.Button(layout.x,layout.y,layout.width,layout.height,nil,GUIStyleButton.BossDuel) then
				mPanelManager.Show(mBossDuel)
			end
			DrawRedPoint(layout.x+topRight, layout.y, mBossDuel.GetNewCount())
		end
	end
	
	
	
end


function DrawRedPoint(x, y, count)
	if count <= 0 then
		return
	end
	x = x + 52
	y = y + 30
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
	GUI.DrawTexture(x, y, 32, 32, image)
	GUI.Label(x, y+3, 32, 32, count, GUIStyleLabel.Center_22_White)
end